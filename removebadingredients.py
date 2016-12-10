ingredFile = open('./usda/ingredients.tsv', 'r')
recipIngredFile = open('./epicurious/recipe_ingredients_w_id.tsv', 'r')
recipIngredCleanFile = open('./epicurious/recipe_ingredients_final.tsv','w')
gramMapFile = open('./usda/weight_cleaned_w_id.tsv', 'r')
gramMapCleanFile = open('./usda/weight_final.tsv','w')

ingList = {}

for line in ingredFile:
    ing_id = line.split('\t')[0]
    ingList[ing_id] = None

for line in recipIngredFile:
    ing_id = line.split('\t')[2]
    if ing_id in ingList.keys():
        recipIngredCleanFile.write(line)

for line in gramMapFile:
    ing_id = line.split('\t')[1]
    if ing_id in ingList.keys():
        gramMapCleanFile.write(line)

ingredFile.close()
recipIngredFile.close()
recipIngredCleanFile.close()
gramMapFile.close()
gramMapCleanFile.close()