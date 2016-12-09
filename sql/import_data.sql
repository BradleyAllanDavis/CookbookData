COPY cookbook_foodgroup (id, name) FROM '../usda/fd_group.tsv' DELIMITER E'\t';
COPY cookbook_grammapping (ingredient, common_measure, amount_grams) FROM '../usda/weight_cleaned.tsv' DELIMITER E'\t';
COPY cookbook_ingredientnutrient (ingredient, nutrient, amount) FROM '../usda/nut_data.tsv' DELIMITER E'\t';
COPY cookbook_ingredient (id, food_group, name) FROM '../usda/ingredients.tsv' DELIMITER E'\t';
COPY cookbook_nutrient (id, unit, name) FROM '../usda/nutr_def.tsv' DELIMITER E'\t';
COPY cookbook_recipeingredient (recipe, ingredient, unit, amount) FROM '../epicurious/recipe_ingredients.tsv' DELIMITER E'\t';
COPY cookbook_recipe (id, title, description, instructions, serves) FROM '../epicurious/recipes_clean.tsv' DELIMITER E'\t';
COPY cookbook_tag (tag_name) FROM '../epicurious/tags.tsv' DELIMITER E'\t';
COPY cookbook_recipetag (recipe, tag) FROM '../epicurious/recipe_tags.tsv' DELIMITER E'\t';
