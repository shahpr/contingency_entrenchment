#!/usr/bin/perl

# List of amino acids
@aa=("A","C","D","E","F","G","H","I","K","L","M","N","P","Q","R","S","T","V","W","Y");

# Read in seq file where new/next mutant is to be added
$prev=$ARGV[1]-1;
open fi,"mutant_file$prev";
chomp(@s=<fi>);

# Output file nam
open fo,">mutant_file$ARGV[1]";

$id=$ARGV[2];
$base=$s[$id];
@seq=split('',$base);

open fo2,">mut_id$ARGV[0].$ARGV[1]";
print fo "$s[0]\n$base\n";

for($i=0;$i<10;$i++)
{	@tseq=@seq;

	$pos=int(rand(238));
	$taa=$seq[$pos];
	$raa=$aa[int(rand(20))];

	until($taa ne $raa)
	{	$raa=$aa[int(rand(20))];
	}
	$tseq[$pos]=$raa;

	$tmp_seq=join('',@tseq);

	print fo "$tmp_seq\n";
	print fo2 "$pos\t$taa\t$raa\n";
}
