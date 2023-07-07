# -------------------------------------------------------------
#
#!/bin/bash
#
# chmod 755 bash-basics-workout.sh 
#
# -------------------------------------------------------------

printf "%s\n" "Hello world";

echo $SHELL

ping -c 5 kinesis.money
ping -c 5 mint.abx.com
ping -c 5 explorer.kinesis.money
ping -c 5 forum.kinesis.money

whois kinesis.money | grep -i "Registrant Organization\|City"

#
# Learn linux by practising it relentlessly
#

#
# Adding up numbers using "bc"
#
seq 1 10
seq 1 10 | paste -s
seq 1 10 | paste -s -d+
seq 1 10 | paste -s -d+ | bc -l
seq 1 10 | paste -s -d+ | bc -l | xargs xargs printf "%-10.0f\n"

#
# Adding numbers using "awk"
#
seq 1 10 | awk 'BEGIN {sum=0} {sum += $1} END {printf "%-10.0f\n", sum}'

#
#
# #mprashant
#
# https://docs.google.com/document/d/1kVU8rjnLr28xRHsREt9ycWitjyF0PTUVkGptGFmmgJc/edit
# https://www.youtube.com/watch?v=dcF5Rqw_VZ4
#
#
#range of lines 3 to 6
#
seq 1 10 | awk 'NR=="3", NR=="6" {print $1}'

#
# sed
# same thing
#
seq 1 10 | sed -n '3,6p'


#
# history lists last commands
#

# -c8- because I changed my prompt to
# PS1="linux> "

history | cut -c8- | tail -5

echo -n "linux> " | wc -c

# linux> echo -n "linux> " | wc -c
# 7

#
# What is a backtick ?
#
# Please make sure you can find the first 3 here on your keyboard:
#
printf "\x22 \x27 \x60 \u2019 \x40 \x25 \x26 \x30 \x5E \x7E \x7B \x7D \x7C \x5F \x5B \x5D \u041C \u0420\n"
#
# " ' ` ’ @ % & 0 ^ ~ { } | _ [ ] М Р
#

#
# C language formatting
#
printf "%-10s\t%d\t%5.2f\n" lala 42 234.567
# lala      	42	234.57
printf "%-10s\t%20d\t%-5.2f\n" lala 42 234.567
# lala      	                  42	234.57

#
# Check out "TAB autocomplete" at linux command line
# https://presearch.com/search?q=%22TAB%20autocomplete%22%20at%20linux%20command%20line
#

#
# Point a symbol to a Watcher data file
#
KAG_extract=../dat/kag-stellar-export-using-Operations-TAB-2023-07-05-T12\:12\:12-UTC.csv 

echo $KAG_extract
# ../dat/kag-stellar-export-using-Operations-TAB-2023-07-05-T12:12:12-UTC.csv

#
# Play with it
# It has column headers in first line
#
head -1 $KAG_extract
#"id","transactionSuccessful","sourceAccount","type","typeI","createdAt","transactionHash","account","into","startingBalance","funder","assetType","from","to","amount","signerKey","signerWeight","masterKeyWeight","lowThreshold","medThreshold","highThreshold"

#
# substitute all commas for carriage return
#
head -1 $KAG_extract | sed 's/,/\n/g'

#
# slap a line number at the beginning
#

head -1 $KAG_extract | sed 's/,/\n/g' | nl -ba 

#
# sed '1d'
# deletes first line of the character flow (a file here) in the pipe
# not in-place
#
wc -l $KAG_extract
sed '1d' $KAG_extract | wc -l
wc -l $KAG_extract


# linux> wc -l $KAG_extract
# 32611 ../dat/kag-stellar-export-using-Operations-TAB-2023-07-05-T12:12:12-UTC.csv
# linux> sed '1d' $KAG_extract | wc -l
#32610
# linux> wc -l $KAG_extract
# 32611 ../dat/kag-stellar-export-using-Operations-TAB-2023-07-05-T12:12:12-UTC.csv

#
# expand from tabs to spaces
#
# man is linux manual for the command
#
man expand

#
# Stored here at github
#
. ./KAG-set-main-account-symbols.sh 

#
# Make select extracts from the symbols just set
#

set | grep KAG | sed -n '1,5p' | cut -c5 | tr '[:upper:]' '[:lower:]' > t1
set | grep KAG | sed -n '1,5p' | cut -c5 > t2
set | grep KAG | sed -n '1,5p' | cut -d= -f1 > t3

#
# %Z is UTC date format
#
# touch creates an empty file
# later >> appends to this file jsut created
#

outputfile=outputfile-`date -u +"%Y-%m-%d-T%H:%I:%S-%Z"`
touch $outputfile

pr -w 90 -m -t t3 t1 t2 | expand >> $outputfile
echo >> $outputfile
cat KAG-set-main-account-symbols.sh | sort -t= -k2 >> $outputfile

#
# ^ regexp for beginning of line
#

# To document here
sed 's/^/# /g' $outputfile

# KAG_EmissionAccount           e                             E
# KAG_GAPSAccount               g                             G
# KAG_HotWalletAccount          h                             H
# KAG_InflationAccount          i                             I
# KAG_RootAccount               r                             R
# 
# KAG_GAPSAccount=GAPS3KZ4YVEL4UYFAGTE6L6H6GRZ3KYBWGY2UTGTAJBXGUJLBCYQIXXA
# KAG_RootAccount=GAUCIFE37F4KQ5F6QPNSZ75QKRQTNRCF32FZNUXMCXUFSKRMWGF76LTI
# KAG_InflationAccount=GBBVUAMR3CYNQKMNHVWCMUQVE3XQIL3WM5GSP5D6SCECKIZNNBT6FT7I
# KAG_HotWalletAccount=GBTYCT2VVWURNU23ZSR3IPSXU6BRWT3ELIOQJAJOKGIHCLLE6YDX4A7E
# KAG_EmissionAccount=GCGTMT2X6NUV6ABEOAOSDI2YQ7FXQOQYKYA7KVZQ5ID67GQU3C6AIUGU
# FeePoolAccount=GDVIVQWQIOVXP4EWQNLZHEGGLUUQALJ47HSN2MZXCEJKSSH4DBRT5BDM

# -------------------------------------------------------------
#
#
#
# -------------------------------------------------------------
