# -------------------------------------------------------------
#
#!/bin/bash
#
# build-dot-file-4-bipartite-digraph.sh
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
# ./build-dot-file-4-bipartite-digraph.sh $KAG_extract TYPE0-11-8-10 TYPE1-13-14-15 VertexSetA VertexSetB DecodeTable
#
# -------------------------------------------------------------

printf "Parameters\n" 
printf "%s\n" $0 
printf "%s\n" $1 
printf "%s\n" $2
printf "%s\n" $3
printf "%s\n" $4
printf "%s\n" $5
printf "%s\n" $6

#
#
#
if [ ! "$#" -eq  "6" ]
then
    echo "Usage: $0 watcher-extract-file {TYPE0-11-8-10|TYPE0-13-14-12|TYPE0-15-12-14} {VertexSetA} {VertexSetB} {DecodeTable}"
    exit 1
fi


#
# For clarity
#
CSV_inputfile=$1

#
# Type 0
#
outputfile=outputfile-`date -u +"%Y-%m-%d-T%T-%Z"`-TYPE0
touch $outputfile 

case "$2" in
    TYPE0-11-8-10)
	./build-BIPARTITE-DIGRAPH4Record-TYPE0-11-8-10.sh $CSV_inputfile $4 $5 $6 >> $outputfile 
    ;;
    TYPE0-13-14-12)
    ;;
    TYPE0-15-12-14)
    ;;
    *)
    echo "Usage: $0 watcher-extract-file {TYPE0-11-8-10|TYPE0-13-14-12|TYPE0-15-12-14} {TYPE1-9-10-11|TYPE1-13-14-15} {VertexSetA} {VertexSetB} {DecodeTable}"
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
# https://graphviz.org/docs/attrs/dir/
#
# https://graphviz.org/docs/attrs/rankdir/
#
# "LR" = left to right: the natural way of thinking about a bipartite digraph
#

printf "digraph {\n" >> $Graphviz_flatfile
printf "rankdir=\"LR\"\n" >> $Graphviz_flatfile

cat $outputfile | sed '1,7d' | awk 'NR%3 {printf("%s ", $0); next} {print $0}' | grep -v -w \0 | awk -F" " '{printf "%s->%s [label = %10.0f color=\"orange\"]\n", $1, $2, $3}' >> $Graphviz_flatfile


#
# Type 1
#
outputfile=outputfile-`date -u +"%Y-%m-%d-T%T-%Z"`-TYPE1
touch $outputfile 

case "$3" in
    TYPE1-9-10-11)
    ;;
    TYPE1-13-14-15)
	./build-BIPARTITE-DIGRAPH4Record-TYPE1-13-14-15.sh $CSV_inputfile $4 $5 $6 >> $outputfile 
    ;;
    *)
    echo "Usage: $0 watcher-extract-file {TYPE0-11-8-10|TYPE0-13-14-12|TYPE0-15-12-14} {TYPE1-9-10-11|TYPE1-13-14-15} {VertexSetA} {VertexSetB} {DecodeTable}"
    ;;
esac

#
cat $outputfile | sed '1,7d' | awk 'NR%3 {printf("%s ", $0); next} {print $0}' | grep -v -w \0 | awk -F" " '{printf "%s->%s [label = %10.0f color=\"blue\"]\n", $1, $2, $3}' >> $Graphviz_flatfile


#
# close the dotfile
#
printf "}\n" >> $Graphviz_flatfile

# 
# https://stackoverflow.com/questions/2664740/extract-file-basename-without-path-and-extension-in-bash
#
# circo -Tpng $Graphviz_flatfile -o "${Graphviz_flatfile%.dot}"_circo.png
# echo "${Graphviz_flatfile%.dot}"_circo.png

dot -Tpng $Graphviz_flatfile -o "${Graphviz_flatfile%.dot}".png
echo "${Graphviz_flatfile%.dot}".png

echo $Graphviz_flatfile

#
# xdot
# xdot -f dot $Graphviz_flatfile 
#

# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
