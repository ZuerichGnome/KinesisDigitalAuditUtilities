# -------------------------------------------------------------
#
#!/bin/bash
#
# simplify-dot-file-to-3-vertices-4-arcs.sh
# chmo 755 simplify-dot-file-to-3-vertices-4-arcs.sh
#
# Usage:
#
# ./simplify-dot-file-to-3-vertices-4-arcs.sh dot-file
# ./simplify-dot-file-to-3-vertices-4-arcs.sh data/Graphviz-2023-07-12-T13:46:13-UTC.dot
#
# -------------------------------------------------------------

printf "Parameters\n" 
printf "%s\n" $0 
printf "%s\n" $1 

#
#
#
if [ ! "$#" -eq  "1" ]
then
    echo "Usage: $0 dot-file"
    exit 1
fi

if [ ! -f $1 ]; then echo "File $1 does not exist"; fi;

outputfile="${1%.dot}-simplified.dot"
if [ -f "$outputfile" ]; then rm -f $outputfile; fi; touch $outputfile;

printf "digraph {\n" >> $outputfile
grep 'E->U\|H->E\|H->U' $1 >> $outputfile
printf "}\n" >> $outputfile

dot -Tpng $outputfile -o "${outputfile%.dot}".png

# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
