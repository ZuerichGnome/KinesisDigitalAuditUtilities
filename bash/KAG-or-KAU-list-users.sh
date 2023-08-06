# -------------------------------------------------------------
#
#!/bin/bash
#
# . ./KAG-or-KAU-list-users.sh KAG watcher-extract-file 999999 TYPE0-11-8-10 TYPE1-13-14-15
#
# linux> chmod 755 KAG-or-KAU-list-users.sh 
#
# From the experience of the last few months, we have discovered that only 2 vertices actually write to user accounts.
#
# These are:
#
# E
# H
#
# This may be incorrect but it's to the best of our knowledge gleaned so far.
#
# We could coyly call this: we found this 'by inspection'
#
# So 06 Aug 2023 18:17:21 UTC
#
# As per today, we find traffic to U partly by exclusion
# H also writes to F and to G
# so we have to exclude those
#
# The crux is we don't know the size, nor the content of Set U a priori. We have to do some work to find that out.
#
# |U| is unknown
# | | is standard maths set operator to indicate size.
#
# We're going to find |U| out with the use of this script.
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

# One day, I may figure out how to do user input validation properly. until then:
#
# https://quickref.me/bash
#
if [ ! -f $2 ]; then
	echo "File $2 does not exist"
#	exit
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
outputfile=outputfile-`date -u +"%Y-%m-%d-T%T-%Z"`-USERS-$1-ONCHAIN
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
	printf "E2U ORANGE USERS\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" '($5=="0") && ($11==e) {printf "%s\n", $8}' >> $outputfile
	#
	# user transfers to a wallet. first time
	# exclude traffic to F and to G (the latter may not even exist but let's be safe)
	#
	printf "H2U ORANGE USERS\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" -v f="$F" -v g="$G" -v h="$H" '($5=="0") && (($11==h) && !(($8==f) || ($8==g))) {printf "%s\n", $8}' >> $outputfile
    ;;
    *)
esac

#
# Work
#
# alphabetically:
#
# E2U
# H2U
#
case "$5" in
    TYPE1-13-14-15)
	#
	# user mintings to a wallet
	#
	printf "E2U BLUE USERS\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" '($5=="1") && ($13==e) {printf "%s\n", $14}' >> $outputfile
	#
	# the new kid on the block
	# user transfers to a wallet. second time (after creation) and more
	#
	printf "H2U BLUE USERS\n" >> $outputfile
	sed '1d' $CSV_extractfile | sed 's/\"//g' | sort -t, -k6 | sed -n "1,${3}p" | awk -F, -v e="$E" -v f="$F" -v g="$G" -v h="$H" '($5=="1") && ($13==h) && !(($14==e) || ($14==f) || ($14==g)) {printf "%s\n", $14}' >> $outputfile
    ;;
    *)
esac

echo $outputfile

echo "1) Exclude string BLUE or ORANGE users"
echo "2) Then do a unique sort"

date -u
#
#
# EOF
#
#
