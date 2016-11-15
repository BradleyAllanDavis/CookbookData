class UsdaIngredient:
    def __init__(self, ingredientID, foodGroup, ingredientName, description):
        self.id = ingredientID
        self.foodGroup = foodGroup
        self.ingredientName = ingredientName
        self.description = description

if __name__ == '__main__':
    temp = UsdaIngredient(1000, 100, 'Candy', 'some dumb thing')
    print(temp.id)
    print(temp.foodGroup)
    print(temp.ingredientName)
    print(temp.description)
