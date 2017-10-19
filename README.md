# Building homology models of mutants using Modeller 9.11 involves two steps 
	1. Structure-based sequence alignment
	2. Building a homology model based on aligned sequences

### Generating a structure-based sequence alignment
Template sequence — 1LAF.ali
Template PDB structure — 1LAF.pdb
Mutant sequence — 1LAF_mutant.ali

modeller9.11/bin/modpy.sh python align.py -t 1LAF -m 1LAF_mutant

#### The above command would generate an aligned sequence file — 1LAF_mutant-1LAF.ali


### Generating a homology model 
modeller9.11/bin/modpy.sh python md-model-build-dope.py -t 1LAF -m 1LAF_mutant

#### The above command will generate a file with DOPE score — output

#####################################################################################

# Computing protein stabilities of mutants using FoldX involves two steps
1. Using RepairPDB to remove bad torsion angles and van der Waal’s clashes from the PDB file
2. Using BuildModel to compute the differences in protein stabilities between the template and the mutant

./foldx64Linux -runfile repairPDB.txt

./foldx64Linux -runfile foldx_run.txt

#####################################################################################

#### All simulation results on both DOPE and FoldX are provided as .RData objects.
