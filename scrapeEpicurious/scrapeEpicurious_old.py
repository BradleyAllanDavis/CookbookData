import requests

from bs4 import BeautifulSoup

number_of_recipes_to_scrape = 10000
recipes_per_page = 30  # max seems to be 30


def main():

    # ingredients = build_ingredients_dict()
    # print_ingredients_dict(ingredients)


    page_count = int(number_of_recipes_to_scrape / recipes_per_page)

    for page_index in range(page_count):
        page_url = get_page_url(page_index, recipes_per_page)
        page_soup = BeautifulSoup(requests.get(page_url).text, 'lxml')
        page_recipes = get_recipes_in_page(page_soup)

        for recipe_html in page_recipes:
            recipe = parse_recipe(recipe_html)
            print_recipe(recipe)


# Build data structure for USDA ingredients
def build_ingredients_dict():

    ingredients = {}

    with open('ingredients.tsv', 'r') as infile:
        for line in infile:
            line_array = line.split('\t')

            ingredient_id = line_array[0]
            food_group = line_array[1]

            ingredient_and_description = line_array[2]
            ingredient_and_description_array = ingredient_and_description.strip().split(',', 1)

            ingredient = ingredient_and_description_array[0]
            if len(ingredient_and_description_array) > 1:
                description = ingredient_and_description_array[1]
            else:
                description = None

            ingredient_obj = Ingredient(ingredient_id, food_group, ingredient, description)

            if ingredient_obj.ingredient in ingredients.keys():
                list_of_ingredients = ingredients[ingredient_obj.ingredient]
                list_of_ingredients.append(ingredient_obj)
                ingredients[ingredient_obj.ingredient] = list_of_ingredients
            else:
                ingredients[ingredient_obj.ingredient] = [ingredient_obj]

    return ingredients


# Print ingredients in structure
def print_ingredients_dict(ingredients):

    for ingredient in ingredients:
        print(ingredient)
        for ingredient_obj in ingredients[ingredient]:
            if ingredient_obj.description:
                print(ingredient_obj.ingredient_id + ' ' + ingredient_obj.food_group + ' ' + ingredient_obj.description)
            else:
                print(ingredient_obj.ingredient_id + ' ' + ingredient_obj.food_group + ' ' + ingredient)
        print()


# returns a Recipe object parsed from the input html
def parse_recipe(recipe_html):
    recipe_url = get_recipe_url(recipe_html)
    recipe_soup = BeautifulSoup(requests.get(recipe_url).text, "lxml")

    name = recipe_soup.find('div', class_='title-source').find('h1').get_text()

    if recipe_soup.find('div', class_='dek') is not None:
        description = recipe_soup.find('div', class_='dek').get_text('p')
    else:
        description = ""

    ingredients = Ingredients([i.text for i in recipe_soup.find('div', class_='ingredients-info').find_all('li', itemprop="ingredients")])

    preparation = recipe_soup.find('div', class_='instructions', itemprop='recipeInstructions')
    if preparation != None:
        preparation = preparation.find('li').get_text(separator=" ")

    tags = None;
    if recipe_soup.find('div', class_='menus-tags content') is not None:
        if recipe_soup.find('div', class_='menus-tags content').find('dl', class_='tags') is not None:
            tags = Ingredients([i.text for i in recipe_soup.find('div', class_='menus-tags content').find('dl', class_='tags').find_all('a')])
    if tags is None:
        tags = Ingredients([])

    return Recipe(name, description, ingredients, preparation, tags)


def print_recipe(recipe):
    recipe.tsv_out()
    # recipe.pretty_out()


# returns the url for the recipe's own page, where the recipe's details are found.
def get_recipe_url(recipe):
    recipe_name = recipe.find_all('a')[0].get('href')
    recipe_link = 'http://www.epicurious.com' + recipe_name
    return recipe_link


# returns a list of recipes (in html form) found in the page_soup
def get_recipes_in_page(page_soup):
    page_recipes = [(page_soup.find('div', class_='sr_rows clearfix firstResult'))]
    rest_of_recipes = page_soup.find_all('div', attrs={"class": 'sr_rows clearfix '})
    for r in rest_of_recipes:
        page_recipes.append(r)
    return page_recipes


# returns the url for a page of recipes of size page_size at the given page_index
def get_page_url(page_index, page_size):
    return 'http://www.epicurious.com/tools/searchresults?search=&pageNumber=' \
           + str(page_index) + '&pageSize=' + str(page_size) \
           + '&resultOffset=' + str(page_size * (page_index - 1) + 1)


# returns the input string with tabs and non-ascii characters removed
def clean(text):
    text = text.replace('\t', ' ')
    text = text.replace('\r', '\n')

    # Strip whitespace list/array around new lines, replaces with @newline@ token
    line_array = text.split("\n")
    line_array = [" ".join(line.strip().split()) for line in line_array]
    text = "@newline@".join(line_array)

    return ''.join(i for i in text if ord(i) < 128)


class Ingredient:
    def __init__(self, ingredient_id, food_group, ingredient, description):
        self.ingredient_id = ingredient_id
        self.food_group = food_group
        self.ingredient = ingredient
        self.description = description


# represents a recipe. ingredients should be of type Ingredients
class Recipe:
    def __init__(self, name, description, ingredients, preparation, tags):
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.preparation = preparation
        self.tags = tags

    def pretty_out(self):
        print("Name:        " + self.name)
        print("Description: " + self.description)
        print("Ingredients: ")
        for item in self.ingredients.items:
            print("* " + item)
        print("Preparation: " + self.preparation.strip())
        print("Tags:        ")
        for item in self.tags.items:
            print("* " + item)
        print()

    def tsv_out(self):
        print("\t".join([clean(self.name), clean(self.description), str(self.ingredients), clean(self.preparation), str(self.tags)]))


# represents a list of ingredients
class Ingredients:
    def __init__(self, items):
        self.items = []

        for item in items:
            self.items.append(clean(item))

    def __str__(self):
        return "^".join(self.items)


if __name__ == "__main__":
    main()
