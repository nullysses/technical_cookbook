# Recipe Stable ID Hardening Spec

## Objective

Make `Recipe#stable_id` a safe, stable routing identifier.

The `stable_id` field is not ordinary metadata. It is part of the public URL contract because `Recipe#to_param` returns `stable_id`, and controllers load recipes by `stable_id`. Therefore, changing a recipe title must not silently change the recipe URL.

---

## Current Behavior

Current model behavior:

```ruby
class Recipe < ApplicationRecord
  before_validation :infer_stable_id_from_title

  validates :stable_id, :title, :version, presence: true
  validates :stable_id, uniqueness: true

  def to_param
    stable_id
  end

  private

  def infer_stable_id_from_title
    self.stable_id = title.to_s.parameterize if title.present?
  end
end
```

Current problem:

```text
stable_id is recalculated before every validation
editing title can mutate the URL identity
title changes can cause slug collisions
old links/bookmarks can break
imported recipes rely on implicit slug generation
```

---

## Desired Behavior

`stable_id` should be:

```text
generated once
unique
URL-safe
non-mutating after creation
compatible with imports
safe under title edits
covered by model tests
```

---

## Requirements

### R1. Generate `stable_id` only on create

`stable_id` must be inferred from `title` only when a recipe is first created.

It must not be regenerated during ordinary updates.

Preferred callback:

```ruby
before_validation :infer_stable_id_from_title, on: :create
```

---

### R2. Preserve manually supplied `stable_id`

If a `stable_id` is already present before validation, the model must not overwrite it.

Required guard:

```ruby
return if stable_id.present?
```

This is important for future import flows, seed data, fixtures, or manually curated slugs.

---

### R3. Use URL-safe slug format

`stable_id` should use lowercase kebab-case:

```text
seitan-bbq-ribs
arroz-verde
vegan-kfc-style-seitan
```

Acceptable format:

```ruby
/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/
```

This rejects:

```text
"Seitan BBQ Ribs"
"seitan_bbq_ribs"
"seitan bbq ribs"
"seitan--bbq"
" seitan-bbq "
```

---

### R4. Handle collisions deterministically

If a generated slug already exists, append a numeric suffix.

Example:

```text
title: "BBQ Seitan"
stable_id: "bbq-seitan"

second recipe with same title:
stable_id: "bbq-seitan-2"

third recipe:
stable_id: "bbq-seitan-3"
```

This avoids validation failure for normal same-title creation while keeping the unique database index useful as a final protection layer.

---

### R5. Do not hide validation errors for missing title

If `title` is blank, do not generate a random slug as the primary behavior.

A blank title should fail validation normally.

Acceptable result:

```text
title can't be blank
stable_id can't be blank
```

Optional later improvement: customize validation messages to avoid duplicate noise.

---

### R6. Preserve `to_param`

Keep:

```ruby
def to_param
  stable_id
end
```

The routing contract remains slug-based.

---

### R7. Keep database uniqueness

The schema already has a unique index on `recipes.stable_id`.

Keep this index. Model-level uniqueness validation improves UX, but the database index is the real concurrency protection.

---

### R8. Avoid exposing `stable_id` in normal metadata form

The regular recipe metadata form should not include `stable_id` unless there is an explicit “advanced” or admin edit path.

Reason:

```text
stable_id is identity, not display text
ordinary edits should not mutate identity
manual slug editing creates broken-link risk
```

---

### R9. Add an explicit rename/slug-change path only if needed

If slug changes become necessary later, implement them deliberately.

Potential future flow:

```text
Edit stable ID
show warning
validate new slug
optionally store redirect from old slug to new slug
log/audit the change
```

Do not add this now unless needed.

---

## Proposed Implementation

### `app/models/recipe.rb`

```ruby
class Recipe < ApplicationRecord
  before_validation :infer_stable_id_from_title, on: :create

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :steps, -> { order(:order) }, dependent: :destroy
  has_many :technique_notes, dependent: :destroy
  has_many :substitutions, dependent: :destroy
  has_many :adjustments, dependent: :destroy
  has_one :storage, dependent: :destroy

  validates :stable_id, :title, :version, presence: true
  validates :stable_id, uniqueness: true
  validates :stable_id,
    format: {
      with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/,
      message: "must use lowercase letters, numbers, and single hyphens"
    },
    allow_blank: true

  def to_param
    stable_id
  end

  private

  def infer_stable_id_from_title
    return if stable_id.present?
    return if title.blank?

    self.stable_id = unique_stable_id_from(title)
  end

  def unique_stable_id_from(value)
    base = value.to_s.parameterize
    candidate = base
    suffix = 2

    while self.class.exists?(stable_id: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end

    candidate
  end
end
```

