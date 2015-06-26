#!/usr/bin/perl

use Getopt::Long;
GetOptions("help!"=>\$help,"path=s"=>\$vibh_home,"input=s"=>\$input,"output=s",\$output);
print "Unprocessed by Getopt::Long\n" if $ARGV[0];
foreach (@ARGV) {
	print "$_\n";
	exit(0);
}

if($help eq 1) {
	print "Word Smoothing \n(1st Jun 2010 )\n\n";
	print "usage : perl ./word_smt.pl --path=/home/mul_word [-i inputfile|--input=\"input_file\"] [-o outputfile|--output=\"output_file\"] \n";
	print "\tIf the output file is not mentioned then the output will be printed to STDOUT\n";
	exit(0);
}

if($vibh_home eq "") {
	print "Please Specify the Path as defined in --help\n";
	exit(0);

}

require "$vibh_home/API/shakti_tree_api.pl";
require "$vibh_home/API/feature_filter.pl";

open(PSYLIST,"$vibh_home/data_src/psycho.txt");
@PSY=<PSYLIST>;
chomp(@PSY);

%psy_root=();
foreach $psy_2(@PSY)
{
        ($noun,$temp)=split(/,/,$psy_2);
        $key=$noun;
        $psy_root{$key}=$temp;
}

open(CASTELIST,"$vibh_home/data_src/caste.txt");
@CAS=<CASTELIST>;
chomp(@CAS);
%caste_root=();
foreach $caste_2(@CAS)
{
        ($noun,$temp)=split(/,/,$caste_2);
        $key=$noun;
        $caste_root{$key}=$temp;
}



sub word_smt
{
	&read($input);
	@nodes=&get_leaves();
	for($i=0;$i<=@nodes;$i++)
	{
		$cword = &get_field($nodes[$i],2);
		$cpos = &get_field($nodes[$i],3);
		$cfs = &get_field($nodes[$i],4);

		$cfs_array = &read_FS($cfs);
		@ccat = &get_values("cat", $cfs_array);
		@ctam= &get_values("vib", $cfs_array);
		@croot= &get_values("lex", $cfs_array);

		if($i!=0) {
			$pword1 = &get_field($nodes[$i-1],2);
			$fs = &get_field($nodes[$i-1],4);
			$pos = &get_field($nodes[$i-1],3);

			$fs_array1 = &read_FS($fs);
			@cat1 = &get_values("cat", $fs_array1);
			@tam1= &get_values("vib", $fs_array1);
			@root1= &get_values("lex", $fs_array1);
			@num1= &get_values("num", $fs_array1);
			my $psy2=$psy_root{$croot[0]};

			if(($cat1[0]!~/psp|avy|e/)&&(($cpos eq "RP")||($cpos eq "VAUX"))&&($croot[0] eq "e")) {
				$npword1 = $pword1.$cword;

				$npword1 =~s/Me$/me/g;
				$npword1 =~s/wae$/wane/g;
				$npword1 =~s/[aui]e$/e/g;
				$npword1 =~s/([AIUEeOo])e$/$1ne/g;
				$npword1 =~s/eVe$/e/g;
				$npword1 =~s/oVe$/e/g;
				&modify_field($nodes[$i-1],2,$npword1);
				&modify_field($nodes[$i],2,"");
				$npword1="";
			}
			if(($cat1[0] eq "pn")&&($ccat[0] eq "n")&&($tam1[0] eq "yoVkka")&&($psy2 eq "yes")){
				if($num1[0] eq "pl"){
				$nroot="vAri";
				}
				else{
				$nroot="wana";
				}
				&modify_field($nodes[$i-1],2,$nroot);
			}

###############################PARAMESH 150713################
			my $caste2=$caste_root{$croot[0]};
#print "$croot[0] and $root1[0] and $caste2--\n";
			if(($root1[0]=~/udu$/)&&($caste2 eq "yes")) {
#print "$croot[0] and $root1[0] and $caste2\n";
				$root1[0]=~s/udu$/a/g;

				my @arr=$root1[0];
				$j=$i-1;

				foreach (@arr)
				{
					&modify_field($nodes[$j],2,$_);
					$fs=&get_field($nodes[$j],4);
					$fs_array = &read_FS($fs,$sent);
					$fs2=&get_field($nodes[$j-1],4);
					$fs_array2 = &read_FS($fs2,$sent);
					$lex[0]=$_;
					&modify_field($nodes[$j],2,$lex[0]);
					&update_attr_val("lex",\@lex, $fs_array,$sent);
					my $string=&make_string($fs_array,$sent);
					my $string2=&make_string($fs_array2,$sent);
					&modify_field($nodes[$j],4,$string);
					&modify_field($nodes[$j-1],4,$string2);
					$j++;
					$newpword1="";
				}
			}
###############################PARAMESH 150713################
		}

		&modify_field($node,2,$root);
		&update_attr_val("lex", \@lex, $fs_array,$sent);
		my $string=&make_string($fs_array,$sent);
		&modify_field($node,4,$string);

	}


}

&word_smt();
if($output eq "")
{
	&print_tree();
}
else
{
	&print_tree_file($output);
}
