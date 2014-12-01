from modeller import *
from modeller.automodel import *
from optparse import OptionParser
import sys
parser = OptionParser()

parser.add_option("-t", dest="host")
parser.add_option("-m", dest="mut")
(options, args) = parser.parse_args()

oali = options.mut + '-' + options.host + '.ali'
odope = 'output'

# Give less weight to all soft-sphere restraints:
env = environ()
env.schedule_scale = physical.values(default=1.0, soft_sphere=0.7)
env.io.atom_files_directory = ['.', '../atom_files']
env.io.hetatm = False

a = automodel(env, alnfile=oali,
              knowns=options.host, sequence=options.mut,
	      assess_methods=(assess.normalized_dope,assess.DOPEHR))

a.starting_model = 1
a.ending_model = 1

# Very thorough VTFM optimization:
a.library_schedule = autosched.slow
a.max_var_iterations = 300

# Thorough MD optimization:
a.md_level = refine.slow

a.max_molpdf = 1e6
a.make()

# Get a list of all successfully built models from a.outputs
ok_models = [x for x in a.outputs if x['failure'] is None]

key = 'DOPE-HR score'
m = ok_models[0]
f = open(odope, 'a')
org2 = m[key]
f.write("%.5f\n" % (org2))
