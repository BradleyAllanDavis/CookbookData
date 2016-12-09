class GramMap:

    def __init__(self, id, unit, gramAmount):
        self.id = str(id)
        self.unit = str(unit)
        self.gramAmount = str(gramAmount)

    def __str__(self):
        return '\t'.join([self.id, self.unit, self.gramAmount])

output = {}

with open('grammap.tsv', 'r') as file:
    for line in file:
        splitLine = line.split('\t')
        ingredID = splitLine[0]

        if ingredID not in output.keys():
            amountCommonMeasure = float(splitLine[2].strip())
            unit = splitLine[3].strip()
            gramAmount = float(splitLine[4].strip())
            scaledGramAmount = gramAmount / amountCommonMeasure
            output[ingredID] = GramMap(ingredID, unit, scaledGramAmount)

ingredList = list(output.keys())
ingredList.sort()

with open('grammap_clean.tsv', 'w') as file:
    for key in ingredList:
        file.write(str(output[key]))
        file.write('\n')
