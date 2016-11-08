LOAD DATA INFILE '/var/lib/mysql-files/fd_group.tsv' INTO TABLE FoodGroup;
LOAD DATA INFILE '/var/lib/mysql-files/food_des.tsv' INTO TABLE Ingredients;
LOAD DATA INFILE '/var/lib/mysql-files/weight.tsv' INTO TABLE GramMappings;
LOAD DATA INFILE '/var/lib/mysql-files/nutr_def.tsv' INTO TABLE Nutrients;
LOAD DATA INFILE '/var/lib/mysql-files/nut_data.tsv' INTO TABLE IngredientNutrients;