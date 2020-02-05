#!/bin/bash

grafanaip=`echo $1`
grafanaport=`echo $2`
influxdbip=`echo $3`
influxdbport=`echo $4`

#create your datasource
curl --user admin:admin 'http://'''$grafanaip''':'''$grafanaport'''/api/datasources' -X  POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"InfluxDB","type":"influxdb","url":"http://'''${influxdbip}''':'''${influxdbport}'''","access":"proxy","database":"telegraf","isDefault":true,"basicAuth":false}'

tmpapikey=`curl -s http://admin:admin@''$grafanaip'':''$grafanaport''/api/auth/keys | jq '.[]|.id'`

#delete API key
curl -s -L -XDELETE -H "Content-Type: application/json" http://admin:admin@$grafanaip:$grafanaport/api/auth/keys/$tmpapikey

#create API key
apikey=`curl -X POST -H "Content-Type: application/json" -d '{"name":"apikeycurl", "role": "Admin"}' http://admin:admin@''$grafanaip'':''$grafanaport''/api/auth/keys | jq .key | tr -d '"'`

# import contents
for i in `ls *.json`;
do
    curl -X POST http://''$grafanaip'':''$grafanaport''/api/dashboards/db --insecure -H "Authorization: Bearer ${apikey}" -H "Content-Type:application/json" -d @$i;
done

# install piechart
grafana-cli plugins install grafana-piechart-panel

# restart server
service grafana-server restart
