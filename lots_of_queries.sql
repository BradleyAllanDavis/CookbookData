/*What are the names and descriptions of all of my created recipes*/
SELECT *
FROM cookbook_recipe
WHERE id in (SELECT recipe_id FROM cookbook_usersubmission WHERE user_id = @USER_ID)
;

/* List of my favorite recipes w/ a specified tag*/
SELECT *
FROM cookbook_recipe
WHERE id in (
	SELECT cookbook_userfavorite.recipe_id 
	FROM cookbook_userfavorite
	INNER JOIN cookbook_recipetag on cookbook_recipetag.recipe_id = cookbook_userfavorite.recipe_id
	WHERE 
		cookbook_userfavorite.user_id = @USER_ID
		AND cookbook_recipetag.tag_id = @TAG_NAME
)
;

/*List of my favorite recipes w/ a given food group
SELECT * 
FROM cookbook_recipe
WHERE id in (
	SELECT cookbook_userfavorite.recipe_id
	FROM cookbook_userfavorite
	INNER JOIN cookbook_recipeingredient on cookbook_recipeingredient.recipe_id = cookbook_userfavorite.recipe_ID
	INNER JOIN cookbook_ingredient on cookbook_ingredient.id = cookbook_recipeingredient.ingredient_id
	WHERE 
		cookbook_userfavorite.user_id = @USER_ID
		AND cookbook_ingredient.food_group_id = @FOODGROUP_ID
)
;

/*Amount of a nutrient in a recipe*/
/*skipping for now, I think this is done?*/

/*Amount of given nutrient in each common measure for a given recipe*/
/*only one grammapping per ingredient, so this seems superfluous?*/

/*Number of different food groups used in a given recipe*/
SELECT count(*)
FROM (
	SELECT DISTINCT cookbook_ingredient.food_group_id
	FROM cookbook_ingredient
	INNER JOIN cookbook_recipeingredient on cookbook_recipeingredient.ingredient_id = cookbook_ingredient.id
	WHERE cookbook_recipeingredient.recipe_id = @RECIPE_ID
)
;

/*Sort ingredients by amount of given nutrient*/
SELECT cookbook_ingredient.*
FROM cookbook_recipeingredient
INNER JOIN cookbook_ingredient on cookbook_ingredient.id = cookbook_recipeingredient.ingredient_id
INNER JOIN cookbook_grammapping on cookbook_grammapping.id = cookbook_recipeingredient.gram_mapping_id
LEFT OUTER JOIN cookbook_ingredientnutrient 
	on cookbook_ingredientnutrient.ingredient_id = cookbook_ingredient.id
	and cookbook_ingredientnutrient.nutrient_id = @NUTRIENT_ID
WHERE cookbook_recipeingredient.recipe_id = @RECIPE_ID
ORDER BY cookbook_recipeingredient.amount * cookbook_grammapping.amount_grams * cookbook_ingredientnutrient.amount
;

/*My most-favorited tags*/
SELECT cookbook_tag.*
FROM cookbook_tag
INNER JOIN (
	SELECT cookbook_tag.tag_name, count(*) as T_COUNT
	FROM cookbook_userfavorite
	INNER JOIN cookbook_recipetag on cookbook_recipetag.recipe_id = cookbook_userfavorite.recipe_id
	INNER JOIN cookbook_tag on cookbook_recipetag.tag_id = cookbook_tag.tag_name
	WHERE cookbook_userfavorite.user_id = @USER_ID
	GROUP BY cookbook_tag.tag_name
) ct on ct.tag_name = cookbook_tag.tag_name
ORDER BY T_COUNT desc
LIMIT 1
;

/*Most common food group in recipes I created*/
SELECT cookbook_foodgroup.*
FROM cookbook_foodgroup
INNER JOIN (
	SELECT cookbook_foodgroup.id, count(*) as G_COUNT
	FROM cookbook_usersubmission
	INNER JOIN cookbook_recipeingredient on cookbook_recipeingredient.recipe_id = cookbook_usersubmission.recipe_id
	INNER JOIN cookbook_ingredient on cookbook_ingredient.id = cookbook_recipeingredient.ingredient_id
	INNER JOIN cookbook_foodgroup on cookbook_foodgroup.id = cookbook_ingredient.food_group_id
	WHERE cookbook_usersubmission.user_id = @USER_ID
	GROUP BY cookbook_foodgroup.id
) cfg on cfg.id = cookbook_goodgroup.id
ORDER BY G_COUNT desc
LIMIT 1
;

/*Most common ingredient in recieps I created or favorited*/
SELECT cookbook_ingredient.*
FROM cookbook_ingredient
INNER JOIN (
	SELECT cookbook_ingredient.id, count(*) as I_COUNT
	FROM (
		SELECT recipe_id FROM cookbook_usersubmission WHERE user_id = @USER_ID
		UNION
		SELECT recipe_id FROM cookbook_userfavorite WHERE user_id = @USER_ID
	) cr
	INNER JOIN cookbook_recipeingredient on cookbook_recipeingredient.recipe_id = cr.recipe_id
	INNER JOIN cookbook_ingredient on cookbook_ingredient.id = cookbook_recipeingredient.ingredient_id
	GROUP BY cookbook_ingredient.id
) ci on ci.id = cookbook_ingredient.id
ORDER BY I_COUNT desc
LIMIT 1
;
