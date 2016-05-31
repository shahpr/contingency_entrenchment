#!/usr/bin/perl
# Initialize packages
$i=$ARGV[0];

open fo,">output_$i";

$id=0;
for($j=1;$j<=30;$j++)
{	$h=$j-1;
	`perl clust.create.fx.mut.pl $i $j $id`;
	`./foldx3b6 -runfile run$j`;
		
	`tar rf gauss_fwd_suppfiles_$i.tar Ave*run$j Pdb*run$j Raw*run$j ddG*run$j`;
        	`rm Ave*run$j Pdb*run$j Raw*run$j ddG*run$j`;

	$id=`perl clust.calc.fixn.prob.fx.mult.pl Dif_ddG_run$j`;
	print fo "$j\t$id\n";
}
close(fo);
