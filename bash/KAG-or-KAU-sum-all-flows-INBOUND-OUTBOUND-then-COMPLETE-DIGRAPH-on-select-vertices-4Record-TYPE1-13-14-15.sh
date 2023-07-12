# -------------------------------------------------------------
#
#!/bin/bash
#
# $0 = KAG-or-KAU-sum-all-flows-INBOUND-OUTBOUND-then-COMPLETE-DIGRAPH-on-select-vertices-4RecordType1.sh
# $1 = CSV input file from Watcher Node
# $2 = list of Vertices file
# $3 = decode file: (symbol = Stellar address)
#
# Hardcoded:
# 	payment 1
#
# chmod 755 KAG-or-KAU-sum-all-flows-INBOUND-OUTBOUND-then-COMPLETE-DIGRAPH-on-select-vertices-4RecordType1.sh
#
# Usage:
#
# cut -d= -f2 KAG-set-main-account-symbols.sh > Vertices
# or
# cut -d= -f2 KAG-set-main-account-symbols.sh > Vertices
#
# KAG_outputfile=KAG_outputfile-`date -u +"%Y-%m-%d-T%H:%I:%S-%Z"`
# touch $KAG_outputfile 
#
# ./KAG-or-KAU-sum-all-flows-INBOUND-OUTBOUND-then-COMPLETE-DIGRAPH-on-select-vertices-4RecordType1.sh $KAG_extract Vertices KAG-set-main-account-symbols.sh >> $KAG_outputfile 
#
# -------------------------------------------------------------
printf "Parameters\n" 
printf "%s\n" $0 
printf "%s\n" $1 
printf "%s\n" $2 
printf "%s\n" $3 

printf "INBOUND\n" 
for j in `cat $2`
do
  grep $j $3 | cut -d= -f1 
  sed '1d' $1 | sed 's/"//g' | awk -F, -v y="$j" '($5=="1") && ($14==y) {sum += $15} END {printf "%-10.0f\n", sum}'
done

printf "OUTBOUND\n" 
for i in `cat $2`
do
  grep $i $3 | cut -d= -f1 
  sed '1d' $1 | sed 's/"//g' | awk -F, -v x="$i" '($5=="1") && ($13==x) {sum += $15} END {printf "%-10.0f\n", sum}'
done

printf "COMPLETE DIGRAPH\n"
for i in `cat $2`
do
  for j in `cat $2`
  do
    grep $i $3 | cut -d= -f1
    grep $j $3 | cut -d= -f1
    sed '1d' $1 | sed 's/"//g' | awk -F, -v x="$i" -v y="$j" '($5=="1") && ($13==x) && ($14==y) {sum += $15} END {printf "%-10.0f\n", sum}'
  done
done 
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------a
