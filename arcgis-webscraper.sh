#! /bin/bash
 
RILEY="https://gis.rileycountyks.gov/arcgis/rest/services/GISWeb/Parcels_and_Subdivisions/MapServer/0/query"
PARAMS="f=geojson&outFields=*&spatialRel=esriSpatialRelIntersects&where=1%3D1&geometryType=esriGeometryEnvelope"
COOKIES="_ga=GA1.1.533426542.1705377319; _ga_46WY9N63HY=GS1.1.1705377319.1.0.1705377319.0.0.0"
REFERRER="https://gis.rileycountyks.gov"

x=0
echo "$x"
echo "[" > $1_landlords.json


landlord_count=$(curl "$RILEY?f=json&returnIdsOnly=true&returnCountOnly=true&where=1=1&returnGeometry=false&spatialRel=esriSpatialRelIntersects" --compressed \
	-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0" \
	-H "Accept: */*" \
	-H "Accept-Language: en-US,en;q=0.5" \
	-H "Accept-Encoding: gzip, deflate, br" \
	-H "X-Requested-With: XMLHttpRequest" \
	-H "Connection: keep-alive" \
	-H "Referer: $REFERRER" \
	-H "Cookie: $COOKIES; isfirst_propertysearch=false"
	-H "Sec-Fetch-Dest: empty" \
	-H "Sec-Fetch-Mode: cors" \
	-H "Sec-Fetch-Site: same-origin" | jq ".count" )

landlord_data=$(curl "$RILEY?$PARAMS&resultOffset=0&resultRecordCount=5000" \
	--compressed \
	-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0" \
	-H "Accept: */*" \
	-H "Accept-Language: en-US,en;q=0.5" \
	-H "Accept-Encoding: gzip, deflate, br" \
	-H "Referer: $REFERRER" \
	-H "Connection: keep-alive" \
	-H "Cookie: $COOKIES; isfirst_propertysearch=false" \
	-H "Sec-Fetch-Dest: empty" \
	-H "Sec-Fetch-Mode: no-cors" \
	-H "Sec-Fetch-Site: same-origin" \
	-H "X-Requested-With: XMLHttpRequest" \
	-H "Pragma: no-cache" \
	-H "Cache-Control: no-cache" | jq ".")

n=$(echo "$landlord_count" | jq ".count")
max=5000
iters=$(echo $(( $n / $max )))


echo "$var" | jq ".features[].attributes" >> $1_landlords.json
echo "," >> $1_landlords.json

while [[ $x -le $iters ]]
do
	x=$(( $x + 1 ))
	echo ""
	echo "x is currently $x."
	echo "Scraping from $(( $x * 5000 )) to $(( $(( $x + 1 )) * 5000 ))"
	echo ""

	curl "$RILEY?$PARAMS&resultOffset=$(( $x * 5000 ))&resultRecordCount=5000" \
                --compressed \
                -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0" \
                -H "Accept: */*" \
                -H "Accept-Language: en-US,en;q=0.5" \
                -H "Accept-Encoding: gzip, deflate, br" \
                -H "X-Requested-With: XMLHttpRequest" \
                -H "Connection: keep-alive" \
                -H "Referer: $REFERRER" \
                -H "Cookie: $COOKIES" \
                -H "Sec-Fetch-Dest: empty" \
                -H "Sec-Fetch-Mode: cors" \
                -H "Sec-Fetch-Site: same-origin" | jq ".">>  $1_landlords.json

	echo "," >> $1_landlords.json
done

echo "]" >> $1_landlords.json
