class GramMapping:
    def __init__(self,ingredientID,amount,unit,grams):
        self.ingredientID = ingredientID
        self.amount = amount
        self.unit = unit
        self.grams = grams

if __name__ == '__main__':
    temp = GramMapping('01001',1,'pat (1" sq, 1/3" high)',5.0)
    print(temp.ingredientID)
    print(temp.amount)
    print(temp.unit)
    print(temp.grams)
