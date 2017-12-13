#!/bin/bash

# Tu jest binarka JQ, wersja 1.3
export PATH=$PATH:/opt

card_id_short=$1
target_list_name=$2

if [ ! -f config.cfg ]; then
    echo "ERROR: Config file config.cfg missing. Please create it from config.cfg-template. Aborting."
    exit 0
fi
source config.cfg

# TODO: Generalize list names
if [ "$target_list_name" == "korekta" ]; then
	target_list_id=$korekta_id
elif [ "$target_list_name" == "verify" ]; then
	target_list_id=$verify_id
elif [ "$target_list_name" == "code_review" ]; then
	target_list_id=$code_review_id
else
	echo ">> Wrong target list name. Must be one of the following: korekta, verify, code_review"
	exit 0
fi

cards=$(curl --request GET --url 'https://api.trello.com/1/boards/'$board_id'/cards?fields=idShort&key='$key'&token='$token)

for row in $(echo "${cards}" | jq -c '.[]'); do
	_jq() {
		echo ${row} | jq -r ${1}
	}
	idShort=$(_jq '.idShort')
	if [ $idShort -eq $card_id_short ];
	then
		card_id=$(_jq '.id')
		break
	fi
done

curl --request PUT --url 'https://api.trello.com/1/cards/'$card_id'?idList='$target_list_id'&key='$key'&token='$token
