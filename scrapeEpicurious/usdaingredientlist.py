from usdaingredient import UsdaIngredient

class UsdaIngredientList:
    __infilename = 'ingredients.tsv'
    
    def __init__(self):
        self.ingredDict = {}
        self.buildIngredientsList()

    def buildIngredientsList(self):
        with open(self.__infilename,'r') as infile:
            for line in infile:
                lineArr = line.split('\t')

                foodId = lineArr[0] #food id
                foodGroup = lineArr[1] #food group id

                temp = lineArr[2].strip().split(',',1)

                ingredName = temp[0]
                if len(temp) > 1: description = temp[1]
                else: description = None

                usdaIngred = UsdaIngredient(foodId,foodGroup,ingredName,description)

                if usdaIngred.ingredientName in self.ingredDict.keys():
                    tempList = self.ingredDict[usdaIngred.ingredientName]
                    tempList.append(usdaIngred)
                    self.ingredDict[usdaIngred.ingredientName] = tempList
                else:
                    self.ingredDict[usdaIngred.ingredientName] = [usdaIngred]

    def printOut(self):
        for key in self.ingredDict:
            print(key)
            for obj in self.ingredDict[key]:
                printString = '\t'.join([obj.id,obj.foodGroup])
                if obj.description: printString = '\t'.join([printString,obj.description])
                else: printString = '\t'.join([printString,key])
                print(printString)
            print()

if __name__ == '__main__':
    test = UsdaIngredientList()
    test.printOut()
