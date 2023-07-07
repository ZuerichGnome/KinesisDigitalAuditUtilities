# -------------------------------------------------------------
#
#!/bin/bash
#
# KAU-check-coin-in-circulation.sh
#
# Compare with
#
# https://explorer.kinesis.money/
#
# "Total Coin in Circulation (Minting minus Redemption)"
#
# chmod +x KAU-check-coin-in-circulation.sh
# or
# chmod 755 KAU-check-coin-in-circulation.sh
#
# Source of input file:
#
# https://watcher.aboutkinesis.com/operations
# 
# "set custom network" (mouse-click upper right) and SAVE:
# 
# https://KAU.aboutkinesis.com
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


mv ../dat/stellar-export.csv ../dat/kau-stellar-export-using-Operations-TAB-`date -u +"%Y-%m-%d-T%H:%I:%S-%Z"`.csv

KAU_extract=../dat/kau-stellar-export-using-Operations-TAB-2023-07-05-T12\:12\:21-UTC.csv 

. ./KAU-set-main-account-symbols.sh 

set | grep ^KAU | sort -t= -k2


x1=`sed '1d' $KAU_extract | sed 's/\"//g' | awk -F, -v e=$KAU_EmissionAccount '($4=="create_account") && ($11==e) {sum_10 += $10} END {printf "%-10.2f\n", sum_10}'`
x2=`sed '1d' $KAU_extract | sed 's/\"//g' | awk -F, -v e=$KAU_EmissionAccount '($4=="payment") && ($13==e) {sum_15 += $15} END {printf "%-10.2f\n", sum_15}'`
x3=`sed '1d' $KAU_extract | sed 's/\"//g' | awk -F, -v h=$KAU_HotWalletAccount -v e=$KAU_EmissionAccount '( ($4=="payment") && (($13==h) && ($14==e)) ) {sum_15 += $15} END {printf "%-10.2f\n", sum_15 }'`

echo $x1
echo $x2
echo "$x1 + $x2" | bc -l | xargs printf "%-10.2f\n"
echo $x3
echo "$x1 + $x2 - $x3" | bc -l | xargs printf "%-10.2f\n"

date -u

#
# as of 
# Mi 05 Jul 2023 12:58:23 UTC
#
# 47158676.30
# 3140466.21
# 50299142.51
# 49051484.01
# 1247658.50
#
# Last 3 numbers from results generated above match Explorer numbers
#
# EOF
#
#
