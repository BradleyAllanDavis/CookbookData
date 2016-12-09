import random

class Recipe:

    def __init__(self, id, name, description, instructions, servings):
        self.id = str(id)
        self.name = str(name)
        self.description = str(description)
        self.instructions = str(instructions)
        self.servings = str(servings)

    def __str__(self):
        return '\t'.join([self.id, self.name, self.description, self.instructions, self.servings])

random.seed(564)

recipes = []

with open('recipes.tsv','r') as file:
    for line in file:
        splitLine = line.split('\t')
        id = splitLine[0].strip()
        name = splitLine[1].strip().rsplit('@newline@', 1)[0]
        description = splitLine[2].strip().rsplit('@newline@', 1)[0]
        instructions = splitLine[3].strip().rsplit('@newline@', 1)[0]
        servings = random.randint(1, 12)
        recipes.append(Recipe(id, name, description, instructions, servings))

with open('recipes_clean.tsv','w') as file:
    for obj in recipes:
        file.write(str(obj))
        file.write('\n')