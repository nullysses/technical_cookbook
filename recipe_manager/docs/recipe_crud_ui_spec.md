# Recipe CRUD UI Spec

## Goal

Create a clean, readable Rails CRUD interface for recipes that feels like a practical kitchen/reference tool, not a generated scaffold.

The form should support:

```text
fast entry
clear grouping
low visual clutter
good mobile behavior
future expansion for ingredients and steps
```

---

## Current Problem

The current generated CRUD form is functional but visually raw:

```text
narrow left-aligned form
no semantic grouping
weak page hierarchy
too many equal-weight fields
poor use of horizontal space
scaffold-like typography and spacing
```

The redesign should preserve Rails simplicity while making the interface feel deliberate.

---

## Visual Direction

Use a warm document/card layout:

```text
background: warm off-white
surface: white card
accent: muted green / dark teal
secondary accent: soft gold
text: dark slate
```

The app already has a dark top navigation bar, so retain that direction and make the body more structured.

---

## Page Structure

### Header

For the new recipe page:

```text
New recipe
Create a structured recipe entry with yield, diet, equipment, and source metadata.
```

For the edit recipe page:

```text
Edit recipe
Update recipe metadata, yield, and source notes.
```

### Main Layout

Use a centered container:

```text
max-width: 960px
padding: 32px 24px
```

Inside it, place the form in a card:

```text
white surface
subtle border
large border radius
soft shadow
internal padding
```

---

## Form Sections

### 1. Identity

Fields:

```text
Title       required, wide
Version     optional
Language    optional
```

Purpose: core recipe identity.

Layout:

```text
Title full width
Version and Language side by side on desktop
Single column on mobile
```

---

### 2. Classification

Fields:

```text
Diet
Tags
Equipment
```

Use textareas for now, but style them compactly. Later these can become chips/autocomplete fields.

Example helper content:

```text
Diet: vegan, gluten-free, high-protein
Tags: weeknight, Mexican, seitan, spicy
Equipment: oven, blender, pressure cooker
```

Layout:

```text
Diet and Tags side by side on desktop
Equipment full width
Single column on mobile
```

---

### 3. Yield and Servings

Fields:

```text
Servings count
Servings unit
Yield amount
Yield unit
Yield description
```

Layout:

```text
Servings count | Servings unit | Yield amount | Yield unit
Yield description full width
```

Example values:

```text
Servings count: 4
Servings unit: portions
Yield amount: 900
Yield unit: g
Yield description: one medium loaf
```

---

### 4. Notes and Source

Fields:

```text
Nutrition notes
Source created from
Source notes
```

These should appear lower on the page because they are metadata, not primary recipe content.

Layout:

```text
Nutrition notes full width
Source created from and Source notes side by side on desktop
Single column on mobile
```

---

## Form Behavior

Required behavior:

```text
Title should be visually marked as required.
Save button should be visually primary.
Cancel/back button should be visually secondary.
Validation errors should appear above the form.
Validation errors should be readable and styled.
The form should be usable without JavaScript.
```

Nice-to-have later:

```text
autosave draft
ingredient nested fields
steps editor
tag chips
equipment chips
markdown preview for notes
```

---

## Suggested Rails Partial

Use this as:

```text
app/views/recipes/_form.html.erb
```

