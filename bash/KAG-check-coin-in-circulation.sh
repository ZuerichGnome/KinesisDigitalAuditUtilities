# -------------------------------------------------------------
#
#!/bin/bash
#
# KAG-check-coin-in-circulation.sh
#
# Compare with
#
# https://explorer.kinesis.money/
#
# "Total Coin in Circulation (Minting minus Redemption)"
#
# chmod +x KAG-check-coin-in-circulation.sh
# or
# chmod 755 KAG-check-coin-in-circulation.sh
#
# Source of input file:
#
# https://watcher.aboutkinesis.com/operations
# 
# "set custom network" (mouse-click upper right) and SAVE:
# 
# https://kag.aboutkinesis.com
# 
# <PAGEDOWN>
# mouse-click:
# 
# "Export data as CSV"
# 
# Extracts to csv file
#
# "stellar-export.csv"
#
# -------------------------------------------------------------

mv ../dat/stellar-export.csv ../dat/kag-stellar-export-using-Operations-TAB-`date -u +"%Y-%m-%dT%T-%Z"`.csv

KAG_extract=../dat/kag-stellar-export-using-Operations-TAB-2023-07-05-T12\:12\:12-UTC.csv 

. ./KAG-set-main-account-symbols.sh 

set | grep ^KAG | sort -t= -k2

x1=`sed '1d' $KAG_extract | sed 's/\"//g' | awk -F, -v e=$KAG_EmissionAccount '($4=="create_account") && ($11==e) {sum_10 += $10} END {printf "%-10.2f\n", sum_10}'`
x2=`sed '1d' $KAG_extract | sed 's/\"//g' | awk -F, -v e=$KAG_EmissionAccount '($4=="payment") && ($13==e) {sum_15 += $15} END {printf "%-10.2f\n", sum_15}'`
x3=`sed '1d' $KAG_extract | sed 's/\"//g' | awk -F, -v x=$KAG_HotWalletAccount -v y=$KAG_EmissionAccount '( ($4=="payment") && (($13==x) && ($14==y)) ) {sum_15 += $15} END {printf "%-10.2f\n", sum_15 }'`

echo $x1
echo $x2
echo "$x1 + $x2" | bc -l | xargs printf "%-10.2f\n"
echo $x3
echo "$x1 + $x2 - $x3" | bc -l | xargs printf "%-10.2f\n"

date -u

#
# as of 
# Mi 05 Jul 2023 12:38:54 UTC
#
# 8544263.10
# 5207555.92
# 3336707.18
#
# match Explorer numbers
#
#
# EOF
#
#
