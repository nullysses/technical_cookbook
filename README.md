# Cookbook

A Ruby on Rails recipe manager built from `recipe_schema.json`. The app supports recipe CRUD, nested recipe JSON imports, ingredient usage tracking, and per-session cooking progress.

## Features

- Recipe list on the home page.
- Recipe URLs based on stable slugs inferred from recipe titles.
- CRUD screens for recipes, standalone ingredients, and related recipe concepts.
- Nested JSON recipe import endpoint for creating a full recipe from one object.
- Recipe ingredient usages are separate from standalone ingredients, so the same ingredient can appear multiple times in one recipe.
- Ingredient usages can be mapped to preparation steps with explicit `step_order` or importer inference.
- Per-session progress:
  - mark ingredients as procured;
  - mark steps as done;
  - Turbo updates progress controls without a full page reload;
  - in-progress recipes show a badge on the recipe list.
- Seed recipes include examples for repeated ingredients and mapped ingredient usages.

## Project Layout

```text
.
├── recipe_manager/          # Rails application
├── recipe_schema.json       # Source schema used to shape the app
├── encacahuatado.json       # Importable recipe fixture
└── gluten_teriyaki.json     # Importable recipe fixture
```

## Requirements

- Ruby compatible with the Rails version in `recipe_manager/Gemfile`
- Bundler
- SQLite

## Setup

```bash
cd recipe_manager
bundle install
ruby bin/rails db:prepare
ruby bin/rails db:seed
ruby bin/rails server
```

Then open:

```text
http://127.0.0.1:3000
```

## JSON Import

Create a recipe from one nested JSON object:

```bash
curl -X POST http://127.0.0.1:3000/recipe_imports \
  -H "Content-Type: application/json" \
  --data @../gluten_teriyaki.json
```

The importer supports nested data for:

- recipe metadata
- ingredients
- steps
- technique notes
- substitutions and substitutes
- adjustments
- storage

Ingredient usages may include `step_order` to map them to a step. If `step_order` is omitted, the importer attempts to infer the step by matching ingredient names against step text.

## Tests

```bash
cd recipe_manager
ruby bin/rails test
```

## Seed Data

`ruby bin/rails db:seed` recreates the current sample recipe state from:

- `encacahuatado.json`
- `gluten_teriyaki.json`
- an inline repeated-ingredient recipe that validates inferred step mapping
