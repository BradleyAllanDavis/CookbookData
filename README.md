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

### Relational Schema

* User (user_id, password, first_name, last_name)
* Saved_search (search_id, user_id, search_name)
* Recipe (recipe_id, title, description, instructions, is_private)
* Tag (tag_id, tag_description)
* Ingredient (ingredient_id, name)
* Food_group (food_group_id, name, description)
* Nutrient (nutrient_id, description, unit)
* Gram_mapping (ingredient_id, amount_common_measure, common_measure, amount_grams)
* Search_tag (search_id, tag_id, include)
* Search_food_group (search_id, tag_id, include)
* User_favorited_recipe (user_id, recipe_id)
* User_created_recipe (user_id, recipe_id)
* Parent_recipe (parent_recipe_id, child_recipe_id)
* Recipe_ingredients (recipe_id, ingredient_id, amount, common_measure)
* Recipe_tags (recipe_id, tag_id)
* Ingredient_nutrient (ingredient_id, nutrient_id, amount)
* Ingredient_food_groups (ingredient_id, food_group_id)

## Tools

* RDBMS - MySQL
* Python - Back-end
* SQLAlchemy - Python to MySQL object relational mapping framework
* Javascript - Front-end
* Bootstrap - Front-end UI framework
* Digital Ocean - Virtual Private Server/Web Hosting
