class NestedRecipeImporter
  def self.call(data)
    new(data).call
  end

  def initialize(data)
    @data = data.to_h
  end

  def call
    Recipe.transaction do
      recipe = create_recipe
      create_steps(recipe)
      create_ingredients(recipe)
      create_technique_notes(recipe)
      create_substitutions(recipe)
      create_adjustments(recipe)
      create_storage(recipe)
      recipe
    end
  end

  private

  attr_reader :data

  def create_recipe
    Recipe.create!(
      title: data.fetch("title"),
      version: data.fetch("version"),
      language: data["language"],
      diet: array_text(data["diet"]),
      tags: array_text(data["tags"]),
      equipment: array_text(data["equipment"]),
      nutrition_notes: array_text(data["nutrition_notes"]),
      servings_count: dig_value("servings", "count"),
      servings_unit: dig_value("servings", "unit"),
      yield_amount: dig_value("yield", "amount"),
      yield_unit: dig_value("yield", "unit"),
      yield_description: dig_value("yield", "description"),
      source_created_from: dig_value("source_context", "created_from"),
      source_notes: dig_value("source_context", "notes")
    )
  end

  def create_ingredients(recipe)
    inferred_step_counts = Hash.new(0)

    Array(data["ingredients"]).each do |item|
      ingredient = Ingredient.find_or_create_by!(name: item.fetch("name"))
      recipe.recipe_ingredients.create!(
        ingredient: ingredient,
        step: step_for(recipe, item, inferred_step_counts),
        amount: item["amount"]&.to_s,
        unit: item["unit"],
        state: item["state"],
        preparation: item["preparation"],
        section: item["section"],
        optional: item["optional"],
        notes: item["notes"]
      )
    end
  end

  def create_steps(recipe)
    Array(data["steps"]).each do |item|
      recipe.steps.create!(
        order: item.fetch("order"),
        title: item["title"],
        action: item.fetch("action"),
        time_amount: item.dig("time", "amount")&.to_s,
        time_unit: item.dig("time", "unit"),
        time_per_side: item.dig("time", "per_side"),
        time_description: item.dig("time", "description"),
        temperature_amount: item.dig("temperature", "amount"),
        temperature_unit: item.dig("temperature", "unit"),
        temperature_description: item.dig("temperature", "description"),
        heat_level: item["heat_level"],
        targets: array_text(item["targets"]),
        risk_points: array_text(item["risk_points"]),
        notes: array_text(item["notes"]),
        optional_data: item["optional"]&.to_json
      )
    end
  end

  def create_technique_notes(recipe)
    Array(data["technique_notes"]).each do |item|
      recipe.technique_notes.create!(topic: item.fetch("topic"), note: item.fetch("note"))
    end
  end

  def create_substitutions(recipe)
    Array(data["substitutions"]).each do |item|
      substitution = recipe.substitutions.create!(ingredient: item.fetch("ingredient"))

      Array(item["substitutes"]).each do |substitute|
        substitution.substitutes.create!(
          name: substitute.fetch("name"),
          ratio: substitute["ratio"],
          effect: substitute["effect"]
        )
      end
    end
  end

  def create_adjustments(recipe)
    Array(data["adjustments"]).each do |item|
      recipe.adjustments.create!(condition: item.fetch("condition"), fix: item.fetch("fix"))
    end
  end

  def create_storage(recipe)
    storage = data["storage"]
    return unless storage

    recipe.create_storage!(
      refrigerator_duration: storage.dig("refrigerator", "duration"),
      refrigerator_unit: storage.dig("refrigerator", "unit"),
      freezer_duration: storage.dig("freezer", "duration"),
      freezer_unit: storage.dig("freezer", "unit"),
      reheat: storage["reheat"]
    )
  end

  def array_text(value)
    Array(value).compact_blank.join("; ")
  end

  def step_for(recipe, item, inferred_step_counts)
    if item["step_order"].present?
      return recipe.steps.find_by(order: item["step_order"])
    end

    inferred_step_for(recipe, item, inferred_step_counts)
  end

  def inferred_step_for(recipe, item, inferred_step_counts)
    ingredient_key = normalized_text(item["name"])
    return if ingredient_key.blank?

    matching_steps = recipe.steps.select do |step|
      step_mentions_ingredient?(step, ingredient_key)
    end
    return if matching_steps.blank?

    occurrence_index = inferred_step_counts[ingredient_key]
    inferred_step_counts[ingredient_key] += 1
    matching_steps[[ occurrence_index, matching_steps.size - 1 ].min]
  end

  def step_mentions_ingredient?(step, ingredient_key)
    step_text = normalized_text([
      step.title,
      step.action,
      step.targets,
      step.risk_points,
      step.notes
    ].compact.join(" "))

    return true if step_text.include?(ingredient_key)

    ingredient_tokens(ingredient_key).any? { |token| step_text.match?(/\b#{Regexp.escape(token)}\b/) }
  end

  def ingredient_tokens(ingredient_key)
    ingredient_key.split - %w[
      fresh dried dry crushed chopped minced sliced diced ground prepared cooked raw
      small medium large whole
    ]
  end

  def normalized_text(value)
    value.to_s.downcase.gsub(/[^a-z0-9]+/, " ").squeeze(" ").strip
  end

  def dig_value(*keys)
    data.dig(*keys)
  end
end
