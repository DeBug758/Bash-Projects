#!/bin/bash

echo "Started at $(date)"
echo "Processing..."

pth="$1"
tmp_pth="$(dirname $pth)/tmp.json"
res="$(dirname $pth)/output.json"
i=0
flag=0
succes=0
cp "$pth" "$tmp_pth"
if [ "$(tail -c 1 $tmp_pth)" != "" ]; then # checking, if file ends with empty line
	echo >> "$tmp_pth" # if not, adding
fi
while IFS= read -r line ; do #reading file line by line
	if [ $i -eq 0 ]; then # for the header line
		echo "{"
		echo -n " \"testName\": "
		echo "\"$(echo "$line" | grep -oE "\[ [[:alnum:][:space:]]+ \]" | cut -c 3- | rev | cut -c 3- | rev)\","
		echo " \"$(echo "$line" | grep -oE "\w+$")\": ["
		((i++))
	elif [[ $line =~ [-]+ ]]; then # skipping "---------" lines
		((i++))
		continue
	elif [ $i -eq 2 ]; then # for body
		if [ $flag -eq 1 ]; then # for , after the }
			echo ","
		fi
		flag=1
		echo "   {"
		echo -n "     \"name\": "
		echo "\"$(echo "$line" | grep -oE "  [[:alpha:][:space:](,]+)" | cut -c 3-)\","
		if [[ $line =~ "not ok  " ]]; then
			echo "     \"status\": false,"
		else
			((succes++))
			echo "     \"status\": true,"
		fi
	
		echo "     \"duration\": \"$(echo "$line" | grep -oE "[0-9]+ms")\""
		echo -n "   }"
	else # For summary
		echo ""
		echo " ],"
		echo " \"summary\": {"
		echo "   \"success\": $succes,"
		all=$(echo "$line" | grep -oE "\(of [0-9]+\)" | cut -c 5- | rev | cut -c 2- | rev)
		echo "   \"failed\": $(( all - succes )),"
		echo "   \"rating\": $(echo "$line" | grep -oE "[0-9.]+%" | rev | cut -c 2- | rev),"
		echo "   \"duration\": \"$(echo "$line" | grep -oE "[0-9]+ms")\""
		echo " }"
		echo "}"
	fi
	
done < "$tmp_pth" > "$res"
rm "$tmp_pth"
rm "$pth"
echo "Ended at $(date)"
exit 0
