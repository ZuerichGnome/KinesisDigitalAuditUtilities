# -------------------------------------------------------------
#
#!/bin/bash
#
# build-dot-file-4-tripartite-digraph-with-KAG-and-KAU-bipartite-dots-as-input.sh
# chmod 755 build-dot-file-4-tripartite-digraph-with-KAG-and-KAU-bipartite-dots-as-input.sh
#
# ./build-dot-file-4-tripartite-digraph-with-KAG-and-KAU-bipartite-dots-as-input.sh Graphviz-2023-07-25-T11:55:39-UTC.dot Graphviz-2023-07-25-T15:59:00-UTC.dot
#
# -------------------------------------------------------------

printf "Parameters\n" 
printf "%s\n" $0 
printf "%s\n" $1 
printf "%s\n" $2

#
#
#
if [ ! "$#" -eq  "2" ]
then
    echo "Usage: $0 bipartite-dot-1 bipartite-dot-2"
fi

Graphviz_flatfile=Graphviz-`date -u +"%Y-%m-%d-T%T-%Z"`-tripartite.dot
touch $Graphviz_flatfile

printf "digraph {\n" >> $Graphviz_flatfile
printf "rankdir=\"LR\"\n" >> $Graphviz_flatfile
#
#
# E and H vertices for KAG and KAU
#
#
printf "{rank="source"; GCGTMT2X,GBTYCT2V}\n" >> $Graphviz_flatfile
printf "{rank="sink"; GDIENNQ3,GBUBOKEF}\n" >> $Graphviz_flatfile
#
# cut off head and tail of the input dot files
#
sed '$d' $1 | sed '1,2d' >> $Graphviz_flatfile
sed '$d' $2 | sed '1,2d' >> $Graphviz_flatfile
#
printf "}\n" >> $Graphviz_flatfile
#
#
#
dot -Tpng $Graphviz_flatfile -o "${Graphviz_flatfile%.dot}".png
echo "${Graphviz_flatfile%.dot}".png
#
#
# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
