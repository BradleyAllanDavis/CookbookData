# You've been asked to write an app that, given a bunch of search terms,
# delivers a recipe (name, description, ingredients, and instructions)
# to the user. You decide that the simplest thing to do is to:
# 1. ask the user to enter their search terms
# 2. construct an epicurious url with these search terms
# 3. get a list of recipes from epicurious
# 4. pick the first recipe from this list
# 5. open the recipe page
# 6. extract the name, description, ingredients and instructions from the recipe page
# 7. print them out so that the user can see them. 

# For example: spicy cumin burritos; banana strawberry

import urllib.request as ul

from bs4 import BeautifulSoup


def main():
    while True:
        term = input("Enter a search term or END to exit: ")
        if term == 'END':
            exit()

        terms_str = "+".join(term.split())
        search_link = 'http://www.epicurious.com/tools/searchresults?search=' + terms_str
        response = ul.urlopen(search_link)

        epicurious_soup = BeautifulSoup(response, 'lxml')

        # first result has class firstResult, the rest don't
        # all_recipes = epicurious_soup.find('div', class_='sr_rows clearfix firstResult')
        all_recipes = epicurious_soup.find_all('div', attrs={"class": 'sr_rows clearfix '})

        for recipe in all_recipes:
            # first 'a' has the url suffix
            recipe_name = recipe.find_all('a')[0].get('href')

            recipe_link = 'http://www.epicurious.com' + recipe_name
            url_recipe = ul.urlopen(recipe_link)
            recipe_soup = BeautifulSoup(url_recipe, "lxml")

            name = recipe_soup.find('div', class_='title-source').find('h1').get_text()

            if recipe_soup.find('div', class_='dek') is not None:
                description = recipe_soup.find('div', class_='dek').get_text('p')
            else:
                description = "None"

            ingredients = recipe_soup.find('div', class_='ingredients-info').get_text(separator="\n")
            preparation = recipe_soup.find('div', class_='instructions', itemprop='recipeInstructions').find(
                'li').get_text(
                separator="\n")

            print("--------")
            print("\n" + 'Name: ' + name + "\n")
            print("Description: " + str(description.encode('utf-8')) + "\n")
            print(str(ingredients.encode('utf-8')))
            print("Preparation: " + "\n" + str(preparation.encode('utf-8')))


if __name__ == "__main__":
    main()
