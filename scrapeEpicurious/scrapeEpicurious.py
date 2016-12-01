from fuzzywuzzy import fuzz
from fuzzywuzzy import process
from usdaingredientlist import UsdaIngredientList
from grammappinglist import GramMappingList
from recipe import Recipe
from ingredientlist import Ingredients
import random
import re

import requests

from bs4 import BeautifulSoup

number_of_recipes_to_scrape = 10000
recipes_per_page = 30  # max seems to be 30

# create output file from web scrape of epicurious by matching ingredients
# from recipes there to the usda standard reference as best we can
def main():

    usdaIngredList = UsdaIngredientList()
    # usdaIngredList.printOut()

    gramMapList = GramMappingList()
    # gramMapList.printOut()

    page_count = int(number_of_recipes_to_scrape / recipes_per_page)

    for page_index in range(page_count):
        page_url = get_page_url(page_index, recipes_per_page)
        page_soup = BeautifulSoup(requests.get(page_url).text, 'html5lib')
        page_recipes = get_recipes_in_page(page_soup)

        for recipe_html in page_recipes:
            recipe = parse_recipe(recipe_html)
            replaced_ingredients_with_gram_map = ingredMapReplace(recipe, usdaIngredList, gramMapList)

            print_recipe(recipe)
            print_ingredients_and_gram_map(replaced_ingredients_with_gram_map)


# returns a Recipe object parsed from the input html
def parse_recipe(recipe_html):
    recipe_url = get_recipe_url(recipe_html)
    recipe_soup = BeautifulSoup(requests.get(recipe_url).text, "html5lib")

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


# performs fuzzy matching on recipe ingredients and selects a random gram mapping
# for each ingredient
random.seed(564)
def ingredMapReplace(recipe, usdaIngredList, gramMapList):
    replaced_ingredients_with_gram_mappings = []

    for recipe_ingredient in recipe.ingredients.items:

        # NOTE: random.choice needs a list
        # fuzzy match recipe ingredient to usda ingredient
        ingredient_match = process.extractOne(recipe_ingredient, usdaIngredList.ingredDict.keys(), scorer=fuzz.partial_ratio)
        ingred = ingredient_match[0]

        # randomly select one of the usda foods with that name
        usdaIngred = random.choice(usdaIngredList.ingredDict[ingred])

        # randomly select one of the gram mappings associated with that food
        # it appears there are some food where there is no gram mapping
        # in that case, pick random gram mapping
        if usdaIngred.id in gramMapList.gramMapDict:
            gramMap = random.choice(gramMapList.gramMapDict[usdaIngred.id])
        else:
            rand_ingred = random.choice(list(gramMapList.gramMapDict.keys()))
            gramMap = random.choice(list(gramMapList.gramMapDict.keys()))

        ingredient_and_gram_map = (usdaIngred, gramMap)

        # build list of matched ingredients with gram mappings
        replaced_ingredients_with_gram_mappings.append(ingredient_and_gram_map)

    return replaced_ingredients_with_gram_mappings


def print_ingredients_and_gram_map(ingredients_and_gram_map):
    for ingredient_and_gram_map in ingredients_and_gram_map:
        usda_ingred, gram_map = ingredient_and_gram_map
        print(usda_ingred.ingredientName)
        print(gram_map)
        print()


def print_recipe(recipe):
    recipe.tsv_out()
    # recipe.pretty_out()


if __name__ == "__main__":
    main()
