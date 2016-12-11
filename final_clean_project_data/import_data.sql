\copy cookbook_recipe (id, title, description, instructions, serves) FROM 'recipe.tsv' DELIMITER E'\t';
\copy cookbook_foodgroup (id, name) FROM 'foodgroup.tsv' DELIMITER E'\t';
\copy cookbook_tag (tag_name) FROM 'tag.tsv' DELIMITER E'\t';
\copy cookbook_ingredient (id, food_group_id, name) FROM 'ingredient.tsv' DELIMITER E'\t';
\copy cookbook_nutrient (id, unit, name) FROM 'nutrient.tsv' DELIMITER E'\t';
\copy cookbook_ingredientnutrient (id, ingredient_id, nutrient_id, amount) FROM 'ingredientnutrient.tsv' DELIMITER E'\t';
\copy cookbook_recipetag (id, recipe_id, tag_id) FROM 'recipetag.tsv' DELIMITER E'\t';
\copy cookbook_grammapping (id, ingredient_id, common_measure, amount_grams) FROM 'grammapping.tsv' DELIMITER E'\t';
\copy cookbook_recipeingredient (id, recipe_id, ingredient_id, gram_mapping_id, amount) FROM 'recipeingredient.tsv' DELIMITER E'\t';
