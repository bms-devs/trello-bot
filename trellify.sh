#!/bin/bash

# Tu jest binarka JQ, wersja 1.3
export PATH=$PATH:/opt

card_id_short=$1
target_list_name=$2

board_id='58ca5654a51dfec0ffa91369'
korekta_id='594cd61b9117fe35e10c3120'
code_review_id='576d08916b4642cfaad30af7'
verify_id='576d0896f6d3ed32ca2d15f2'
token='9e72c78b57fd133772cb9967edebbcfe4c9a184bb6304ce8f6ab3a23b3a01a4e'
key='ad3b3a870fe9443fc78044267e606046'

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
