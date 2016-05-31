#!/usr/bin/perl

open fi,"$ARGV[0]";
chomp(@vals=<fi>);

$Var=1425;			# Variance of fitness function 1
$Ne=10000;			# Effective population size

$outfile=$ARGV[0].".list";		# Output file name

open fo,">$outfile";		# Output file

@fprob=();		# Vector for fixation probs
$tot_prob=0;		# Cumulative prob for normalization

@array=($Var);		# An array for variance and value of current mutant

@a=split(/\t/,$vals[9]);	# The 10th row contains the value of the previous fixed mutant (again)
$prvVal=$a[1];		# The second column is the ddg value of previous mutant
@tmp=($Var,$prvVal);	# An array for variance and value of previous mutant

$prvlprob=calc_dnorm_log(@tmp);	# Calculate the log-fitness of the previous mutant

$numer=$prvlprob;			# Numerator in the fixation probability

for($i=10;$i<@vals;$i++)		
{	@a=split(/\t/,$vals[$i]);
	push(@array,$a[1]);		# Add ddg of current mutant to the array being passed to log-fitness calculations

	$currlprob=calc_dnorm_log(@array);		# Calculate the log-fitness of the current mutant
	$fitness_ratio=exp($numer-($currlprob));	# Calculate the log-fitness ratio of the previous to current mutant

	if($fitness_ratio!=1)			# If the mutant is not neutral
	{	$fprob[$i-10]=(1-$fitness_ratio)/(1-($fitness_ratio)**$Ne);
	}
	else
	{	$fprob[$i-10]=1/$Ne;		# If the mutant is neutral
	}

	$tot_prob+=$fprob[$i-10];			# Total fixation probability

	pop(@array);
}

$rnd=rand();	# A random number

$cum_prob=0;
$id=0;
for($i=10;$i<@vals;$i++)
{	$cum_prob+=$fprob[$i-10]/$tot_prob;		# Cumulative fixation probability
	@a=split(/\t/,$vals[$i]);
	if($rnd<$cum_prob & $id==0)		
	{	$id=1;
		$mpos=$i-8;			# Pick a mutant based on the random number and fixation prob
	}
	print fo "$a[0]\t$a[1]\t$fprob[$i-10]\t$cum_prob\n";	# Print the output
}
print $mpos;					# Return the mutant being fixed at the current stage

# Function for calculating the log-fitness of a mutant
sub calc_dnorm_log
{	$var=$_[0];
	$dif=$_[1];

	$out=-0.5*($dif**2)/$var;
	return $out;
}
