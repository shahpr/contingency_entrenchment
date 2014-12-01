from modeller import *
from modeller.automodel import *
from optparse import OptionParser
import sys
parser = OptionParser()

parser.add_option("-t", dest="host")
parser.add_option("-m", dest="mut")
parser.add_option("-c", dest="cid")
parser.add_option("-i", dest="ite")
parser.add_option("-r", dest="run")
(options, args) = parser.parse_args()

oali = options.mut + '-' + options.host + '.ali'
odope = 'dope' + options.run + '.seq' + options.ite

# Give less weight to all soft-sphere restraints:
env = environ()
env.schedule_scale = physical.values(default=1.0, soft_sphere=0.7)
env.io.atom_files_directory = ['.', '../atom_files']
env.io.hetatm = False

a = automodel(env, alnfile=oali,
              knowns=options.host, sequence=options.mut,
	      assess_methods=(assess.normalized_dope,assess.DOPEHR))
#	      assess_methods=(assess.DOPEHR))

a.starting_model = 1
a.ending_model = 1

# Very thorough VTFM optimization:
a.library_schedule = autosched.slow
a.max_var_iterations = 300

# Thorough MD optimization:
a.md_level = refine.slow

# Repeat the whole cycle 2 times and do not stop unless obj.func. > 1E6
#a.repeat_optimization = 2
a.max_molpdf = 1e6
a.make()

# Get a list of all successfully built models from a.outputs
ok_models = [x for x in a.outputs if x['failure'] is None]

key = 'DOPE-HR score'
m = ok_models[0]
f = open(odope, 'a')
org2 = m[key]
f.write("%d\t%.5f\n" % (int(options.cid), org2))
