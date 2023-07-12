# -------------------------------------------------------------
#
#!/bin/bash
#
# KAG-or-KAU-digraph-build-dot-file.sh
#
# Usage:
#
# There are variable input formats
# One should of course only be grateful to have flat-file data at all
#
# To read the Watcher files in the correct format, think like this:
#
#       i  j  x(i,j)
#
# TYPE0-11-8-10
# TYPE0-13-14-12
# TYPE0-15-12-14
#
# TYPE1-9-10-11
# TYPE1-13-14-15
#
# ./KAG-or-KAU-digraph-build-dot-file.sh $KAG_extract KAG TYPE0-11-8-10 TYPE1-13-14-15
# or
# ./KAG-or-KAU-digraph-build-dot-file.sh $KAU_extract KAU TYPE0-11-8-10 TYPE1-13-14-15
#
# A word of caution
# dollar variables for bash are not the same as dollar variables for awk
#
# Requires 2 packages.
# How to install under linux ubuntu:
#
# sudo apt install graphviz
# sudo apt install xdot
#
# -------------------------------------------------------------

printf "Parameters\n" 
printf "%s\n" $0 
printf "%s\n" $1 
printf "%s\n" $2
printf "%s\n" $3
printf "%s\n" $4

#
#
# set up environment
# no need to actually set the specific KAG or KAU symbols used previously
#
#

#
#
# https://quickref.me/bash
#
#
case "$2" in
    KAG)

	cat KAG-set-main-account-symbols.sh | sort -t= -k2 | cut -d= -f2 > Vertices

	cat KAG-set-main-account-symbols.sh | sed -n '1,5p' | cut -c5 > t
	echo F >> t
	cat KAG-set-main-account-symbols.sh | cut -d= -f2 > u
	paste -d= t u | sort > decode-table 
    ;;
    KAU)

	cat KAU-set-main-account-symbols.sh | sort -t= -k2 | cut -d= -f2 > Vertices

	cat KAU-set-main-account-symbols.sh | sed -n '1,5p' | cut -c5 > t
	echo F >> t
	cat KAU-set-main-account-symbols.sh | cut -d= -f2 > u
	paste -d= t u | sort > decode-table 
    ;;
    *)
    echo "Usage: $0 watcher-extract-file {KAG|KAU} {TYPE0-11-8-10|TYPE0-13-14-12|TYPE0-15-12-14}"
    ;;
esac

#
# For clarity
#
CSV_inputfile=$1

#
#
#
# Type 0
#
#
#
outputfile=outputfile-`date -u +"%Y-%m-%d-T%T-%Z"`-TYPE0
touch $outputfile 

case "$3" in
    TYPE0-11-8-10)
	./KAG-or-KAU-sum-all-flows-INBOUND-OUTBOUND-then-COMPLETE-DIGRAPH-on-select-vertices-4Record-TYPE0-11-8-10.sh $CSV_inputfile Vertices decode-table >> $outputfile 
    ;;
    TYPE0-13-14-12)
	./KAG-or-KAU-sum-all-flows-INBOUND-OUTBOUND-then-COMPLETE-DIGRAPH-on-select-vertices-4Record-TYPE0-13-14-12.sh $CSV_inputfile Vertices decode-table >> $outputfile 
    ;;
    TYPE0-15-12-14)
	./KAG-or-KAU-sum-all-flows-INBOUND-OUTBOUND-then-COMPLETE-DIGRAPH-on-select-vertices-4Record-TYPE0-15-12-14.sh $CSV_inputfile Vertices decode-table >> $outputfile 
    ;;
    *)
    echo "Usage: $0 watcher-extract-file {KAG|KAU} {TYPE0-11-8-10|TYPE0-13-14-12|TYPE0-15-12-14} {TYPE1-9-10-11|TYPE1-13-14-15}"
    ;;
esac

#
#
# Create dotfile
# Build dotfile header
#
#
Graphviz_flatfile=Graphviz-`date -u +"%Y-%m-%d-T%T-%Z"`.dot
touch $Graphviz_flatfile

#
# Target format:
#

#
# https://graphviz.org/docs/attrs/dir/
#
# digraph {
#   A->B [dir=forward] [label = 5656]
#   C->D [dir=back]
#   E->F [dir=both]
#   G->H [dir=none]
# }
printf "digraph {\n" >> $Graphviz_flatfile

