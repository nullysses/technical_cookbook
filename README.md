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

## JSON Import Schema

The import endpoint accepts one complete recipe object as JSON.

```yaml
openapi: 3.1.0
info:
  title: Cookbook Recipe Import API
  version: 1.0.0
paths:
  /recipe_imports:
    post:
      summary: Create a recipe from a nested JSON object
      operationId: createRecipeImport
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/RecipeImport"
      responses:
        "201":
          description: Recipe created
          content:
            application/json:
              schema:
                type: object
                required:
                  - id
                  - stable_id
                  - title
                  - url
                properties:
                  id:
                    type: integer
                  stable_id:
                    type: string
                    example: gluten-teriyaki-with-rice
                  title:
                    type: string
                    example: Gluten Teriyaki with Rice
                  url:
                    type: string
                    example: http://127.0.0.1:3000/recipes/gluten-teriyaki-with-rice
        "400":
          description: Invalid JSON request body
        "422":
          description: Valid JSON with invalid recipe data
components:
  schemas:
    RecipeImport:
      type: object
      required:
        - title
        - version
      properties:
        title:
          type: string
          example: Gluten Teriyaki with Rice
        version:
          type: string
          example: "1.0"
        language:
          type: string
          nullable: true
          example: en
        diet:
          type: array
          items:
            type: string
          example: [vegan]
        servings:
          $ref: "#/components/schemas/Servings"
        yield:
          $ref: "#/components/schemas/Yield"
        tags:
          type: array
          items:
            type: string
        source_context:
          $ref: "#/components/schemas/SourceContext"
        equipment:
          type: array
          items:
            type: string
        ingredients:
          type: array
          items:
            $ref: "#/components/schemas/RecipeIngredientImport"
        steps:
          type: array
          items:
            $ref: "#/components/schemas/StepImport"
        technique_notes:
          type: array
          items:
            $ref: "#/components/schemas/TechniqueNoteImport"
        substitutions:
          type: array
          items:
            $ref: "#/components/schemas/SubstitutionImport"
        adjustments:
          type: array
          items:
            $ref: "#/components/schemas/AdjustmentImport"
        storage:
          $ref: "#/components/schemas/StorageImport"
        nutrition_notes:
          type: array
          items:
            type: string
    Servings:
      type: object
      properties:
        count:
          type: number
          nullable: true
        unit:
          type: string
          nullable: true
          example: people
    Yield:
      type: object
      properties:
        amount:
          type: number
          nullable: true
        unit:
          type: string
          nullable: true
        description:
          type: string
          nullable: true
    SourceContext:
      type: object
      properties:
        created_from:
          type: string
          nullable: true
          example: chat
        notes:
          type: string
          nullable: true
    RecipeIngredientImport:
      type: object
      required:
        - name
      properties:
        name:
          type: string
          example: soy sauce
        amount:
          oneOf:
            - type: number
            - type: string
            - type: "null"
          example: 3
        unit:
          type: string
          nullable: true
          example: tbsp
        state:
          type: string
          nullable: true
          example: dry
        preparation:
          type: string
          nullable: true
          example: minced
        section:
          type: string
          nullable: true
          example: teriyaki sauce
        optional:
          type: boolean
          nullable: true
        notes:
          type: string
          nullable: true
        step_order:
          type: integer
          nullable: true
          description: Maps this ingredient usage to a step with the same order value. If omitted, the importer tries to infer the step from ingredient and step text.
    StepImport:
      type: object
      required:
        - order
        - action
      properties:
        order:
          type: integer
          example: 1
        title:
          type: string
          nullable: true
        action:
          type: string
        time:
          $ref: "#/components/schemas/TimeBlock"
        temperature:
          $ref: "#/components/schemas/TemperatureBlock"
        heat_level:
          type: string
          nullable: true
          example: medium-high
        targets:
          type: array
          items:
            type: string
        risk_points:
          type: array
          items:
            type: string
        notes:
          type: array
          items:
            type: string
        optional:
          type: object
          nullable: true
          additionalProperties: true
    TimeBlock:
      type: object
      properties:
        amount:
          oneOf:
            - type: number
            - type: string
            - type: "null"
        unit:
          type: string
          nullable: true
          example: min
        per_side:
          type: boolean
          nullable: true
        description:
          type: string
          nullable: true
    TemperatureBlock:
      type: object
      properties:
        amount:
          type: number
          nullable: true
        unit:
          type: string
          nullable: true
          example: C
        description:
          type: string
          nullable: true
    TechniqueNoteImport:
      type: object
      required:
        - topic
        - note
      properties:
        topic:
          type: string
        note:
          type: string
    SubstitutionImport:
      type: object
      required:
        - ingredient
      properties:
        ingredient:
          type: string
        substitutes:
          type: array
          items:
            $ref: "#/components/schemas/SubstituteImport"
    SubstituteImport:
      type: object
      required:
        - name
      properties:
        name:
          type: string
        ratio:
          type: string
          nullable: true
        effect:
          type: string
          nullable: true
    AdjustmentImport:
      type: object
      required:
        - condition
        - fix
      properties:
        condition:
          type: string
        fix:
          type: string
    StorageImport:
      type: object
      properties:
        refrigerator:
          $ref: "#/components/schemas/StorageDuration"
        freezer:
          $ref: "#/components/schemas/StorageDuration"
        reheat:
          type: string
          nullable: true
    StorageDuration:
      type: object
      properties:
        duration:
          type: number
          nullable: true
        unit:
          type: string
          nullable: true
          example: days
```

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
