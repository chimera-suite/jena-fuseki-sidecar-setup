#! /bin/bash

echo "Checking enviroment variables..."

function check {
    [ -z "$2" ] && echo "Need to set $1" && exit 1;
}

TIMEOUT=120

check JENA_FUSEKI $JENA_FUSEKI
check USERNAME $USERNAME
check PASSWORD $PASSWORD
check DATASET $DATASET

BASIC_AUTH=$(echo -n "${USERNAME}:${PASSWORD}" | base64)
BASIC_AUTH+="="

echo "Done!"

echo "Searching files in /init folder..."

number_of_files=$(ls /init/* | wc -l)
echo "Found ${number_of_files} files."
for file in /init/*
do
	echo "Found file ${file}"
done

echo "Waiting for Jena Fuseki..."

set -e

./wait-for.sh "$JENA_FUSEKI" --timeout=120

echo "Jena Fuseki is ready!"

echo "Deleting dataset ${DATASET} if exists ..."

# curl --location --request GET "http://${JENA_FUSEKI}/$/server" \
# 	 --header "Authorization: Basic ${BASIC_AUTH}"

curl -v --location --request DELETE "http://${JENA_FUSEKI}/$/datasets/${DATASET}" \
	 --header "Authorization: Basic ${BASIC_AUTH}"

echo "Creating dataset ${DATASET} ..."

curl -v --location --request POST "http://${JENA_FUSEKI}/$/datasets" \
	 --header "Authorization: Basic ${BASIC_AUTH}" \
	 --header "Content-Type: application/x-www-form-urlencoded" \
	 --data-urlencode "dbName=${DATASET}" \
	 --data-urlencode "dbType=mem"

for file in /init/*
do
	echo "Uploading file ${file}"

	curl -v --location --request POST "http://${JENA_FUSEKI}/${DATASET}/data" \
		 --header "Authorization: Basic ${BASIC_AUTH}" \
		 --form "files=@${file}"
done

# curl 'http://localhost:3030/$/datasets' \
#   -H 'Connection: keep-alive' \
#   -H 'Authorization: Basic YWRtaW46YWRtaW4=' \
#   -H 'Accept: */*' \
#   -H 'X-Requested-With: XMLHttpRequest' \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
#   -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
#   -H 'Origin: http://localhost:3030' \
#   -H 'Sec-Fetch-Site: same-origin' \
#   -H 'Sec-Fetch-Mode: cors' \
#   -H 'Sec-Fetch-Dest: empty' \
#   -H 'Referer: http://localhost:3030/manage.html' \
#   -H 'Accept-Language: en-US,en;q=0.9,it;q=0.8' \
#   -H 'Cookie: JSESSIONID=node0okwrgz7xrz3f1h8hffif4ev8t1.node0' \
#   --data-raw 'dbName=ds3&dbType=mem' \
#   --compressed

#   curl 'http://localhost:3030/ds3/data' \
#   -H 'Connection: keep-alive' \
#   -H 'Accept: application/json, text/javascript, */*; q=0.01' \
#   -H 'X-Requested-With: XMLHttpRequest' \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
#   -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryzjySgVh6N0r6QvQt' \
#   -H 'Origin: http://localhost:3030' \
#   -H 'Sec-Fetch-Site: same-origin' \
#   -H 'Sec-Fetch-Mode: cors' \
#   -H 'Sec-Fetch-Dest: empty' \
#   -H 'Referer: http://localhost:3030/dataset.html?tab=upload&ds=/ds3' \
#   -H 'Accept-Language: en-US,en;q=0.9,it;q=0.8' \
#   -H 'Cookie: JSESSIONID=node0okwrgz7xrz3f1h8hffif4ev8t1.node0' \
#   --data-binary $'------WebKitFormBoundaryzjySgVh6N0r6QvQt\r\nContent-Disposition: form-data; name="files[]"; filename="simple-foaf.ttl"\r\nContent-Type: application/octet-stream\r\n\r\n\r\n------WebKitFormBoundaryzjySgVh6N0r6QvQt--\r\n' \
#   --compressed

#   curl 'http://localhost:3030/$/server' \
#   -H 'Connection: keep-alive' \
#   -H 'Authorization: Basic YWRtaW46YWRtaW4=' \
#   -H 'Accept: application/json, text/javascript, */*; q=0.01' \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
#   -H 'X-Requested-With: XMLHttpRequest' \
#   -H 'Sec-Fetch-Site: same-origin' \
#   -H 'Sec-Fetch-Mode: cors' \
#   -H 'Sec-Fetch-Dest: empty' \
#   -H 'Referer: http://localhost:3030/manage.html' \
#   -H 'Accept-Language: en-US,en;q=0.9,it;q=0.8' \
#   -H 'Cookie: JSESSIONID=node0okwrgz7xrz3f1h8hffif4ev8t1.node0' \
#   --compressed

#   curl 'http://localhost:3030/$/datasets/ds4' \
#   -X 'DELETE' \
#   -H 'Connection: keep-alive' \
#   -H 'Authorization: Basic YWRtaW46YWRtaW4=' \
#   -H 'Accept: */*' \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
#   -H 'X-Requested-With: XMLHttpRequest' \
#   -H 'Origin: http://localhost:3030' \
#   -H 'Sec-Fetch-Site: same-origin' \
#   -H 'Sec-Fetch-Mode: cors' \
#   -H 'Sec-Fetch-Dest: empty' \
#   -H 'Referer: http://localhost:3030/manage.html' \
#   -H 'Accept-Language: en-US,en;q=0.9,it;q=0.8' \
#   -H 'Cookie: JSESSIONID=node0okwrgz7xrz3f1h8hffif4ev8t1.node0' \
#   --compressed