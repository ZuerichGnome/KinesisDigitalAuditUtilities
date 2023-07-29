# -------------------------------------------------------------
#
#!/bin/bash
#
#
# . ./KAG-or-KAU-calculate-coin-in-circulation-and-H2U-blue-flow.sh KAG watcher-extract-file 999999 TYPE0-11-8-10 TYPE1-13-14-15
#
# -------------------------------------------------------------
if [ ! "$#" -eq  "5" ]
then
    echo "Usage: $0 {KAG|KAU} watcher-extract-file LineNumberToSnipUpTo {TYPE0-11-8-10|TYPE0-13-14-12|TYPE0-15-12-14} {TYPE1-9-10-11|TYPE1-13-14-15}"
fi

printf "Parameters\n" 
printf "%s\n" $0 
printf "%s\n" $1 
printf "%s\n" $2
printf "%s\n" $3
printf "%s\n" $4
printf "%s\n" $5

# https://quickref.me/bash
#
if [ ! -f $2 ]; then
	echo "File $2 does not exist"
	exit
else
	CSV_extractfile=$2
fi

#
#
# Fetch relevant vertex addresses (full Stellar 56) to pass them down explicitly to awk
#
#
E=`grep $1_EmissionAccount $1-set-main-account-symbols.sh | cut -d= -f2`
F=`grep FeePoolAccount $1-set-main-account-symbols.sh | cut -d= -f2`
G=`grep $1_GAPSAccount $1-set-main-account-symbols.sh | cut -d= -f2`
H=`grep $1_HotWalletAccount $1-set-main-account-symbols.sh | cut -d= -f2`

#
# Where we write results out
#
outputfile=outputfile-`date -u +"%Y-%m-%d-T%T-%Z"`-CiC-H2U-blue
touch $outputfile 

#
# Work
#
# alphabetically:
#
# E2U
# H2U
#
case "$4" in
	TYPE0-11-8-10)
	#
	# user mintings
	#
	printf "E2U ORANGE\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" '($5=="0") && ($11==e) {sum_10 += $10} END {printf "%-10.2f\n", sum_10}' >> $outputfile
	#
	# user transfers to a wallet. first time
	#
	printf "H2U ORANGE\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" -v f="$F" -v h="$H" '($5	=="0") && ( ($11==h) && !($8==f) ) {sum_10 += $10} END {printf "%-10.2f\n", sum_10}' >> $outputfile
    ;;
    *)
esac

#
# Work
#
# alphabetically:
#
# E2U
# H2E
# H2U
#
case "$5" in
    TYPE1-13-14-15)
	#
	# user mintings to a wallet
	#
	printf "E2U BLUE\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" '($5=="1") && ($13==e) {sum_15 += $15} END {printf "%-10.2f\n", sum_15}' >> $outputfile
	#
	# aka Redemptions
	#
	printf "H2E BLUE\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" -v h="$H" '( ($5=="1") && (($13==h) && ($14==e)) ) {sum_15 += $15} END {printf "%-10.2f\n", sum_15 }' >> $outputfile
	#
	# the new kid on the block
	# user transfers to a wallet. second time (after creation) and more
	#
	printf "H2U BLUE\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" -v f="$F" -v g="$G" -v h="$H" '($5=="1") && ($13==h) && !( ($14==e) || ($14==f) || ($14==g) ) {sum_15 += $15} END {printf "%-10.2f\n", sum_15}' >> $outputfile
    ;;
    *)
esac

minting=`cat $outputfile | grep -A 1 E2U | grep '^[0-9]' | paste -d+ -s | bc -l`
redemption=`cat $outputfile | grep -A 1 H2E | grep '^[0-9]'`
echo "$minting - $redemption " | bc -l | xargs printf "$1 COIN IN CIRCULATION up to line $3:\n%-10.2f\n"

echo $outputfile
date -u
#
#
# EOF
#
#
