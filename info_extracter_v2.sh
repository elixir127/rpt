#!/bin/bash
#info_extracter
#file_with_search_strings  should be in the format ...|...|search_string
# usage
# ./info_extracter.sh file_to_be_searched file_with_search_strings
# file_with_search_strings should not contain duplicate search strings

if [ "$#" -ne 2 ]; then
	echo -e "\e[0;31m[ERROR]Use: ./info_extracter.sh file_to_be_searched file_with_search_strings\e[0m"
	exit 1
fi

> results.txt
>temp.txt
#replace '.' with '_'
sed -i 's/\./_/g' $2

#WHILE BLOCK: isolates the search string, looks for the first match in the file_to_be_searched, extracts the
#first three columns of interest from the match and formats the output as needed 

STRING=$( sed "s/^[ \t]*//" < $1 | sed 's/^_*//')
STRING2=$(cut -d':' -f2 < $1 | sed "s/^[ \t]*//" | sed 's/^_*//')

while read LINE           
do  
	#search string is extracted and all leading '_' are stripped	 
	TEXT=$(cut -d'|' -f3 <<< "$LINE" | sed "s/^[ \t]*//" | sed 's/^_*//')

	#extracted string is searched for after trimming the input of leading spaces and replacing ':' with ';'
	TEXT1=$(grep -m 1  "^$TEXT:" <<< "$STRING" | cut -d \; -f 2-4 |  tr -d '[[:blank:]]' | tr ';' '|')   
     
	if [ -n "$TEXT1" ]; then
		echo "$LINE|$TEXT1" >> results.txt
	else
		#search for strings occuring after ':'
		TEXT2=$(grep -m 1  "^$TEXT[[:blank:]]" <<< "$STRING2" | cut -d \; -f 2-4 |  tr -d '[[:blank:]]' | tr ';' '|')

		if [ -n "$TEXT2" ]; then
			echo "$LINE|$TEXT2" >> results.txt
		else
		#for cases with no matches write them as they are
			echo "$LINE" >> results.txt
		fi
	fi
done < $2 

echo -e "\e[0;31m[INFO] Output written to results.txt\e[0m"
