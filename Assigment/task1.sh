#!/bin/bash
echo "Started at $(date)"
echo "Processing..."

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_accounts.csv>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: File not found"
    exit 1
fi
pth="$1"
tmp_pth="$(dirname $pth)/tmp.csv"
res_pth="$(dirname $pth)/accounts_new.csv"
lines=$(wc -l < $pth) 
i=0
emails=()
locations=()
while read line
	do
	words=()
	mapfile -t words < <(echo "$line" | grep -oE '([-[:alnum:]@._[:space:]]+)|("\w+\,.+\")')
	j=0
	for element in "${words[@]}"; do
		if [ $j -eq 0 ]; then
			id=$element
		elif [ $j -eq 1 ]; then
			locid=$element
			locations+=($locid)
		elif [ $j -eq 2 ]; then
			name=$element
		elif [ $j -eq 3 ]; then
			title=$element
		elif [ $j -eq 4 ]; then
			email=$element
		else
			department=$element
		fi
		((j++))
	done
	department=$(echo "$line" | grep -oE '[[:alnum:][:space:]]+$')
	if [ $j -le 4 ]; then
		department=""
	fi
	if [ $i -eq 0 ]; then
		echo "$id,$locid,$name,$title,$email,$department"
		emails+=($email)
	else
		lower="$(echo "$name" | sed 's/\b\w/\u&/g')" #parsing name and surname
		IFS=' ' read -r na sur <<< "$name"
		new_string="${na:0:1}$sur@abc.com" # parsing email
		low="${new_string,,}"
		echo "$id,$locid,$lower,$title,$low,$department"
		emails+=($low)
	fi
	
	((i++))
done < "$pth" > "$tmp_pth"

i=0
copy=("${emails[@]}")
for ((i=1; i < ${#emails[@]}; i++)); do
	for ((j=1; j < ${#emails[@]}; j++)); do
		if [ $i -eq $j ]; then
			continue
		elif [ ${copy[$i]} == ${emails[$j]} ]; then
			pattern="^([a-zA-Z]+)@abc.com"
			result=$(echo "${emails[$j]}" | sed -E "s/$pattern/\1/")
			s="$result${locations[$j]}"
			s+="@abc.com"
			emails[$j]="$s"
		fi
	done
done

i=0
while read line
	do
	words=()
	mapfile -t words < <(echo "$line" | grep -oE '([-[:alnum:]@._[:space:]]+)|("\w+\,.+\")')
	j=0
	for element in "${words[@]}"; do
		if [ $j -eq 0 ]; then
			id=$element
		elif [ $j -eq 1 ]; then
			locid=$element
		elif [ $j -eq 2 ]; then
			name=$element
		elif [ $j -eq 3 ]; then
			title=$element
		elif [ $j -eq 4 ]; then
			email=$element
		else
			department=$element
		fi
		((j++))
	done
	department=$(echo "$line" | grep -oE '[[:alnum:][:space:]]+$')
	if [ $j -le 5 ]; then
		department=""
	fi
	echo "$id,$locid,$name,$title,${emails[$i]},$department"
	((i++))
done < "$tmp_pth" > "$res_pth"
rm "$tmp_pth"
echo "Finished at $(date)"