---

## Concurrency Note

The loop-based collision check is sufficient for normal local/single-user creation, but it is not a full concurrency guarantee.

Race condition:

```text
request A checks "bbq-seitan" available
request B checks "bbq-seitan" available
request A inserts
request B inserts and hits unique index violation
```

For this app, the database unique index is an acceptable final guard.

If this becomes multi-user or exposed, add retry-on-unique-violation behavior.

Optional future retry pattern:

```ruby
rescue ActiveRecord::RecordNotUnique
  retry_with_next_suffix
end
```

Do not add this until the app actually needs it.

---

## Importer Behavior

The current importer creates recipes from title/version and relies on model behavior for `stable_id`.

Recommended behavior for now:

```text
If import payload has no stable_id, generate from title.
If import payload later includes stable_id, preserve it.
If generated stable_id collides, suffix deterministically.
```

Optional future importer change:

```ruby
stable_id: data["stable_id"]
```

Only add this if the JSON import contract explicitly supports stable IDs.

---

## Controller Behavior

No route/controller change is required for this step.

Keep lookup by slug:

```ruby
def set_recipe
  @recipe = Recipe.find_by!(stable_id: params.expect(:id))
end
```

The important change is that normal title edits no longer mutate the identifier used by that lookup.

---

## Test Plan

Use model tests first. Controller/system tests are useful but secondary.

### Test 1: Generates stable ID from title on create

```ruby
test "generates stable_id from title on create" do
  recipe = Recipe.create!(title: "BBQ Seitan Ribs", version: "v1")

  assert_equal "bbq-seitan-ribs", recipe.stable_id
end
```

---

### Test 2: Does not change stable ID when title changes

```ruby
test "does not change stable_id when title changes" do
  recipe = Recipe.create!(title: "BBQ Seitan Ribs", version: "v1")
  original_stable_id = recipe.stable_id

  recipe.update!(title: "Better BBQ Seitan Ribs")

  assert_equal original_stable_id, recipe.reload.stable_id
end
```

---

### Test 3: Preserves manually supplied stable ID

```ruby
test "preserves manually supplied stable_id" do
  recipe = Recipe.create!(
    title: "BBQ Seitan Ribs",
    version: "v1",
    stable_id: "custom-seitan-ribs"
  )

  assert_equal "custom-seitan-ribs", recipe.stable_id
end
```

---

### Test 4: Adds suffix on collision

```ruby
test "adds numeric suffix when generated stable_id collides" do
  Recipe.create!(title: "BBQ Seitan", version: "v1")
  second = Recipe.create!(title: "BBQ Seitan", version: "v2")

  assert_equal "bbq-seitan-2", second.stable_id
end
```

---

### Test 5: Rejects invalid manual stable ID

```ruby
test "rejects invalid stable_id format" do
  recipe = Recipe.new(
    title: "BBQ Seitan",
    version: "v1",
    stable_id: "BBQ Seitan"
  )

  assert_not recipe.valid?
  assert_includes recipe.errors[:stable_id],
    "must use lowercase letters, numbers, and single hyphens"
end
```

---

### Test 6: `to_param` returns stable ID

```ruby
test "to_param returns stable_id" do
  recipe = Recipe.create!(title: "BBQ Seitan", version: "v1")

  assert_equal recipe.stable_id, recipe.to_param
end
```

---

## Acceptance Criteria

This change is complete when:

```text
1. Creating a recipe without stable_id generates one from title.
2. Editing a recipe title does not change stable_id.
3. Creating duplicate titles generates suffixed stable IDs.
4. Manually supplied valid stable_id is preserved.
5. Invalid stable_id values fail validation.
6. Recipe URLs continue using stable_id through to_param.
7. Existing routes/controllers still work.
8. The database unique index remains in place.
9. Model tests cover generation, immutability, collision, manual preservation, and format validation.
10. No ordinary user-facing form allows accidental stable_id mutation.
```

---

## Recommended Commit Scope

Keep this as one small, clean commit:

```text
app/models/recipe.rb
test/models/recipe_test.rb
```

Optional if importer stable IDs are added:

```text
app/services/nested_recipe_importer.rb
test/services/nested_recipe_importer_test.rb
```

Suggested commit message:

```text
Harden recipe stable IDs
```

---

## Implementation Priority

Do this before route nesting, nested editing, or more UI work.

Reason:

```text
stable_id is identity infrastructure
identity bugs create broken links and data ambiguity
UI improvements are easier after routing identity is stable
```
