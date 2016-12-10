recIngIn = open('./epicurious/recipe_ingredients_final.tsv', 'r')
recIngOut = open('./epicurious/cookbook_recipeingredient.tsv', 'w')
gramMapIn = open('./usda/weight_final.tsv', 'r')

gramMapIdList = []

for line in gramMapIn:
    splitLine = line.split('\t')
    ing_id = splitLine[1]
    com_mes = splitLine[2]
    line_id = splitLine[0]
    gramMapIdList.append([(ing_id, com_mes),line_id])

for line in recIngIn:
    splitLine = line.split('\t')
    ing_id = splitLine[2]
    com_mes = splitLine[3]
    for i in gramMapIdList:
        if i[0] == (ing_id, com_mes):
            recIngOut.write('\t'.join([splitLine[0], splitLine[1], ing_id, i[1], splitLine[4]]))
