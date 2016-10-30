CREATE TABLE User (
	UserId int PRIMARY KEY
	,Password varchar(32) NOT NULL
		CHECK ( Password REGEXP '^[[:alnum:]]{6,}$' ) -- alphanumeric only, weak input sanitization
	,FirstName varchar(32)
		CHECK ( FirstName REGEXP '^[[:alpha:][.apostrophe.][.hyphen.]]+$' ) -- alpha, apostophe, hyphen allowed
	,LastName varchar(32)
		CHECK ( LastName REGEXP '^[[:alpha:][.apostrophe.][.hyphen.]]+$' ) -- alpha, apostophe, hyphen allowed
);

CREATE TABLE SavedSearches (
	SearchID int
	,UserId int REFERENCES User(UserId) -- UserId must exist in User
	,SearchName varchar(64) NOT NULL
		CHECK ( SearchName REGEXP '^[[:alnum:][.space.]]+$' ) -- alphanumeric and spaces, need a better way to sanitize here
	,PRIMARY KEY ( SearchID, UserId )
);

CREATE TABLE Recipes (
	RecipeID int PRIMARY KEY
	,Title varchar(64) NOT NULL
		-- Sanitize
	,Description varchar(2048)
		-- Sanitize
	,Instructions varchar(2048)
		-- Sanitize
	,IsPrivate TINYINT
);

/*
change to TagName as PK? 
Don't want to have multiple tags w/ same name
hannah: yes, I agree that the tag name should be unique. I replaced TagID with 
TagName and got rid of the name attribute.
*/
CREATE TABLE Tags (
	TagName varchar(64) PRIMARY KEY
	,Description varchar(1024)
);

CREATE TABLE Ingredients (
	IngredientID int PRIMARY KEY
	,Name varchar(64) NOT NULL
		-- Does this need sanitization? Can't be user-added
);

/*
Change to FOOD_GROUP_NAME as PK?
*/
CREATE TABLE FoodGroup (
	FoodGroupID int PRIMARY KEY
	,Name varchar(64) NOT NULL
		-- Does this need sanitization? Can't be user-added
	,Description varchar(256)
		-- Does this need sanitization? Can't be user-added
);

CREATE TABLE Nutrients (
	NutrientID int PRIMARY KEY
	,Name varchar(128) NOT NULL -- hannah: renamed from Description to Name
		-- Does this need sanitization? Can't be user-added
	,Unit varchar(64)
		-- Does this need sanitization? Can't be user-added
);

CREATE TABLE GramMappings (
	IngredientID int REFERENCES Ingredients(IngredientID) -- IngredientID must exist in Ingredients
	,AmountCommonMeasure real NOT NULL CHECK ( AmountCommonMeasure > 0 ) 
	,CommonMeasure varchar(128) NOT NULL
		-- Does this need sanitization? Can't be user-added
	,AmountGrams real NOT NULL CHECK ( AmountGrams > 0 ) 
	,PRIMARY KEY ( IngredientID, AmountCommonMeasure, CommonMeasure )
);

CREATE TABLE SearchTags (
	SearchID int REFERENCES SavedSearches(SearchID)
	,TagName int REFERENCES Tag(TagName)
	,Include TINYINT NOT NULL
	,PRIMARY KEY ( SearchID, TagName )
);

CREATE TABLE SearchFoodGroup (
	SearchID int REFERENCES SavedSearches(SearchID)
	,FoodGroupID int REFERENCES FoodGroup(FoodGroupID)
	,Include TINYINT NOT NULL
	,PRIMARY KEY (SearchID, FoodGroupID)
);

CREATE TABLE UserFavorites (
	UserId int REFERENCES User(UserId)
	,RecipeID int REFERENCES Recipes(RecipeID)
	,PRIMARY KEY ( UserId, RecipeID )
);

CREATE TABLE UserSubmittedRecipes (
	UserId int REFERENCES User(UserId)
	,RecipeID int REFERENCES Recipe(RecipeID)
	,PRIMARY KEY ( UserId, RecipeID )
);

CREATE TABLE ParentRecipe (
	ParentRecipeID int REFERENCES Recipe(RecipeID)
	,ChildRecipeID int REFERENCES Recipe(RecipeID)
	,PRIMARY KEY (ParentRecipeID, ChildRecipeID)
);

CREATE TABLE RecipeIngredients (
	RecipeID int REFERENCES Recipe(RecipeID)
	,IngredientID int REFERENCES Ingredients(IngredientID)
	,Amount real NOT NULL CHECK ( Amount > 0 ) 
	,CommonMeasure varchar(128) NOT NULL
	,CHECK ( 
		(IngredientID, CommonMeasure) in (
			SELECT DISTINCT IngredientID, CommonMeasure 
			FROM GramMappings
		)
	) -- need to make sure we don't disallow recipe ingredients listed in grams
	,PRIMARY KEY ( RecipeID, IngredientID )
);

CREATE TABLE RecipeTags (
	RecipeID int REFERENCES Recipe(RecipeID)
	,TagName int REFERENCES Tag(TagName)
	,PRIMARY KEY ( RecipeID, TagName )
);

CREATE TABLE IngredientNutrients (
	IngredientID int REFERENCES Ingredients(IngredientID)
	,NutrientID int REFERENCES Nutrients(NutrientID)
	,Amount real NOT NULL CHECK (Amount > 0)  -- are there foods w/ negative calories (Celery?) *Hannah: no, also I think celery is a myth (sounds too good to be true!). added >0 check.
	,PRIMARY KEY ( IngredientID, NutrientID )
);

CREATE TABLE IngredientFoodGroups (
	IngredientID int REFERENCES Ingredients(IngredientID)
	,FoodGroupID int REFERENCES FoodGroup(FoodGroupID)
	,PRIMARY KEY ( IngredientID, FoodGroupID )
);
