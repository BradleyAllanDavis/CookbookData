from grammapping import GramMapping

class GramMappingList:
    __infilename = 'usda/weight.tsv'

    def __init__(self):
        self.gramMapDict = {}
        self.buildGramMapping()

    def buildGramMapping(self):
        with open(self.__infilename,'r') as infile:
            for line in infile:
                lineArr = line.split('\t')

                ingredientID = lineArr[0].strip()
                #optionLine = lineArr[1].strip() #Not used in data model
                amount = lineArr[2].strip()
                unit = lineArr[3].strip()
                grams = lineArr[4].strip()

                gramMap = GramMapping(ingredientID, amount, unit, grams)

                if gramMap.ingredientID in self.gramMapDict.keys():
                    tempList = self.gramMapDict[gramMap.ingredientID]
                    tempList.append(gramMap)
                    self.gramMapDict[gramMap.ingredientID] = tempList
                else: self.gramMapDict[gramMap.ingredientID] = [gramMap]

    def printOut(self):
        for key in self.gramMapDict:
            print(key)
            for obj in self.gramMapDict[key]:
                print('\t'.join([obj.ingredientID,obj.amount,obj.unit,obj.grams]))

if __name__ == '__main__':
    temp = GramMappingList()
    temp.printOut()
