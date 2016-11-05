CREATE TABLE User (
	UserID INT PRIMARY KEY,
	Password VARCHAR(32) NOT NULL
		CHECK (Password REGEXP '^[[:alnum:]]{6,}$'), -- alphanumeric only, weak input sanitization,
	FirstName VARCHAR(32)
		CHECK (FirstName REGEXP '^[[:alpha:][.apostrophe.][.hyphen.]]+$'), -- alpha, apostophe, hyphen allowed,
	LastName VARCHAR(32)
		CHECK (LastName REGEXP '^[[:alpha:][.apostrophe.][.hyphen.]]+$'), -- alpha, apostophe, hyphen allowed
);

CREATE TABLE SavedSearches (
	SearchID INT,
	FOREIGN KEY (UserID) REFERENCES User(UserID), -- UserID must exist in User
	SearchName VARCHAR(64) NOT NULL
		CHECK (SearchName REGEXP '^[[:alnum:][.space.]]+$'), -- alphanumeric and spaces, need a better way to sanitize here
	PRIMARY KEY (SearchID, UserID)
);

CREATE TABLE Recipes (
	RecipeID INT PRIMARY KEY,
	Title VARCHAR(64) NOT NULL,
	Description VARCHAR(2048),
	Instructions VARCHAR(2048),
	IsPrivate TINYINT
);

CREATE TABLE Tags (
	TagName VARCHAR(64) PRIMARY KEY,
	Description VARCHAR(1024)
);

CREATE TABLE Ingredients (
	IngredientID INT PRIMARY KEY,
	FOREIGN KEY FoodGroupID REFERENCES FoodGroup(FoodGroupID),
	Name VARCHAR(64) NOT NULL
);

CREATE TABLE FoodGroup (
	FoodGroupID INT PRIMARY KEY,
	Name VARCHAR(64) NOT NULL,
);

CREATE TABLE Nutrients (
	NutrientID INT PRIMARY KEY,
	Name VARCHAR(128) NOT NULL,
	Unit VARCHAR(64)
);

CREATE TABLE GramMappings (
	AmountCommonMeasure DOUBLE NOT NULL CHECK (AmountCommonMeasure > 0),
	SequenceNumber int NOT NULL,
	CommonMeasure VARCHAR(128) NOT NULL,
	AmountGrams DOUBLE NOT NULL CHECK (AmountGrams > 0),
	PRIMARY KEY (IngredientID, AmountCommonMeasure, CommonMeasure)
);

CREATE TABLE SearchTags (
	FOREIGN KEY (SearchID) REFERENCES SavedSearches(SearchID),
	FOREIGN KEY (TagName) REFERENCES Tag(TagName),
	Include TINYINT NOT NULL,
	PRIMARY KEY (SearchID, TagName)
);

CREATE TABLE SearchFoodGroup (
	FOREIGN KEY (SearchID) REFERENCES SavedSearches(SearchID),
	FOREIGN KEY FoodGroupID REFERENCES FoodGroup(FoodGroupID),
	Include TINYINT NOT NULL,
	PRIMARY KEY (SearchID, FoodGroupID)
);

CREATE TABLE UserFavorites (
	FOREIGN KEY (UserID) REFERENCES User(UserID),
	FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID),
	PRIMARY KEY (UserID, RecipeID)
);

CREATE TABLE UserSubmittedRecipes (
	FOREIGN KEY (UserID) REFERENCES User(UserID),
	FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID),
	PRIMARY KEY (UserID, RecipeID)
);

CREATE TABLE ParentRecipe (
	FOREIGN KEY (ParentRecipeID) REFERENCES Recipe(RecipeID),
	FOREIGN KEY (ChildRecipeID) REFERENCES Recipe(RecipeID),
	PRIMARY KEY (ParentRecipeID, ChildRecipeID)
);

CREATE TABLE RecipeIngredients (
	FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID),
	FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID),
	Amount DOUBLE NOT NULL CHECK (Amount > 0),
	CommonMeasure VARCHAR(128) NOT NULL,
	CHECK (
		(IngredientID, CommonMeasure) in (
			SELECT DISTINCT IngredientID, CommonMeasure
			FROM GramMappings
		)
	), -- need to make sure we don't disallow recipe ingredients listed in grams,
	PRIMARY KEY (RecipeID, IngredientID)
);

CREATE TABLE RecipeTags (
	FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID),
	FOREIGN KEY (TagName) REFERENCES Tag(TagName),
	PRIMARY KEY (RecipeID, TagName)
);

CREATE TABLE IngredientNutrients (
	FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID),
	FOREIGN KEY (NutrientID) REFERENCES Nutrients(NutrientID),
	Amount DOUBLE NOT NULL CHECK (Amount >= 0),
	PRIMARY KEY (IngredientID, NutrientID)
);
