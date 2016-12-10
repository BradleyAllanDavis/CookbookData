\copy cookbook_foodgroup (id, name) FROM '../usda/fd_group.tsv' DELIMITER E'\t';
\copy cookbook_grammapping (id, ingredient_id, common_measure, amount_grams) FROM '../usda/weight_cleaned_w_id.tsv' DELIMITER E'\t';
\copy cookbook_ingredientnutrient (id, ingredient_id, nutrient_id, amount) FROM '../usda/nut_data_w_id.tsv' DELIMITER E'\t';
\copy cookbook_ingredient (id, foodgroup_id, name) FROM '../usda/ingredients.tsv' DELIMITER E'\t';
\copy cookbook_nutrient (id, unit, name) FROM '../usda/nutr_def.tsv' DELIMITER E'\t';
\copy cookbook_recipeingredient (id recipe_id, ingredient_id, unit, amount) FROM '../epicurious/recipe_ingredients_w_id.tsv' DELIMITER E'\t';
\copy cookbook_recipe (id, title, description, instructions, serves) FROM '../epicurious/recipes_clean.tsv' DELIMITER E'\t';
\copy cookbook_tag (tag_name) FROM '../epicurious/tags.tsv' DELIMITER E'\t';
\copy cookbook_recipetag (id recipe_id, tag_id) FROM '../epicurious/recipe_tags_w_id.tsv' DELIMITER E'\t';
