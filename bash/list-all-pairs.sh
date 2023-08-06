# -------------------------------------------------------------
#
#!/bin/bash
#
# list-all-pairs.sh
# chmo 755 list-all-pairs.sh
#
# -------------------------------------------------------------

expand -4 list-all-pairs.py > wip.py
time python3 wip.py > outputfile-all-pairs

outputfile=outputfile-`date -u +"%Y-%m-%d-T%T-%Z"`.dot
if [ -f "$outputfile" ]; then rm -f $outputfile; fi; touch $outputfile;

printf "Digraph AllPairs {\n" >> $outputfile
cat outputfile-all-pairs | sed '1,2d' | sed '/^$/d' | awk -F" " '{print $4, $3}' | sort -u -t" " | sed '1d' | sed 's/ /->/g' >> $outputfile
printf "}\n" >> $outputfile

circo -Tpng $outputfile -o "${outputfile%.dot}".png
echo "${outputfile%.dot}".png

# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
