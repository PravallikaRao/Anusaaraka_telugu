#!/usr/bin/perl

use Getopt::Long;
GetOptions("help!"=>\$help,"path=s"=>\$vibh_home,"input=s"=>\$input,"output=s",\$output);
print "Unprocessed by Getopt::Long\n" if $ARGV[0];
foreach (@ARGV) {
	print "$_\n";
	exit(0);
}

if($help eq 1) {
	print "Telugu Generator  - Generator Version 0.91\n(9th Sep 2008 )\n\n";
	print "usage : perl ./tel_gen.pl --path=/home/tel_gen [-i inputfile|--input=\"input_file\"] [-o outputfile|--output=\"output_file\"] \n";
	print "\tIf the output file is not mentioned then the output will be printed to STDOUT\n";
	exit(0);
}

if($vibh_home eq "") {
	print "Please Specify the Path as defined in --help\n";
	exit(0);

}

require "$vibh_home/API/shakti_tree_api.pl";
require "$vibh_home/API/feature_filter.pl";

open(ROOTDICT,"$vibh_home/data-src/tel/wrdg-root");
@ROOTS = <ROOTDICT>;
chomp(@ROOTS);

open(FEATUREVALUE,"$vibh_home/data-src/tel/feature_value");
@FEATURE = <FEATUREVALUE>;
chomp(@FEATURE);

open(SEFEATUREVALUE,"$vibh_home/data-src/tel/second_fe");
@SEFEATURE = <SEFEATUREVALUE>;
chomp(@SEFEATURE);

open(SUFFINFO,"$vibh_home/data-src/tel/suff_info");
@SUFF = <SUFFINFO>;
chomp(@SUFF);

open(COMPLX,"$vibh_home/data-src/tel/complxverb");
@COM = <COMPLX>;
chomp(@COM);

%root_hash = ();
foreach $root_1 (@ROOTS) {
	($root,$lcat,$pdgm) = split(/\,/,$root_1);
	$key = $root."___".$lcat;
	$root_hash{ $key } = $pdgm;
}

%verb_root = ();
foreach $root_2 (@COM) {
	($lcat,$tam,$temp) = split(/\s+/,$root_2);
	$key = $lcat."___".$tam;
	$verb_root{ $key } = $temp;
}

$num = @FEATURE;
%feat_hash = ();
for( $i = 0; $i < $num; $i++) {
	$feat_1 = $FEATURE[$i];
	($lcat,$suffix,$g,$n,$p) = split(/\s+/,$feat_1);
	$line_num = $i+1;
	$key = $lcat."___".$suffix."___".$g."___".$n."___".$p;
	$feat_hash{ $key } = $line_num;
}

$num2 = @SEFEATURE;
%feat_hash2 = ();
for( $i = 0; $i < $num2; $i++) {
	$feat_2 = $SEFEATURE[$i];
	($lcat,$suffix,$g,$n,$p) = split(/\s+/,$feat_2);
	$line_num = $i+1;
	$key2 = $lcat."___".$suffix."___".$g."___".$n."___".$p;
	$feat_hash2{ $key2 } = $line_num;
}

%suff_hash = ();
foreach $suff_1 (@SUFF) {
	($add,$del,$pdgm,$junk,$line_num) = split(/\,/,$suff_1);
	$key = $pdgm."___".$line_num;
	$suff_hash{ $key } = $add."___".$del;
}

