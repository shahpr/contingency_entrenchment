from modeller import *
from optparse import OptionParser
parser = OptionParser()

parser.add_option("-t", dest="host")
parser.add_option("-m", dest="mut")
(options, args) = parser.parse_args()

pdb = options.host + '.pdb'
hali = options.host + '.ali'
mali = options.mut + '.ali'
oali = options.mut + '-' + options.host + '.ali'

print pdb
print hali
print mali
print oali

env = environ()
aln = alignment(env)
env.io.hetatm = False
mdl = model(env, file=options.host, model_segment=('FIRST:E','LAST:E'))
aln.append_model(mdl, align_codes=options.host, atom_files=pdb)
aln.append(file=mali, align_codes=options.mut)
aln.align2d()
aln.write(file=oali, alignment_format='PIR')
