filename = input("local filepath: ")

infile = open(filename + '.tsv', 'r')
outfile = open(filename + '_w_id.tsv', 'w')

count = 0
for line in infile:
    count += 1
    outfile.write('\t'.join([str(count), line]))

infile.close()
outfile.close()