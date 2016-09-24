import urllib.request as ul

from bs4 import BeautifulSoup


def main():
    number_of_recipes_to_scrape = 1000
    page_size = 20
    page_count = int(number_of_recipes_to_scrape / page_size)
    for page_number in range(page_count):
        search_link = get_search_url(page_number, page_size)
        response = ul.urlopen(search_link)

        page_soup = BeautifulSoup(response, 'lxml')

        # first result has class firstResult, the rest don't
        page_recipes = [(page_soup.find('div', class_='sr_rows clearfix firstResult'))]
        rest_of_recipes = page_soup.find_all('div', attrs={"class": 'sr_rows clearfix '})
        for r in rest_of_recipes:
            page_recipes.append(r)

        print("Found " + str(len(page_recipes)) + " in this page")
        for recipe in page_recipes:
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
            print("Description: " + clean(description) + "\n")
            print(clean(ingredients))
            print("Preparation: " + "\n" + clean(preparation))


def get_search_url(page_number, page_size):
    return 'http://www.epicurious.com/tools/searchresults?search=&pageNumber=' \
           + str(page_number) + '&pageSize=' + str(page_size) \
           + '&resultOffset=' + str(page_size * (page_number - 1) + 1)


def clean(text):
    text = ''.join(i for i in text if ord(i) < 128)
    text.replace('\t', ' ')
    return text

if __name__ == "__main__":
    main()
