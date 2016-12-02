class Ingredients:
    def __init__(self, items):
        self.items = []

        for item in items:
            self.items.append(self.clean(item))

    def __str__(self):
        return "^".join(self.items)

    def clean(self,text):
        text = text.replace('\t', ' ')
        text = text.replace('\r', '\n')

        # Strip whitespace list/array around new lines, replaces with @newline@ token
        line_array = text.split("\n")
        line_array = [" ".join(line.strip().split()) for line in line_array]
        text = "@newline@".join(line_array)

        return ''.join(i for i in text if ord(i) < 128)

if __name__ == '__main__':
    ingreds = Ingredients(['one','two','three'])
    print(str(ingreds))
