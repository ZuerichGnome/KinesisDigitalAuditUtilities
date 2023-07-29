# -------------------------------------------------------------
#
#!/bin/bash
#
# build-dot-file-for-3-vertex-5-arc-digraph.sh
# 
# . ./build-dot-file-for-3-vertex-5-arc-digraph.sh outputfile-2023-07-29-T17:20:17-UTC-CiC-H2U-blue
#
# cat outputfile-2023-07-29-T17:16:49-UTC-CiC-H2U-blue | sed 's/^/# /g'
#
# E2U ORANGE
# 7325289.22
# H2U ORANGE
# 987088.51 
# E2U BLUE
# 1270938.08
# H2E BLUE
# 5221555.92
# H2U BLUE
# 431291.57 

#
# -------------------------------------------------------------

printf "Parameters\n" 
printf "%s\n" $0 
printf "%s\n" $1 

if [ ! -f $1 ];
then
	echo "File $1 does not exist"
else
	inputfile=$1
    outputfile=Graphviz-3-vertex-5-arc-digraph-`date -u +"%Y-%m-%d-T%T-%Z"`.dot
	if [ -f $outputfile ]; then rm -f $outputfile; fi; touch $outputfile;
fi

#
printf "digraph {\n" >> $outputfile 

#
# merge records 2 lines at a time
#
cat $1 | awk 'NR%2 {printf("%s\t", $0); next} {print $0} ' > t
#
# sample output:
#
# cat outputfile-2023-07-29-T17:18:54-UTC-CiC-H2U-blue | awk 'NR%2 {printf("%s\t", $0); next} {print $0} ' > t
# linux> sed 's/^/# /g' t
#
# E2U ORANGE	7325289.22
# H2U ORANGE	987088.51 
# E2U BLUE	1270938.08
# H2E BLUE	5221555.92
# H2U BLUE	431291.57 
#
# extract the numbers
#
# wrangle them to fit dot file format
# https://graphviz.org/docs/outputs/canon/
#
#
cat t | cut -f2 > t2
cat t | cut -f1 | sed 's/./->/2' | sed 's/./ [label = /5' | sed 's/ORANGE/ color = "orange"]/g' | sed 's/BLUE/ color = "blue"]/g' | cut -c1-13 > t1
cat t | cut -f1 | sed 's/./->/2' | sed 's/./ [label = /5' | sed 's/ORANGE/ color = "orange"]/g' | sed 's/BLUE/ color = "blue"]/g' | cut -c15- > t3
paste t[1-3] >> $outputfile
#
# clean-up
#
rm -f t[1-3] t

printf "}\n" >> $outputfile 

dot -Tpng $outputfile -o "${outputfile%.dot}".png

echo $outputfile
echo "${outputfile%.dot}".png
# 
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
