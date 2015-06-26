perl $setu/bin/sys/common/deletesentencetag.pl $1 > wordgeninput
perl $setu/bin/tl/wordgenerator/tel/tel_gen.pl --path=$setu/bin/tl/wordgenerator/tel --i wordgeninput > wordgenout
perl $setu/bin/tl/wordgenerator/tel/word_smt/word_smt.pl --path=$setu/bin/tl/wordgenerator/tel/word_smt --i wordgenout
