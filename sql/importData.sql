/* USDA Data */
COPY cookbook_foodgroup (id, name) FROM '../usda/fd_group.tsv' DELIMITER '\t'
COPY cookbook_ingredient (ingredient_id, food_group_id, name) FROM '../usda/ingredients.tsv' DELIMITER '\t'
COPY cookbook_ingredientnutrient (id, amount, nutrient_id, ingredient_id) FROM '../usda/nut_data.tsv' DELIMITER '\t'
COPY cookbook_grammapping FROM '../usda/weight_cleaned.tsv' DELIMITER '\t'
COPY cookbook_nutrient FROM '../usda/nutr_def.tsv' DELIMITER '\t'



/* LOAD DATA INFILE '/var/lib/mysql-files/fd_group.tsv' INTO TABLE FoodGroup; */
/* LOAD DATA INFILE '/var/lib/mysql-files/food_des.tsv' INTO TABLE Ingredients; */
/* LOAD DATA INFILE '/var/lib/mysql-files/weight.tsv' INTO TABLE GramMappings; */
/* LOAD DATA INFILE '/var/lib/mysql-files/nutr_def.tsv' INTO TABLE Nutrients; */
/* LOAD DATA INFILE '/var/lib/mysql-files/nut_data.tsv' INTO TABLE IngredientNutrients; */
