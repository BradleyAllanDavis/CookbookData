CREATE VIEW CommonMeasureNutrients AS
SELECT gm.IngredientID, CommonMeasure, Amount/100*AmountGrams*AmountCommonMeasure AS "Nutrient per each", n.NutrientID
FROM Nutrients n, IngredientNutrients inn, GramMappings gm
WHERE inn.IngredientID = gm.IngredientID
AND n.NutrientID=inn.NutrientID;

CREATE VIEW RecipeListing as SELECT r.RecipeID, i.IngredientID, Title, Name, Amount, Unit
FROM Recipes r, Ingredients i, RecipeIngredients ri
WHERE i.IngredientID = ri.IngredientID
AND r.RecipeID = ri.RecipeID;


CREATE VIEW IngredientsInGrams AS
SELECT r.RecipeID, r.IngredientID, Name, Amount, Unit, AmountGrams/AmountCommonMeasure*Amount AS inGrams
FROM RecipeListing r, GramMappings g
WHERE r.IngredientID = g.IngredientID
AND r.Unit = g.CommonMeasure
UNION
SELECT r.RecipeID, r.IngredientID, Name, Amount, Unit, Amount
FROM RecipeListing r
WHERE r.Unit = "g";


CREATE VIEW RecipeListingWithNutrient AS
SELECT RecipeID, ig.IngredientID, Name, ig.Amount, Unit, n.Amount/100*inGrams as NutrientAmount, n.NutrientID
FROM IngredientsInGrams ig, IngredientNutrients n
WHERE ig.IngredientID = n.IngredientID;


SELECT RecipeID, sum(NutrientAmount) FROM RecipeListingWithNutrient WHERE NutrientID = SpecifiedNutrientID AND RecipeID = SpecifiedRecipeID GROUP BY RecipeID;


SELECT Title, i.Name, ri.Amount, ri.Unit, AmountGrams
FROM Recipes r, Ingredients i, RecipeIngredients ri, Nutrients n, IngredientNutrients inn, GramMappings gm
WHERE i.IngredientID = ri.IngredientID
AND r.RecipeID = ri.RecipeID
AND i.IngredientID = inn.IngredientID
AND inn.NutrientID = n.NutrientID
AND n.Name = "Energy"
AND i.IngredientID = gm.IngredientID
AND (gm.CommonMeasure=ri.Unit OR ri.Unit="g");

