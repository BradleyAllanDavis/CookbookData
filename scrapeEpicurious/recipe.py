from ingredientlist import Ingredients

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
        print("\t".join([self.clean(self.name),
                         self.clean(self.description),
                         str(self.ingredients),
                         self.clean(self.preparation),
                         str(self.tags)]))

    # returns the input string with tabs and non-ascii characters removed
    def clean(self,text):
        text = text.replace('\t', ' ')
        text = text.replace('\r', '\n')

        # Strip whitespace list/array around new lines, replaces with @newline@ token
        line_array = text.split("\n")
        line_array = [" ".join(line.strip().split()) for line in line_array]
        text = "@newline@".join(line_array)

        return ''.join(i for i in text if ord(i) < 128)

if __name__ == '__main__':
    rec = Recipe('some name','a description',Ingredients(['one','two','3']),'',Ingredients(['tags are','secretly ingredients!']))
    rec.pretty_out()
    rec.tsv_out()
