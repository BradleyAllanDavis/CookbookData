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
        sector_result = epicurious_soup.find('div', class_='sr_rows clearfix firstResult')
        first_recipe = sector_result.find_all('a')[0].get('href')

        recipe_link = 'http://www.epicurious.com' + first_recipe
        url_recipe = ul.urlopen(recipe_link)
        recipe_soup = BeautifulSoup(url_recipe)

        name = recipe_soup.find('div', class_='title-source').find('h1').get_text()

        if recipe_soup.find('div', class_='dek').get_text('p'):
            description = recipe_soup.find('div', class_='dek').get_text('p')
        else:
            description = "None"

        ingredients = recipe_soup.find('div', class_='ingredients-info').get_text(separator="\n")
        preparation = recipe_soup.find('div', class_='instructions', itemprop='recipeInstructions').find('li').get_text(
            separator="\n")

        print("\n" + 'Name: ' + name + "\n")
        print("Description: " + str(description.encode('utf-8')) + "\n")
        print(ingredients)
        print("Preparation: " + "\n" + str(preparation))


if __name__ == "__main__":
    main()