# 
# 
# Flows to U (users) are not measured in the nested loops over the system accounts
# 
# We deduce them from outbound flow (totals) from the relevant vertex. 
#
# Relevant vertices:
#
# H
# E
#
# "f_" for flow
#

#
#
# Special case #1
# 1 subtraction required
#
#
f_H_outbound=`cat $outputfile | sed '1,5d' | sed -n '/OUTBOUND/,/COMPLETE DIGRAPH/p' | sed '$d' | sed '1d' | grep -A 1 "^H" | sed '1d'`
f_H_F=`cat $outputfile | sed '1,5d' | sed -n '/COMPLETE DIGRAPH/,99999p' | sed '1d' | awk 'NR%3 {printf("%s ", $0); next} {print $0}' | grep -v -w \0 | grep "^H F" | cut -d" " -f3`
bc <<< "$f_H_outbound - $f_H_F" | xargs printf "H->U [label = %10.0f color=\"orange\"]\n" >> $Graphviz_flatfile

#
# Special case #2
#
f_E_outbound=`cat $outputfile | sed '1,5d' | sed -n '/OUTBOUND/,/COMPLETE DIGRAPH/p' | sed '$d' | sed '1d' | grep -A 1 "^E" | sed '1d'`
printf "E->U [label = %10.0f color=\"orange\"]\n" $f_E_outbound >> $Graphviz_flatfile

#
# The flows between system accounts
#
cat $outputfile | sed '1,5d' | sed -n '/COMPLETE DIGRAPH/,99999p' | sed '1d' | awk 'NR%3 {printf("%s ", $0); next} {print $0}' | grep -v -w \0 | awk -F" " '{printf "%s->%s [label = %10.0f color=\"orange\"]\n", $1, $2, $3}' >> $Graphviz_flatfile

#
#
#
# Type 1
#
#
#
outputfile=outputfile-`date -u +"%Y-%m-%d-T%T-%Z"`-TYPE1
touch $outputfile 

case "$4" in
    TYPE1-9-10-11)
	./KAG-or-KAU-sum-all-flows-INBOUND-OUTBOUND-then-COMPLETE-DIGRAPH-on-select-vertices-4Record-TYPE1-9-10-11.sh $CSV_inputfile Vertices decode-table >> $outputfile 
    ;;
    TYPE1-13-14-15)
	./KAG-or-KAU-sum-all-flows-INBOUND-OUTBOUND-then-COMPLETE-DIGRAPH-on-select-vertices-4Record-TYPE1-13-14-15.sh $CSV_inputfile Vertices decode-table >> $outputfile 
    ;;
    *)
    echo "Usage: $0 watcher-extract-file {KAG|KAU} {TYPE0-11-8-10|TYPE0-13-14-12|TYPE0-15-12-14} {TYPE1-9-10-11|TYPE1-13-14-15}"
    ;;
esac

#
# Fish out flows out of E
# E outbound
#
f_E_outbound=`cat $outputfile | sed '1,5d' | sed -n '/OUTBOUND/,/COMPLETE DIGRAPH/p' | sed '$d' | sed '1d' | grep -A 1 "^E" | sed '1d'`
printf "E->U [label = %10.0f color=\"blue\"]\n" $f_E_outbound >> $Graphviz_flatfile


#
# The flows between system accounts
#
cat $outputfile | sed '1,5d' | sed -n '/COMPLETE DIGRAPH/,99999p' | sed '1d' | awk 'NR%3 {printf("%s ", $0); next} {print $0}' | grep -v -w \0 | awk -F" " '{printf "%s->%s [label = %10.0f color=\"blue\"]\n", $1, $2, $3}' >> $Graphviz_flatfile


#
# close off the dotfile
#
printf "}\n" >> $Graphviz_flatfile

# 
# https://stackoverflow.com/questions/2664740/extract-file-basename-without-path-and-extension-in-bash
#
circo -Tpng $Graphviz_flatfile -o "${Graphviz_flatfile%.dot}"_circo.png
dot -Tpng $Graphviz_flatfile -o "${Graphviz_flatfile%.dot}".png

echo "${Graphviz_flatfile%.dot}"_circo.png
echo "${Graphviz_flatfile%.dot}".png

echo $Graphviz_flatfile

#
# another way to look
# good for on-the-fly check
# xdot
#
# $Graphviz_flatfile 
# xdot -f dot $Graphviz_flatfile 
#

# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
