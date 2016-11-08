INSERT INTO Recipes values(1,"Hannah's test recipe", "User added recipe", "Take bread, and put the butter on it", 0, NULL);
INSERT INTO RecipeIngredients values(1,18060,1,"oz");
INSERT INTO RecipeIngredients value(1,01145,12.231,"g");

CREATE VIEW RecipeListing as SELECT r.RecipeID, i.IngredientID, Title, Name, Amount, Unit 
FROM Recipes r, Ingredients i, RecipeIngredients ri 
WHERE i.IngredientID = ri.IngredientID 
AND r.RecipeID = ri.RecipeID
AND r.RecipeID = 1;

CREATE VIEW CommonMeasureCalories AS 
SELECT gm.IngredientID, CommonMeasure, Amount/100*AmountGrams*AmountCommonMeasure AS "kcal per CommonMeasure" 
FROM Nutrients n, IngredientNutrients inn, GramMappings gm 
WHERE inn.IngredientID = gm.IngredientID 
AND n.NutrientID=inn.NutrientID 
AND n.name="Energy" 
AND n.Unit="kcal";

CREATE VIEW IngredientsInGrams AS
 SELECT r.RecipeID, r.IngredientID, Name, Amount, Unit, AmountGrams/AmountCommonMeasure*Amount AS inGrams 
 FROM RecipeListing r, GramMappings g 
 WHERE r.IngredientID = g.IngredientID 
 AND r.Unit = g.CommonMeasure 
 UNION 
 SELECT r.RecipeID, r.IngredientID, Name, Amount, Unit, Amount 
 FROM RecipeListing r 
 WHERE r.Unit = "g";

CREATE VIEW RecipeListingWithCalories AS
 SELECT RecipeID, ig.IngredientID, Name, ig.Amount, Unit, n.Amount/100*inGrams as "kcal" 
 FROM IngredientsInGrams ig, IngredientNutrients n 
 WHERE ig.IngredientID=n.IngredientID 
 AND n.NutrientID=208;

SELECT Title, i.Name, ri.Amount, ri.Unit, AmountGrams
FROM Recipes r, Ingredients i, RecipeIngredients ri, Nutrients n, IngredientNutrients inn, GramMappings gm
WHERE i.IngredientID = ri.IngredientID
AND r.RecipeID = ri.RecipeID 
AND i.IngredientID = inn.IngredientID 
AND inn.NutrientID = n.NutrientID
AND n.Name = "Energy"
AND i.IngredientID = gm.IngredientID 
AND (gm.CommonMeasure=ri.Unit OR ri.Unit="g");