```erb
<%= form_with(model: recipe, class: "recipe-form") do |form| %>
  <% if recipe.errors.any? %>
    <section class="form-errors">
      <h2><%= pluralize(recipe.errors.count, "error") %> prevented this recipe from being saved</h2>

      <ul>
        <% recipe.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </section>
  <% end %>

  <section class="form-section">
    <header class="form-section__header">
      <h2>Identity</h2>
      <p>Basic information used to identify the recipe.</p>
    </header>

    <div class="form-grid">
      <div class="field field--wide">
        <%= form.label :title, "Title", class: "field__label field__label--required" %>
        <%= form.text_field :title, class: "field__control", placeholder: "Seitan BBQ ribs" %>
      </div>

      <div class="field">
        <%= form.label :version, class: "field__label" %>
        <%= form.text_field :version, class: "field__control", placeholder: "v1, draft, tested" %>
      </div>

      <div class="field">
        <%= form.label :language, class: "field__label" %>
        <%= form.text_field :language, class: "field__control", placeholder: "en, es-MX" %>
      </div>
    </div>
  </section>

  <section class="form-section">
    <header class="form-section__header">
      <h2>Classification</h2>
      <p>Diet, tags, and equipment for filtering and planning.</p>
    </header>

    <div class="form-grid">
      <div class="field">
        <%= form.label :diet, class: "field__label" %>
        <%= form.text_area :diet, class: "field__control field__control--textarea", placeholder: "vegan, high-protein" %>
      </div>

      <div class="field">
        <%= form.label :tags, class: "field__label" %>
        <%= form.text_area :tags, class: "field__control field__control--textarea", placeholder: "weeknight, spicy, seitan" %>
      </div>

      <div class="field field--wide">
        <%= form.label :equipment, class: "field__label" %>
        <%= form.text_area :equipment, class: "field__control field__control--textarea", placeholder: "oven, steamer, blender" %>
      </div>
    </div>
  </section>

  <section class="form-section">
    <header class="form-section__header">
      <h2>Yield and servings</h2>
      <p>How much the recipe produces and how it should be portioned.</p>
    </header>

    <div class="form-grid form-grid--four">
      <div class="field">
        <%= form.label :servings_count, class: "field__label" %>
        <%= form.number_field :servings_count, class: "field__control", min: 0, step: 1 %>
      </div>

      <div class="field">
        <%= form.label :servings_unit, class: "field__label" %>
        <%= form.text_field :servings_unit, class: "field__control", placeholder: "servings" %>
      </div>

      <div class="field">
        <%= form.label :yield_amount, class: "field__label" %>
        <%= form.number_field :yield_amount, class: "field__control", min: 0, step: "any" %>
      </div>

      <div class="field">
        <%= form.label :yield_unit, class: "field__label" %>
        <%= form.text_field :yield_unit, class: "field__control", placeholder: "g, ml, pieces" %>
      </div>

      <div class="field field--wide">
        <%= form.label :yield_description, class: "field__label" %>
        <%= form.text_field :yield_description, class: "field__control", placeholder: "one medium loaf, 12 patties, 1 tray" %>
      </div>
    </div>
  </section>

  <section class="form-section">
    <header class="form-section__header">
      <h2>Notes and source</h2>
      <p>Optional metadata for nutrition, provenance, and adaptation history.</p>
    </header>

    <div class="form-grid">
      <div class="field field--wide">
        <%= form.label :nutrition_notes, class: "field__label" %>
        <%= form.text_area :nutrition_notes, class: "field__control field__control--textarea-large" %>
      </div>

      <div class="field">
        <%= form.label :source_created_from, class: "field__label" %>
        <%= form.text_field :source_created_from, class: "field__control", placeholder: "original, adapted, generated, translated" %>
      </div>

      <div class="field">
        <%= form.label :source_notes, class: "field__label" %>
        <%= form.text_area :source_notes, class: "field__control field__control--textarea" %>
      </div>
    </div>
  </section>

  <footer class="form-actions">
    <%= link_to "Cancel", recipes_path, class: "button button--secondary" %>
    <%= form.submit class: "button button--primary" %>
  </footer>
<% end %>
```

---

## Page Wrapper

For:

```text
app/views/recipes/new.html.erb
```

```erb
<div class="page-shell">
  <header class="page-header">
    <p class="page-kicker">Recipe manager</p>
    <h1>New recipe</h1>
    <p>Create a structured recipe entry with yield, diet, equipment, and source metadata.</p>
  </header>

  <div class="form-card">
    <%= render "form", recipe: @recipe %>
  </div>
</div>
```

For:

```text
app/views/recipes/edit.html.erb
```

```erb
<div class="page-shell">
  <header class="page-header">
    <p class="page-kicker">Recipe manager</p>
    <h1>Edit recipe</h1>
    <p>Update recipe metadata, yield, and source notes.</p>
  </header>

  <div class="form-card">
    <%= render "form", recipe: @recipe %>
  </div>
</div>
```

---

## CSS

Put this in:

```text
app/assets/stylesheets/recipes.css
```

or your main application stylesheet.

