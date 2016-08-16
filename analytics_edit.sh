#!/bin/bash
#analytics_edit

clear

if [ "$#" -ne 1 ]; then
	echo -e "\e[0;31m[ERROR]Use: ./analytics_edit.sh <c file name with extension>\e[0m"
	exit 1
fi

#get the line numbers of Analysis and Synthesis Resource Utilization section
LINE_NUMBER_START="$(grep --line-number "; Analysis & Synthesis Resource Utilization by Entity" $1 | cut -f1 -d:)"
LINE_NUMBER_END="$(grep --line-number "; Analysis & Synthesis RAM Summary" $1 | cut -f1 -d:)"

#modify the line numbers to restrict text to contain only the needed information
MOD_LINE_NUMBER_START="$(expr $LINE_NUMBER_START + 1)"
MOD_LINE_NUMBER_END="$(expr $LINE_NUMBER_END - 5)"


#capture text in between the line numbers computed above and write to a temp file
head -n $MOD_LINE_NUMBER_END $1 | tail -n $(($MOD_LINE_NUMBER_END-$MOD_LINE_NUMBER_START)) | sed 's|[|+-]||g' > temp_text.txt

#write the first 4 columns to mod_info.txt
cut -d \; -f 2-5 ./temp_text.txt > mod_info_1.txt

#new
sed -i 's/:\.\?\;//g' mod_info_1.txt

#remove the temp file
rm temp_text.txt

echo -e "\e[0;31m[INFO] Output written to mod_info_1.txt\e[0m"
