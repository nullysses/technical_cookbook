Recipe.find_by(stable_id: "weeknight-tomato-pasta")&.destroy!
Recipe.find_by(stable_id: "same-ingredient-different-steps")&.destroy!
Recipe.find_by(stable_id: "soy-curl-encacahuatado")&.destroy!
Recipe.find_by(stable_id: "gluten-teriyaki-with-rice")&.destroy!

[
  Rails.root.join("..", "encacahuatado.json"),
  Rails.root.join("..", "gluten_teriyaki.json")
].each do |path|
  NestedRecipeImporter.call(JSON.parse(File.read(path)))
end

NestedRecipeImporter.call(
  {
    "title" => "Same Ingredient Different Steps",
    "version" => "1.0",
    "language" => "en",
    "source_context" => {
      "created_from" => "Seed data",
      "notes" => "Tests inferred step mapping for repeated ingredient usages."
    },
    "ingredients" => [
      {
        "name" => "salt",
        "amount" => "1",
        "unit" => "tsp",
        "section" => "base"
      },
      {
        "name" => "salt",
        "amount" => "1/2",
        "unit" => "tsp",
        "section" => "vegetables"
      },
      {
        "name" => "salt",
        "amount" => "to taste",
        "section" => "finish"
      },
      {
        "name" => "onion",
        "amount" => "1",
        "unit" => "medium",
        "preparation" => "diced",
        "section" => "base"
      }
    ],
    "steps" => [
      {
        "order" => 1,
        "title" => "Season the base",
        "action" => "Cook the onion with salt until translucent."
      },
      {
        "order" => 2,
        "title" => "Season the vegetables",
        "action" => "Add the vegetables and another measure of salt."
      },
      {
        "order" => 3,
        "title" => "Finish seasoning",
        "action" => "Taste and add more salt if needed."
      }
    ],
    "technique_notes" => [
      {
        "topic" => "Repeated ingredients",
        "note" => "The three salt entries intentionally omit step_order so the importer maps each usage to the matching step in order."
      }
    ]
  }
)