```css
:root {
  --color-bg: #f6f2ea;
  --color-surface: #ffffff;
  --color-text: #172126;
  --color-muted: #6b7280;
  --color-border: #ded6c8;
  --color-accent: #163236;
  --color-accent-strong: #0f2529;
  --color-gold: #c69c3f;
  --color-danger-bg: #fff1f2;
  --color-danger-border: #fecdd3;
  --color-danger-text: #9f1239;

  --radius-lg: 18px;
  --radius-md: 10px;
  --shadow-card: 0 18px 45px rgba(20, 30, 35, 0.08);
}

body {
  background: var(--color-bg);
  color: var(--color-text);
}

.page-shell {
  width: min(960px, calc(100% - 32px));
  margin: 0 auto;
  padding: 48px 0 72px;
}

.page-header {
  margin-bottom: 24px;
}

.page-kicker {
  margin: 0 0 8px;
  color: var(--color-gold);
  font-size: 0.78rem;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.page-header h1 {
  margin: 0;
  font-size: clamp(2rem, 4vw, 3.25rem);
  line-height: 1.05;
  letter-spacing: -0.04em;
}

.page-header p {
  max-width: 680px;
  margin: 12px 0 0;
  color: var(--color-muted);
  font-size: 1.05rem;
  line-height: 1.6;
}

.form-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-card);
  overflow: hidden;
}

.recipe-form {
  padding: 28px;
}

.form-section {
  padding: 28px 0;
  border-bottom: 1px solid var(--color-border);
}

.form-section:first-child {
  padding-top: 0;
}

.form-section__header {
  margin-bottom: 18px;
}

.form-section__header h2 {
  margin: 0;
  font-size: 1.15rem;
  letter-spacing: -0.02em;
}

.form-section__header p {
  margin: 6px 0 0;
  color: var(--color-muted);
  font-size: 0.94rem;
  line-height: 1.5;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

.form-grid--four {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.field {
  min-width: 0;
}

.field--wide {
  grid-column: 1 / -1;
}

.field__label {
  display: block;
  margin-bottom: 7px;
  color: var(--color-text);
  font-size: 0.9rem;
  font-weight: 700;
}

.field__label--required::after {
  content: " *";
  color: var(--color-gold);
}

.field__control {
  width: 100%;
  box-sizing: border-box;
  border: 1px solid #d8d1c5;
  border-radius: var(--radius-md);
  background: #fffefa;
  color: var(--color-text);
  padding: 11px 12px;
  font: inherit;
  line-height: 1.4;
  transition: border-color 0.15s ease, box-shadow 0.15s ease, background 0.15s ease;
}

.field__control:focus {
  outline: none;
  border-color: var(--color-gold);
  background: #ffffff;
  box-shadow: 0 0 0 4px rgba(198, 156, 63, 0.18);
}

.field__control--textarea {
  min-height: 88px;
  resize: vertical;
}

.field__control--textarea-large {
  min-height: 130px;
  resize: vertical;
}

.form-errors {
  margin-bottom: 24px;
  padding: 16px 18px;
  border: 1px solid var(--color-danger-border);
  border-radius: var(--radius-md);
  background: var(--color-danger-bg);
  color: var(--color-danger-text);
}

.form-errors h2 {
  margin: 0 0 8px;
  font-size: 1rem;
}

.form-errors ul {
  margin: 0;
  padding-left: 20px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding-top: 24px;
}

.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 42px;
  padding: 0 18px;
  border-radius: 999px;
  border: 1px solid transparent;
  font-weight: 800;
  text-decoration: none;
  cursor: pointer;
}

.button--primary {
  background: var(--color-accent);
  color: white;
}

.button--primary:hover {
  background: var(--color-accent-strong);
}

.button--secondary {
  background: transparent;
  border-color: var(--color-border);
  color: var(--color-text);
}

.button--secondary:hover {
  background: #f8f4ec;
}

@media (max-width: 760px) {
  .page-shell {
    width: min(100% - 24px, 960px);
    padding-top: 32px;
  }

  .recipe-form {
    padding: 20px;
  }

  .form-grid,
  .form-grid--four {
    grid-template-columns: 1fr;
  }

  .form-actions {
    flex-direction: column-reverse;
  }

  .button {
    width: 100%;
  }
}
```

---

## Acceptance Criteria

The redesign is acceptable when:

```text
1. The recipe form is centered and no longer hugs the left edge.
2. Fields are grouped into visible semantic sections.
3. Desktop uses a two/four-column grid where appropriate.
4. Mobile collapses cleanly to one column.
5. Save and Cancel actions are clear and visually distinct.
6. Validation errors are readable and styled.
7. The form uses Rails helpers, not hardcoded raw inputs.
8. The design works without Tailwind or external CSS libraries.
9. The page remains usable before JavaScript is added.
10. The form can later support nested ingredients and instructions without redesigning the whole page.
```

---

## Implementation Priority

Do not over-invest in fancy UI yet.

Priority order:

```text
1. Layout and centering
2. Field grouping
3. Spacing
4. Typography
5. Form controls
6. Error states
7. Responsive behavior
8. Future nested ingredients/steps
```

Get the layout, grouping, spacing, and typography right first. That alone removes most of the scaffold ugliness.
