# -------------------------------------------------------------
#
#!/bin/bash
#
# $0 = build-BIPARTITE-DIGRAPH4Record-TYPE0-11-8-10.sh
# $1 = CSV input file from Watcher Node
# $2 = list of Vertices Set A
# $3 = list of Vertices Set B
# $4 = decode file: (symbol = Stellar address)
#
# Hardcoded for records of Type
# 	create_record 0
#
# chmod 755 
#
# Usage:
#
# Set-A and Set-B full 56 long address
#
# DecodeTable:
# shortened to 8 for dot graph = full 56 address
#
# grep 'KAG_EmissionAccount\|KAG_HotWalletAccount' KAG-set-main-account-symbols.sh | cut -d= -f2 > Set-A
# head -25 MinterAccounts | cut -d" " -f1 > Set-B
#
#
# grep 'KAG_EmissionAccount\|KAG_HotWalletAccount' KAG-set-main-account-symbols.sh | cut -d= -f2 | cut -c1-8 > t
# grep 'KAG_EmissionAccount\|KAG_HotWalletAccount' KAG-set-main-account-symbols.sh | cut -d= -f2 > tt
# paste -d= t tt > DecodeTable
#
# head -25 MinterAccounts | cut -d" " -f1 | cut -c1-8 > u
# head -25 MinterAccounts | cut -d" " -f1 > uu
# paste -d= u uu >> DecodeTable
#
# KAG_outputfile=KAG_outputfile-`date -u +"-%Y-%m-%d-T%T-%Z"`
# touch $KAG_outputfile 
#
# ./build-BIPARTITE-DIGRAPH4Record-TYPE0-11-8-10.sh $KAG_extract Set-A Set-B DecodeTable >> $KAG_outputfile 
#
# -------------------------------------------------------------
printf "Header block of 1+1+4+1 = 7 lines\n" 
printf "%s\n" $0 
printf "%s\n" $1 
printf "%s\n" $2 
printf "%s\n" $3 
printf "%s\n" $4

printf "BIPARTITE DIGRAPH TYPE0\n"
for i in `cat $2`
do
  for j in `cat $3`
  do
    grep $i $4 | cut -d= -f1
    grep $j $4 | cut -d= -f1
    sed '1d' $1 | sed 's/"//g' | awk -F, -v x="$i" -v y="$j" '($5=="0") && ($11==x) && ($8==y) {sum += $10} END {printf "%-10.0f\n", sum}'
  done
done 
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
