#! /bin/bash
 
x=0
echo "$x"
echo "[" > topeka_landlords.json
 
 
landlord_count=$(curl 'https://gis.sncoapps.us/arcgis2/rest/services/Parcels/MapServer/0/query?f=json&returnIdsOnly=true&returnCountOnly=true&where=1=1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outSR=102100' \
    --compressed \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0' \
    -H 'Accept: */*' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'X-Requested-With: XMLHttpRequest' \
    -H 'Connection: keep-alive' \
    -H 'Referer: https://gis.sncoapps.us/propertysearch/index.html' \
    -H 'Cookie: AGS_ROLES="419jqfa+uOZgYod4xPOQ8Q=="; _ga_TYHN8MGCVK=GS1.1.1702344672.3.1.1702344683.0.0.0; _ga=GA1.2.1185162874.1702273355; _gid=GA1.2.265096220.1702273355; isfirst_propertysearch=false' 
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Site: same-origin' | jq '.count' )
 
landlord_data=$(curl 'https://gis.sncoapps.us/arcgis2/rest/services/Parcels/MapServer/0/query?f=json&where=1%3D1&returnGeometry=true&spatialRel=esriSpatialRelIntersects&outFields=*&outSR=102100&resultOffset=0&resultRecordCount=5000' \
    --compressed \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0' \
    -H 'Accept: */*' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'Referer: https://gis.sncoapps.us/propertysearch/index.html' \
    -H 'Connection: keep-alive' \
    -H 'Cookie: AGS_ROLES="419jqfa+uOZgYod4xPOQ8Q=="; _ga_TYHN8MGCVK=GS1.1.1702344672.3.1.1702344683.0.0.0; _ga=GA1.2.1185162874.1702273355; _gid=GA1.2.265096220.1702273355; isfirst_propertysearch=false' \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Sec-Fetch-Mode: no-cors' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'X-Requested-With: XMLHttpRequest' \
    -H 'Pragma: no-cache' \
    -H 'Cache-Control: no-cache' | jq '.')
 
n=$(echo "$landlord_count" | jq '.count')
max=5000
iters=$(echo $(( $n / $max )))
 
 
echo "$var" | jq '.features[].attributes' >> topeka_landlords.json
echo "," >> topeka_landlords.json
 
while [[ $x -le $iters ]]
do
    x=$(( $x + 1 ))
    echo ""
    echo "x is currently $x."
    echo "Scraping from $(( $x * 5000 )) to $(( $(( $x + 1 )) * 5000 ))"
    echo ""
 
    curl "https://gis.sncoapps.us/arcgis2/rest/services/Parcels/MapServer/0/query?f=json&where=1%3D1&returnGeometry=true&spatialRel=esriSpatialRelIntersects&outFields=OBJECTID%2CPARCELNUM%2CACRES%2CPIN%2CPID%2CQUICKREFID%2CONAME%2CPADDRESS%2CPADDRESS2%2CMAILNAME%2CMAILADDRESS%2CMAILADDRESS2%2CDBOOKPAGE%2CSUBS%2CTAXUNIT%2CUSD%2CLBCSFUNCTION%2CLBCSACTIVITY%2CCLASS%2CBLDGVAL%2CLDVAL%2CTOTVAL%2CPROPDESCRIPTION%2CShape.STArea()%2CShape.STLength()%2CNBHD&orderByFields=ONAME%20ASC&outSR=102100&resultOffset=$(( $x * 5000 ))&resultRecordCount=5000" \
                --compressed \
                -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0' \
                -H 'Accept: */*' \
                -H 'Accept-Language: en-US,en;q=0.5' \
                -H 'Accept-Encoding: gzip, deflate, br' \
                -H 'X-Requested-With: XMLHttpRequest' \
                -H 'Connection: keep-alive' \
                -H 'Referer: https://gis.sncoapps.us/propertysearch/index.html' \
                -H 'Cookie: _ga_TYHN8MGCVK=GS1.1.1702277109.2.1.1702278337.0.0.0; _ga=GA1.2.1185162874.1702273355; _gid=GA1.2.265096220.1702273355; isfirst_propertysearch=false' \
                -H 'Sec-Fetch-Dest: empty' \
                -H 'Sec-Fetch-Mode: cors' \
                -H 'Sec-Fetch-Site: same-origin'  | jq '.features[].attributes' >>  topeka_landlords.json
 
    echo "," >> topeka_landlords.json
done
 
echo "]" >> topeka_landlords.json
