## Altibase-Cluster-Monitoring-System
Altibase Cluster Monitoring System is a graphical monitoring system for ALTIBASE.

It was built with using only open sources such as InfluxDB, Telegraf, Grafana.

## 패키지 수행 방법
1.Pull docker image 

2.Run shell script 
## Docker image
### 1.AMS image를 pull합니다
Image repository: https://hub.docker.com/repository/docker/altibaseams/altiams
```
> docker pull altibaseams/altiams
> docker run --name influxDB_WITH_Grafana -d -p 8086:8086 -p 8083:8083 -p 3000:3000 -p 4000:4000 altibaseams/altiams
```
### 2.telegraf 수행
장비에서 미리 ODBC를 세팅 해야 합니다.

http://docs.altibase.com/pages/viewpage.action?pageId=11698380
#### Monitoring 할 장비에서 telegraf 소스를 download
```
> git clone https://github.com/ALTIBASE/Altibase-Cluster-Monitoring-System.git
```
#### telegraf 소스를 수정
```
telegraf Directory에 들어 가서 각 정보를 맞춰서 수정합니다.

확인 해야 할 부분이 다음과 같습니다. 
influxdb uri, altibase uri,port 맞춰서 수정 하면 됩니다. 
 
a. telegraf.conf
[[outputs.influxdb]] urls = ["http://127.0.0.1:8086"] =>http://ipinfluxdb:portinfluxdb

hostname = "nval02(receiver)"

[[inputs.altibase]] altibase_dsn = "Altiodbc" => ODBC세팅
altibase_server = "127.0.0.1"
altibase_port = 43019
altibase_user = "sys"
altibase_password = "manager"

[[inputs.exec]] commands = [ "/home1/perf/work/ams/telegraf_altibase/checkdir.sh" ]


b. test.go
mysrv = flag.String("mysrv", "127.0.0.1", "altibase server ip")
mydb = flag.String("mydb", "mydb", "altibase database name")
myuser = flag.String("myuser", "sys", "altibase user name")
mypass = flag.String("mypass", "manager", "altibase password")
myport = flag.String("myport", "43019", "altibase port")


c. altibase.go
mysrv = flag.String("mysrv", "127.0.0.1", "altibase server ip")
mydb = flag.String("mydb", "mydb", "altibase database name")
myuser = flag.String("myuser", "sys", "altibase user name")
mypass = flag.String("mypass", "manager", "altibase password")
myport = flag.String("myport", "43019", "altibase port")
```
#### telegraf 수행
```
> nohup telegraf -config telegraf.conf &
```
### 3.grafana web접속
```
http://ipgrafana:portgrafana
```
#### grafana query 수정
```
grafana graph 마다 hostname 확인 합니다. 
telegraf.conf에서 세팅 해던 hostname로 수정해야 그 장비의 정보가 나옵니다.
```
## Shell Script
수행하기전에 jq 세팅 하세요.  /usr/bin밑에서 저장하면 됩니다.

### 1.check out shell script 
```
> git clone https://github.com/ALTIBASE/Altibase-Cluster-Monitoring-System.git
```
### 2.run shell script
```
crateDashboard Directory에 들어 가서 root권한으로 수행 합니다.
a. Redhat
> sh influxdbgrafana_redhat.run [--ipgrafana=IP] [--portgrafana=PORT] [--ipinfluxdb=IP] [--portinfluxdb=PORT] [--help]
 
b. Ubuntu
> sh influxdbgrafana_ubuntu.run [--ipgrafana=IP] [--portgrafana=PORT] [--ipinfluxdb=IP] [--portinfluxdb=PORT] [--help]
 
###############################################################################################
# 1. install influxdb                                                                         #
# 2. install grafana                                                                          #
# 3. import dashboard                                                                         #
#                                                                                             #
#--ipgrafana=IP        If no --ipgrafana option is given, the default value is 127.0.0.1      # 
#--portgrafana=PORT    If no --portgrafana option is given, the default value is 3000         #  
#--ipinfluxdb=IP       If no --ipinfluxdb option is given, the default value is 127.0.0.1     #
#--portinfluxdb=PORT   If no --portinfluxdb option is given, the default value is 8086        #   
###############################################################################################
```
### 3.telegraf 수행
"Docker image" 2번 telegraf 수행 참고.
### 4.grafana web접속
"Docker image" 3번 grafana web접속 참고.
