perl /var/www/html/sampark/system/hin_tel/sampark//bin/sys/common/deletesentencetag.pl $1 > wordgeninput
perl /var/www/html/sampark/system/hin_tel/sampark//bin/tl/wordgenerator/tel/tel_gen.pl --path=/var/www/html/sampark/system/hin_tel/sampark//bin/tl/wordgenerator/tel --i wordgeninput > wordgenout
perl /var/www/html/sampark/system/hin_tel/sampark//bin/tl/wordgenerator/tel/word_smt/word_smt.pl --path=/var/www/html/sampark/system/hin_tel/sampark//bin/tl/wordgenerator/tel/word_smt --i wordgenout
