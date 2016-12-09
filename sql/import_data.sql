/* USDA Data */
COPY cookbook_foodgroup (foodgroup_id, name) FROM '../usda/fd_group.tsv' DELIMITER '\t';
COPY cookbook_nutrient (nutrient_id, unit, name) FROM '../usda/nutr_def.tsv' DELIMITER '\t';
COPY cookbook_grammapping (ingredient_id, common_measure, amount) FROM '../usda/weight_cleaned.tsv' DELIMITER '\t';
COPY cookbook_ingredientnutrient (ingredient_id, nutrient_id, amount) FROM '../usda/nut_data.tsv' DELIMITER '\t';
COPY cookbook_ingredient (ingredient_id, foodgroup_id, name) FROM '../usda/ingredients.tsv' DELIMITER '\t';

/* epicurious */
COPY cookbook_tag (tag_name) FROM '../epicurious/tags.tsv' DELIMITER '\t';
COPY cookbook_recipe (recipe_id, title, description, instructions, serves) FROM '../epicurious/recipes_clean.tsv' DELIMITER '\t';
COPY cookbook_recipetag (recipe_id, tag_name) FROM '../epicurious/recipe_tags.tsv' DELIMITER '\t';
COPY cookbook_recipeingredient (recipe_id, ingredient_id, common_measure, amount) FROM '../epicurious/recipe_ingredients.tsv' DELIMITER '\t';
