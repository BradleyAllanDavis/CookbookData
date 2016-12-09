# CS564 Database Project

## Background

### Idea

There are many online recipe cookbooks, but few allow users to modify the recipes
and see how that affects the overall nutritional profile of the dish. We intend
to merge the USDA Standard Reference, a dataset of nutritional information released
by the US government, with a user-extensible cookbook accessible by web browser
to create an application for users to modify recipes in real time by substituting
ingredients and view the resulting nutritional outcomes. Users will be able to
search for new recipes by nutritional content, in order to find new dishes that
suit their needs, tastes, and/or nutritional requirements. Default filters will
include common dietary restrictions, such as lactose intolerance, gluten sensitivity,
and vegan and vegetarian diets. Users will also be able to save their modifications
which can be presented to other users as alternatives.

### Datasets

The USDA Standard Reference is a comprehensive breakdown of the nutrition of a
variety of foods available in the United States. In addition to serving size and
calorie counts, the dataset includes a detailed nutrient breakdown for each food,
including vitamins, minerals, and even amino acids. The amino acid information is
of particular interest to vegetarians and vegans, because it can be difficult to
get a all essential amino acids from a diet that does not include meat.

A subset of recipes extracted from the popular online cookbook/blog Epicurious
will provide a good starting point for our user entry driven recipe database.
Epicurious provides an ingredient breakdown and cooking instructions for its
recipes, and has a large variety of recipes to choose from for various dietary
restrictions.

### ER Diagram

![ER Diagram](misc/ERDiagram.png?raw=true "ER Diagram")

### Relational Schema (source of truth for Django)

* cookbook_user (**user_id**, password, first_name, last_name)
* cookbook_foodgroup (**id**, name)
* cookbook_grammapping (**ingredient**, **common_measure**, amount_grams)
* cookbook_ingredientnutrient (**ingredient**, **nutrient**, amount)
* cookbook_ingredient (**ingredient**, food_group, name)
* cookbook_nutrient (**id**, unit, name)
* cookbook_recipeingredient (**recipe**, **ingredient**, amount, unit)
* cookbook_recipe (**id**, title, description, instructions, serves)
* cookbook_savedsearch (**id**, **user_id**, search_name, recipe_search_term, ingredient_search_term)
* cookbook_searchfoodgroup (**search**, **food_group**, include)
* cookbook_searchtag (**search**, **tag**, include)
* cookbook_tag (**tag_name**)
* cookbook_userfavorite (**user**, **recipe**)
* cookbook_usersubmission (**user**, **recipe**)
* cookbook_recipetag (**recipe**, **tag**)

## Tools

* RDBMS - PostgreSQL
* Django/Python - Web back-end
* Bootstrap - Front-end UI framework
* Digital Ocean - Virtual Private Server/Web Hosting
* Git/GitHub - Source code control