sub tel_gen {
	&read($input);
	@nodes=&get_leaves();
	foreach $node (@nodes) {
		$fsSt = &get_field($node,4);
		$fsSt1 = &get_field($node-1,4);
		$fsSt2 = &get_field($node+1,4);
		$pos= &get_field($node,3);
		$tkn= &get_field($node,2);
		$fs_array = &read_FS($fsSt);
		$fs_array1 = &read_FS($fsSt1);
		@lex = &get_values("lex", $fs_array); @cats = &get_values("cat", $fs_array);
		@tams = &get_values("vib", $fs_array); @suff = &get_values("tam", $fs_array);
		@kase = &get_values("cas", $fs_array); @gens = &get_values("gen", $fs_array);
		@nums = &get_values("num", $fs_array); @pers = &get_values("per", $fs_array);
		@nums1 = &get_values("num", $fs_array1); @lex1 = &get_values("lex", $fs_array1); 
		@cats1 = &get_values("cat", $fs_array1); @tams1 = &get_values("vib", $fs_array1); 
		@nums2 = &get_values("num", $fs_array1); @lex2 = &get_values("lex", $fs_array1); 
		@cats2 = &get_values("cat", $fs_array1); @tams2 = &get_values("vib", $fs_array1); 

		$root = $lex[0]; $lcat = $cats[0]; $kase = $kase[0]; $tam = $tams[0]; 
		$suff = $suff[0]; $gen = $gens[0]; $num = $nums[0]; $per = $pers[0]; $num1=$nums1[0];
		$roots = $lex2[0]; $lcat2 = $cats2[0]; $tams2 = $tams2[0]; 

		if(($roots eq "wAnu")&&($root eq "wana")&&($lcat2 eq $lcat)&&($tam eq "yoVkka")&&($tam ne "")){
			$tam=$tams2;
		}

		$tam=~s/^-//g; $tam=~s/\^//g;
		if(($lcat eq "n")&&($per eq "1")&&($tam eq "0")){
			$tam="nu";
		}
		elsif(($lcat eq "n")&&($per eq "2")&&($tam eq "0")){
			$tam="vu";
		}

		if((($tam eq "")||($tam eq "0"))&&($lcat eq "adj")){
			$tam="0";
			if($num eq "sg"){
				if($gen=~/f|n/){
					$gen="fn";
					$per="3"
				}
			}
			if($num eq "pl"){
				if($gem=~/m/){
					$gen="fm";
				}
				else{
					$gen="n";
				}
				$per="3"
			}
			$kase=~s/any/o/g;
		}
		if(($tam eq "")&&($lcat eq "v")){
			$tam="AjFArWa";	
		}	
		if($tam eq "AjFArWa"){
			$gen="null";
		}

		if($tam eq "adaM_ki"){
			$gen = "n"; $per = "3";
		}
if(($root=~/-0/)&&($tam eq "0")){{
$num="sg";
}

}
if(($root=~/-0/)||(($root=~/^\@-$/)&&($tam eq "yoVkka"))){
	$root="";
	$tam="";
}

		if($root=~/^\@-$/){
			$root="";
		}
		$root=~s/^\@-//g;

		if(($tam=~/^0/)||($tam=~/^0_/)) {
			$tam=~s/^0_//g;
			$tam=~s/^0//g;
		}
		if($tam=~/[yn]aMxu/) {
			$tam="aMxu";
		}

		if($tam eq "") {
			$tam = "0";
		}
		if($tam=~/^-/) {
			$tam =~s/^-//g;
		}
		if($tam eq "yoVkka"){
		if((($lcat eq "n")&&($num eq "pl"))||($lcat eq "pn")||($lcat eq "nst")){
		$tam="0";
		$kase="o"
		}
		}
		if(($lcat eq "pn")&&($root eq "vaha")){
		$root="wanu";
		}

		if(($pos eq "QC")&&($lcat eq "n")&&($num ne "pl")) {
			$num="sg";
		}
		if($tam=~/_oV$/) {
			$tam=~s/_oV$/_o/g;
		}

		if($tam=~/_ne$/) {
			$tam="0";
		}
	if(($lcat eq "pn")&&($per eq "any")){	
	$per="3";
	}

		if((($lcat eq "n")||($lcat eq "pn"))&&($tam eq "AjFArWa")) {
			$tam="0";
		}
		elsif(($lcat eq "v")&&($tam eq "AjFArWa")) {
			$gen="null";
			if($num eq "any") {
				$num = "sg";
				$per="2";
			}
		}
		elsif(($lcat eq "v")&&($tam eq "0")&&($gen eq "f")) {
			$tam="i";
		}
		if(($root eq "0")&&($tam eq "ani")){
			$root=$tam;
			$tam="";
		}
		if($lcat eq "n"){
			if($num eq "any") {
				$num="sg";
			}
			$gen="null";
			$per="null";
			if($tam eq "ku") {
				$tam = "ki";
			}
		}
		if($lcat eq "num") {
			if($gen eq "m" or $gen eq "f") {
				$gen = "fm";
				$num = "pl";
				$per="null";
			}
			elsif($gen ne "n") {
				$gen="null";
				$num="null";
				$per="null";
			}
		}
		if(($tam eq "lu")&&($num eq "pl")) {
			$tam ="0";
		}
		if($tam eq "nA_hE") {
			$tam="Ali";
		}

		if($root eq "0") {
			$tam = "";
		}

		if(($root eq "rA")&&($lcat eq "v")) {
			$root="vaccu";
		}
		if(($root=~/maMxi$/)&&($num eq "pl")) {
			$num="sg";
			
		}



		if((($tam eq "wA")||($tam eq "a")||($tam eq "A")||($tam eq "wunn")||($tam eq "iwi"))&&(($per eq "")||($per eq "3"))) {

			$per="3";
#blocked to check the per 3 - chris 120613
		#if($gen=~/f|n/){
		#	$per="2";
		#}
		}

		if(($lcat eq "v")&&(($tam eq "ina")||($tam eq "e"))&&($gen ne "any")&&($per ne "any")) {
			if($num eq "sg"){
				if($gen eq "m"){
					$per="3";
					$tam=$tam."_vAdu";
				}
				if(($gen eq "f")||($gen eq "n")){
					$per="3";
					$gen ="fn";
					$tam=$tam."_xi";
				}
			}
			if($num eq "pl"){
				if($gen=~/m/){
					$per="3";
					$tam=$tam."_vAlYlu";
				}
				else{
					$per="3";
					$tam=$tam."_vi";
				}
			}
		}
		if($lcat eq "adv") {
			$gen="null";
			$per="null";
			$num="null";
			if($tam eq "ki") {
				$tam ="ku"
			}
			elsif($tam eq "ni") {
				$tam ="nu"
			}
		}

		if($lcat eq "pn") {

#Date: 25-10-2009
#wheather d is always to be declared as 0 conjunction
#where as o disjoint with the specification of 0
#	if(($tam ne "")||($tam eq "0")) {$kase="d"; }else{$kase="o"; }
			if(($root eq "nenu")&&($num eq "pl")) {
				$root="memu";
			}
			#MUrthy10062013
			#if(($root eq "nenu")&&($num eq "sg")) {
			#	$root="nA";
			#}
			#if(($root eq "nenu")&&($num eq "sg")) {
			#	$root="nA";
			#}
			#if(($root eq "nenu")&&($num eq "sg")) {
			#	$root="nAku";
			#}
			if((($root=~/wanu/)&&($suff!~/^ne/))||(($root=~/wanu/)&&($roots=~/wanu/))) {
				if($suff=~/_reflex/){
					if($per eq "3"){
						$tam="";
						if(($gen eq "n")||($gen eq "any")) {
							$root="xAniki axe";
						}
						elsif($gen eq "m"){
							$root="vAdiki vAde";
						}
						elsif($gen eq "f"){
							$root="wanaku wAne";
						}
					}
					elsif($per eq "2"){
						$tam="";
						$root="nIku nuvve";
					}
					elsif($per eq "1"){
						$tam="";
						$root="nAku nene";
					}
				}
			}

			if(($root=~/wanu/)&&($per eq "3")&&($suff!~/^ne/)) {
				if($suff=~/_dist/){
			if(($num eq "sg")&&($tam ne "ki")) {
				if($gen eq "m") {
					$root ="vAdu";
				}
				elsif(($gen eq "n")||($gen eq "any")) {
					$root="axi";
				}
				elsif($gen eq "f") {
					$root="AmeV";
				}
			}
			if($num eq "pl") {
				#Murthy--01062013 gen="n" with tam is "ki"
				if(($gen eq "n")&&(($tam eq "0")||($tam eq "ki"))) {
					$root="vAru";
				}
				elsif(($gen=~/n/)&&($tam ne "0")) {
					$root="axi";
				}
				if(($gen eq "n")&&($tam eq "0")) {
					$root="avi";
				}
				elsif(($gen=~/fn/)||($gen=~/m/)) {
					$root ="vAru";
				}
				else {
					$root ="avi";
					$num="sg";
				}
			}
		}
		elsif($suff=~/_prox|_relat/){
			if(($num eq "sg")&&($tam ne "ki")) {
				if($gen eq "m") {
					$root ="vIdu";
				}
				elsif(($suff=~/_prox/)&&($gen eq "n")) {
					$root="ixi";
				}
				elsif(($suff=~/_prox/)&&($gen eq "f")) {
					$root="ImeV";
				}
				elsif(($gen eq "f")||($gen eq "any")) {
					$root="ixi";
				}
			if(($pos eq "DEM")&&(($gen eq "n")||($gen eq "any"))&&($per eq "3")) {
					$root="I";
				}
			}
			if($num eq "pl") {
				#if($gen eq "n") {
				#	$root="ivi";
				#}
				if($gen eq "any") {
					$root="ivi";
				}
				#Murthy--01062013 gen="n" with tam is "ki"
				if(($gen eq "n")||($gen eq "n")&&($tam ne "ki")) {
					$root="ivi";
				}
				if(($gen =~/m|f/)||($gen eq "any")&&($tam ne "0")) {
					$root="vIru";
				}
				if(($pos eq "DEM")&&(($gen eq "n")||($gen eq "any"))&&($per eq "3")) {
					$root="I";
				}
				#else {
			#		$root ="ivi";
			#	}
			}
		}
		else{
			if(($num eq "sg")&&($tam ne "ki")) {
				$root="axi";
			}
			elsif(($tam eq "0")&&($num eq "pl")) {
				$root="avi";
			}
		}

	}

	if(($root=~/vaha|wanu|axi/)&&($suff=~/_dist/)&&($per eq "3")&&($suff!~/^ne/)){
		if($num eq "sg") {
			if($gen eq "m") {
				$root ="vAdu";
			}
			elsif($gen eq "f") {
				$root ="AmeV";
			}
			else{
				$root="axi";
			}
		}
		elsif($num eq "pl") {
			if($gen eq "n") {
				if($tam eq "0") {
					$root="avi";
				}
				else{
					$root="axi";
				}
			}
			else{
				$root="vAru";
			}
		}
	}
	if((($root eq "e")||($root eq "eVvaru"))&&($suff=~/_interr/)&&($per eq "3")){
		if($num eq "sg"){
		#if(($num eq "sg")&&($num1 ne "pl" )) {
			if($gen eq "m") {
				$root="eVvadu";
			}
			elsif($gen eq "f") {
				$root="eVvaweV";
			}
			elsif($gen eq "n"){
				$root="exi";
			}
		}
		elsif($num eq "pl"){
			if($gen eq "n"){
				$root="evi";
			}
			else{
				$root="eVvaru";
			}
		}
	}
#Murthy - To convert nenu as nAku using tam attribute 27-05-2013	
	if(($root eq "nenu")&&($suff=~/_exclu/)&&($per eq "1")&&($num eq "sg")&&($tam eq "yoVkka")){
		$root="nAku";
	}
#Murthy - To convert nenu as nAku using tam attribute 08-11-2013	
	if(($root eq "nenu")&&($suff=~/ko_exclu/)&&($per eq "1")&&($num eq "sg")&&($tam eq "ni")){
		$root="nAku";
	}
	if(($root eq "nenu")&&($suff=~/_exclu/)&&($per eq "1")&&($num eq "pl")){
		$root="memu";
	}
	#if(($root eq "nIvu")&&($suff=~/_exclu/)&&($per eq "2")&&($num eq "pl")){
	if((($root eq "nIvu")||($root eq "nuvvu"))&&($per eq "2")&&($num eq "pl")){
		$root="mIru";
	}
elsif((($root eq "nIvu")||($root eq "nuvvu"))&&($per eq "2")&&($num eq "sg")){
		$root="nIvu";
	}
	$gen="null";
	$per="null";
	if($tam eq "ku") {
		$tam ="ki";
	}
}

if($root eq "0") {
	$root="";
}

if($lcat eq "v"){
	if($root eq "koVn") {
		$root="koVnu";
	}
	elsif($root eq "nAraMBiMcu") {
		$root="AraMBiMcu";
	}
	elsif($root eq "paracu") {
		$root="paruvu";
	}
	elsif($root eq "walacu") {
		$root="waluvu";
	}
#Blocked because it was not able to generate xalacu with tam=""
#on 05-02-2011
#	elsif($root eq "xalacu") {
#		$root="xaluvu";
#	}
#stopped on 030709 because of kattiMcina 
#if(($gen eq "n")&&($num eq "sg")&&($per eq "3")&&($tam eq "ina"))
#{
#	$tam ="A";
#}
}

if(($tam eq "aku")&&($num eq "any")){
$num="sg";
$gen="null";
}
elsif(($tam eq "aku")&&($num eq "pl")){
$num="pl";
$gen="any";
}

##########	
if($per eq "2h")
{
	$gen="any";
	$per="2";
	$num="pl";
}
if(($per eq "2")&&($num eq "pl")){
if($gen=~/f|m/){
$gen="f";
}
}

if(($tam eq "iwi")&&($per eq "3"))
{
	$num="pl";
	$gen="n";
}
elsif($gen eq "fm") {
	if(($per eq "any")){
		if($num eq "sg"){
			$gen="fn";
		}
	}
	elsif($per eq "3") {
		$num="pl";
	}
}
elsif(($per eq "3")&&($num eq "pl")&&((($gen=~/f|m/)||($tam eq "a"))&&($gen ne "n"))){
	$gen="fm";
}
elsif((($num eq "pl") &&  (($per eq "3")||($per eq "any")||($per eq "2")))&&(($gen eq "m")||( $gen eq "f")||($gen eq "fn")||($gen eq "")||($gen eq "n")||($gen eq "any"))) {
	if(($per ne "3")&&($gen ne "n")&&($tam ne "aku")){
		$gen="fm";
	}
	if(($lcat eq "v")&&($per eq "3")&&($num eq "pl")){
		$gen="n";
	}
	if(($num eq "pl")&&($per eq "2")&&($tam ne "aku")) {
		$per = "3";
	}
	if(($per eq "3")&&($gen ne "n")&&($num eq "pl")&&($tam ne "aku")){
		$gen ="fm";
	}
}
 elsif(($num eq "sg" &&  (($per eq "3")||($per eq "any")))&&(($gen eq "f")||( $gen eq "n")||($gen eq "any"))&&($lcat ne "adj")) {
        $gen="fn";
}
elsif(($num eq "pl" &&  $per eq "1")&&(($gen eq "f")||( $gen eq "n")||($gen eq "m")|($gen eq "any")||($gen eq "fm"))) {
        $gen="null";
}
elsif(($num eq "pl" &&  $per eq "2")&&(($gen eq "f")||( $gen eq "n")||($gen eq "m"))) {
        $gen="null";
}
elsif(($num eq "sg" )&&(($per eq "1")||($per eq "2"))) {
        $gen="null";
}
elsif(($num eq "sg" )&&($gen eq "m")) {
	$per="3";
}
elsif($gen eq "fn") {
	$num="sg";
	$per="3";
}


if(($tam=~/\+/)||($tam=~/^0\+/)) {
	$tam=~s/^0\+//g;
	$tam=~s/\+/_/g;
}
if(($tam eq "ti")||($kase eq "o")) {
	if(($tam eq "")||($tam eq "0")||($tam eq "\@")) {
		$tam="obl";
	}
}

##################
#print "Im tam==$tam\n";
if($tam=~/^:[0-9]*/) {
$tam=~s/^:[0-9]*/0/;
}
##############

if($tam=~/\@/) {
	$tam="0";
}
if($gen eq "") {
	$gen="null";
}
if($num eq "") {
	$num="null";
}
elsif($num eq "s") {
	$gen="sg";
}
if($per eq "") {
	$per="null";
}
#if((($num eq "any")&&($per eq "any"))&&($gen eq "null")){
#				$num="sg";
#				$per="1";
#			}
elsif($per eq "any") {
	$per = "3";
}


#if(($gen eq "null") && ($per eq "3")&& ($num eq "sg")){ # Blocked by chris - 29062013: too general
#	$gen="n";
#	$num="pl";
#}



if(($tam eq "a")&&($gen eq "null")&&($per!~/1|2/)) {
#		$tam="an";
	$gen="any";
	$num="any";
	$per="any";
}
if($tam eq "a_gala") {
	$tam="a_galugu_wA";
	$gen="null";
	$per="1";
	$num="pl";
}
$key=$lcat."___".$tam;
$temp=$verb_root{$key};

#print "iam here with $key|$temp\n";

if($temp eq "yes") {
	$gen="any";
	$per="any";
	$num="any";
}

#print "iam here with $gen|$num|$per\n";
#blocked on 021009 
#This pronomilization of adj is allowed before verbs but blocked before nouns

if(($lcat eq "adj")&&($tam ne "0")&&($gen ne "m" or $gen ne "n" or $gen ne "f" or $gen ne "fn")) {
#if($lcat eq "adj")
	$gen="null";
	$num="null";
	$per="null";
}

$key = $root."___".$lcat;
$pdgm = $root_hash{$key};

if(($lcat eq "n")&&($pdgm eq "")) {

if(($fsSt=~/location/)&&($root=~/a$/)){
$root=~s/([^S])a$/$1u/g;
		$pdgm="kalcar";
}
	elsif($root=~/[AIUeo]$/){
		$pdgm="rikRA";
	}
	elsif($root=~/a$/){
		$pdgm="kota";
	}
	elsif($root=~/i$/){
		$pdgm="gaxi";
	}
	elsif($root=~/M$|[aAiIuUeVE]mu$/){
		$root=~s/mu$/M/g;
		$pdgm="puswakaM";
	}
	elsif(($root=~/lu$/)&&($num eq "pl")){
		$pdgm="pAlu";
	}
	elsif($root=~/u$/){
		$pdgm="meku";
	}
	else{
		$pdgm="kalcar";
	}
	if($num eq "null") {
		$num="sg";	
	}
}
if(($lcat eq "adj")&&($pdgm eq "")){
	if($root=~/Ena$/){
		$pdgm="lewa";
	}
	#if(($tam eq "")&&($gen=~/f/)){
	#	$tam="xi";
	#}
}
if(($lcat eq "v")&&($pdgm eq "")){
	if($root=~/uMdu$/){
		$pdgm="uMdu";
	}
	elsif($root=~/po$/){
		$pdgm="po";
	}
	elsif($root=~/ceVyyi$/){
		$pdgm="ceVyyi";
	}
	elsif($root=~/padu$/){
		$pdgm="padu";
	}
	elsif($root=~/peVttu$|goVttu$/){
		$pdgm="peVttu";
	}
	elsif($root=~/manu$|koVnu$/){
		$pdgm="koVnu";
	}
	elsif($root=~/vaccu$/){
		$pdgm="vaccu";
	}
	elsif($root=~/ceVppu$/){
		$pdgm="ceVppu";
	}
	elsif($root=~/paruvu$/){
		$pdgm="aruvu";
	}
	#elsif($root=~/parucu$/){ $pdgm="kuxurcu"; }
	elsif($root=~/virugu$|pagulu|parucu$/){
		$pdgm="poVg?du";
	}
	elsif($root=~/iMcu$/){
		$pdgm="cUpiMcu";
	}
	elsif($root=~/lu$/){
		$pdgm="pAlu";
	}
	elsif($root=~/iyyi$/){
		$pdgm="wiyyi";
	}
	elsif($root=~/badu$/){
		$pdgm="padu";
	}
}

if(($lcat eq "v")&&($pdgm eq "veVlYlu")){
	$root=~s/lYlYu$/lYlu/g;
}


if(($tam eq "adaM")&&($lcat eq "v")){
	$gen = "any"; $per = "any"; $num = "any";
}

if(($lcat eq "pn")&&($gen eq "null")&&($num eq "any")){
$gen ="null";
$num="sg";
$per="null";
}

$key = $lcat."___".$tam."___".$gen."___".$num."___".$per;
$line_num = $feat_hash{$key};

#print "$key iam here wtih $line_num\n";

if(($lcat eq "v")&&($line_num eq "")&&($num eq "pl")&&($per eq "3")){
$key = $lcat."___".$tam."___null___sg___2";
$line_num = $feat_hash{$key};
}
elsif(($lcat eq "v")&&($line_num eq "")){
$key = $lcat."___".$tam."___fn___sg___3";
$line_num = $feat_hash{$key};
}

#print "iam here $root| $key pdgm is |$pdgm| and line_num is |$line_num| and |key=$key|\n";

$key = $pdgm."___".$line_num;


$add_del = $suff_hash{$key};
#print "iam here with $key|$add_del\n";

($add,$del) = split(/\_\_\_/,$add_del);
if(($pdgm eq "goyi")&&($del=~/^y/)){
if($root=~/Vyyi/){
$del="Vy".$del;
$del=~s/Vyyy/Vyy/g;
}
}
$root  =~s/$del$//g;
@adds = split(//,$add);
@adds = reverse(@adds);
$add = join('',@adds);


#print "iame here with $root $gen $num $per  and |$pdgm| |tam=$tam| and |line-no=$line_num| |add=$add|\n";
#print "iam here with del=$del add=$add\n";
if(($pdgm=~/axi|exi|ixi|wamaru/)&&($lcat eq "pn")&&($add eq "")&&($tam ne "0")){
	$key = $lcat."___".$tam."___".$gen."___".$num."___".$per;
	$line_num = $feat_hash2{$key};
	$key2 = $pdgm."___".$line_num;
	$add_del = $suff_hash{$key2};

	($add,$del) = split(/\_\_\_/,$add_del);
	$root  =~ s/$del$//g;
	@adds = split(//,$add);
	@adds = reverse(@adds);
	$add = join('',@adds);
}


		if(($pdgm=~/pAlu|maMxi/)&&(($lcat eq "n")||($lcat eq "pn"))&&(($tam ne "0"))) {
			$num="pl";
			$key = $lcat."___".$tam."___".$gen."___".$num."___".$per;
			$line_num = $feat_hash2{$key};
			$key2 = $pdgm."___".$line_num;
			$add_del = $suff_hash{$key2};
			($add,$del) = split(/\_\_\_/,$add_del);
			$root  =~ s/$del$//g;
			@adds = split(//,$add);
			@adds = reverse(@adds);
			$add = join('',@adds);
		}


if($tam eq "yoVkka"){
	$padd=$add;
	$add=~s/yoVkka$//g;
	if($add eq ""){
		$add=$padd;
	}
	$padd="";
}
#if($pdgm=~/pAlu|maMxi/){
#if(($num eq "pl")&&(($lcat eq "n") || ($lcat eq "pn"))&&($tam ne "0")) {
#	$key = $lcat."___".$tam."___".$gen."___".$num."___".$per;
#	$line_num = $feat_hash2{$key};
#	$key2 = $pdgm."___".$line_num;
#	$add_del = $suff_hash{$key2};
#	($add,$del) = split(/\_\_\_/,$add_del);
#	$root  =~ s/$del$//g;
#	@adds = split(//,$add);
#	@adds = reverse(@adds);
#	$add = join('',@adds);
#}
#}

#vowel Hormany of Telugu 


if((($lcat eq "n")||($lcat eq "v"))&&($pdgm =~/\?/)) {
#print "iam here with $root|$add|$del\n";

	if($adds[0] eq "A" or $adds[0] eq "e" or $adds[0] eq "i" or $adds[0] eq "I") {
		$adds[0]="i";
	}
	elsif($adds[0] eq "U" or $adds[0] eq "o") {
		$adds[0]="u";
	}
	$tma=$adds[0];

	if(($root=~/^[AaIiuUeEoO]/)&&($root!~/^$tma/)&&($adds[0]=~/[AaiIuUeE]/)){
		if($add=~/^$tma[^aAiIuUeEoOV]$tma/){
			$add=~s/^$tma([^aAiIuUeEoOV])$tma/$tma$1$tma/g;
		}
		else{
			$add=~s/^$tma([^aAiIuUeEoOV])/$tma$1/g;
		}
		$root=~s/$del/$tma/g;
	}
	elsif($adds[0]=~/[AaiIuUeE]/){
		@tt=split(/[AaiuUIeoE]/,$root);
		$pre=$tt[0].$adds[0];
		$pre2=$tt[0].$del;
#print "iam here with $root|$tma|$del|$add|$pre|$pre2 \n";
		$root=~s/$del/$adds[0]/g;
		#if($root=~/^$pre/){ # blocked to test caxava is becoming cuxava -091213-chris
		#	$root=~s/$pre/$pre2/g;
		#}
	}
}
if(($tam eq "gA")&&($add eq "")&&($root!~/gA$/)){
$add="gA";
}

if((($lcat eq "avy")&&($add ne ""))||(($lcat ne "v")&&($tam eq "AjFArWa")))
{
	$add="";
	$root=$root.$add;
}
elsif(($add eq "")&&($lcat ne "avy")) {
	if(($tam eq "obl")||($tam eq "0"))
	{
		$tam="";
		$add = $tam;
	}
	else  {
		($vwl,$junk2,$junk3) = split (/\_/,$tam);
		if($vwl eq "a")
		{
			$vwl="an";
		}

		$key1 = $root."___".$lcat;
		$pdgm1 = $root_hash{$key1};

#Checking for the Complex verb list

		$key2=$lcat."___".$vwl;
		$temp1=$verb_root{$key2};



		if(($vwl=~/^wU/)||($vwl=~/^an/)||($temp1 eq "yes"))
		{
			$gen1="any";
			$num1="any";
			$per1="any";
		}
		else {
			$gen1=$gen;
			$num1=$num;
			$per1=$per;
		}

		$key1=$lcat."___".$vwl."___".$gen1."___".$num1."___".$per1;
		$line_num1 = $feat_hash{$key1};

		$key1 = $pdgm."___".$line_num1;

		$add_del1 = $suff_hash{$key1};
		($add1,$del1) = split(/\_\_\_/,$add_del1);


		$root  =~ s/$del1$//g;

		@adds1 = split(//,$add1);
		@adds1 = reverse(@adds1);
		$add1 = join('',@adds1);

		if(($add1 ne "")&&($lcat eq "n" or $lcat eq "pn")) {
			if($junk3 ne "") {
				$root = $root.$add1."_".$junk2."_".$junk3; 
			}
			elsif($junk2 ne ""){
				$root = $root.$add1."_".$junk2; 
#print "iam here iwth $root\n";
			}
		}
		if($lcat eq "v" and $add1 ne "") {
			if($junk3 ne "") {
				$root = $root.$add1."_".$junk2."_".$junk3; 
			}
			elsif($junk2 ne ""){

				$root = $root.$add1.$junk2; 
#	$key3="n"."___".$junk2."___"."null"."___".$num."___"."null";


#	$line_num3 = $feat_hash{$key3};


#	$key3 = "kalcar"."___".$line_num3;
#if($line_num3 ne "") {
#	if($root=~/[AIUeo]$/){
#		$pdgm3="rikRA";
#				$key3 = $pdgm3."___".$line_num3;
#	}
#	elsif($root=~/a$/){
#		$pdgm3="kota";
#				$key3 = $pdgm3."___".$line_num3;
#	}
#	elsif($root=~/i$/){
#		$pdgm3="gaxi";
#				$key3 = $pdgm3."___".$line_num3;
#	}
#	elsif($root=~/u$/){
#		$pdgm3="meku";
#				$key3 = $pdgm3."___".$line_num3;
#	}
#	else{
#		$pdgm3="kalcar";
#				$key3 = $pdgm3."___".$line_num3;
##	}
##}


#				$add_del3 = $suff_hash{$key3};
#				($add3,$del3) = split(/\_\_\_/,$add_del3);


##$root  =~ s/$del1$//g;
#
#	@adds3 = split(//,$add3);
#	@adds3 = reverse(@adds3);
#	$add3 = join('',@adds3);

#	if($add3 ne "") {
#		$root = $root.$add1.$add3; 
#	}
			}
		}


		if($lcat ne "n" or $lcat ne "pn")
		{
			$key2 = $junk2."___".$lcat;
			$pdgm2 = $root_hash{$key2};
			$key2=$lcat."___".$junk3."___".$gen."___".$num."___".$per;
			$line_num2 = $feat_hash{$key2};

			$key1 = $pdgm2."___".$line_num2;
			$add_del1 = $suff_hash{$key1};
			($add1,$del1) = split(/\_\_\_/,$add_del1);
			$junk2  =~ s/$del1$//g;
			@adds1 = split(//,$add1);
			@adds1 = reverse(@adds1);
			$add1 = join('',@adds1);
			$root2 = $junk2.$add1; 
			$root3 = $root2; 
		}
	}
	if(($lcat eq "adj")&&($add eq "")) {
		$root=$root.$tam;
	}


	if(($lcat eq "n")&&($tam ne "" and $tam ne "0")&&($add eq "")&&($root!~/_/)){
		$key4=$lcat."___obl"."___".$gen."___".$num."___".$per;
		$line_num4 = $feat_hash{$key4};
		$key4 = $pdgm."___".$line_num4;
		$add_del2 = $suff_hash{$key4};
		($add2,$del2) = split(/\_\_\_/,$add_del2);
		$root  =~ s/$del2$//g;
		@adds2 = split(//,$add2);
		@adds2 = reverse(@adds2);
		$add2 = join('',@adds2);

		$tam=~s/_/ /g;

		$root=$root.$add2." ".$tam;
	}
	if(($lcat eq "unk")&&($add eq "")&&($tam ne "")) {
		$root=$root."_".$tam;
	}

	if(($lcat eq "punc")||($gen eq "punc")) {


if($root eq "&exm;"){ $root="!";}
if($root eq "&dot;"){ $root=".";}
if($root eq "&comma;"){ $root=","; }
if($root eq "&lang;"){ $root="<"; }
if($root eq "&rang;"){ $root=">";}
if($root eq "&frasl;"){ $root="/";}
if($root eq "&qus;"){ $root="?";}
if($root eq "&scol;"){ $root=";";}
if($root eq "&col;"){ $root=":";}
if($root eq "&bdquo;"){ $root="\"";}
if($root eq "&apos;"){ $root="'";}
if($root eq "&lsbrs;"){ $root="[";}
if($root eq "&rsbrs;"){ $root="]";}
if($root eq "&lfbrs;"){ $root="{";}
if($root eq "&rfbrs;"){ $root="}";}
if($root eq "&pipe;"){ $root="|";}
if($root eq "&equl;"){ $root="=";}
if($root eq "&add;"){ $root="+";}
if($root eq "&minus;"){ $root="-";}
if($root eq "&unds;"){ $root="_";}
if($root eq "&rcbrs;"){ $root="(";}
if($root eq "&lcbrs;"){ $root=")";}
if($root eq "&lowast;"){ $root="*";}
if($root eq "&amp;"){ $root="&";}
if($root eq "&circ;"){ $root="^";}
if($root eq "&perc;"){ $root="%";}
if($root eq "&dol;"){ $root="\$";}
if($root eq "&hash;"){ $root="#";}
if($root eq "&atrat;"){ $root="\@";}
if($root eq "&tilde;"){ $root="~";}
if($root eq "&acute;"){ $root="`";}
if($root eq "&lsquo;"){ $root="‘";}
if($root eq "&rsquo;"){ $root="’";}
if($root eq "&sbquo;"){ $root="‚";}
if($root eq "&ldquo;"){ $root="\“";}
if($root eq "&rdquo;"){ $root="\”";}
if($root eq "&hellep;"){ $root="...";}
	
	}
	if($gen eq "num") {
		$root=$tkn;
	}
	if(($lcat eq "num")&&($tam ne "")&&($tam ne "yoVkka")) {
		$root=$root.$tam;
	}

}

else { $root = $root.$add; }
#vowel deletion before and after a vowel(chris-14_july_09 )
if($root=~/__/) {
	$root=~s/__/_/g;
}
elsif(($root=~/-|_/)&&($lcat ne "punc")){
$root=~s/-|_//g;
}
if($root=~/e[aiu]|[aiu]e/) {
	$root=~s/[aiu]e|e[aiu]/e/g;
}
elsif($root=~/o[aiu]|[aiu]o/) {
	$root=~s/[aiu]o|o[aiu]/o/g;
}
$root=~s/M yoVkka$/pu/s;
&modify_field($node,2,$root);
$root1="";
$root2="";
$root="";
$junk1="";
$junk2="";
$junk3="";
$suff3="";
$suff1="";
$vwl="";
$vwl1="";
$vwl2="";
$add="";
$add1="";
$adds1="";
$tam="";
}
}

&tel_gen();
if($output eq "")
{
	&print_tree();
}
else
{
	&print_tree_file($output);
}
