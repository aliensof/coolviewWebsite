# CoolView
Coolview IOT Project 

## Dependencies
  - [.NET 8.0 (Blazor WASM, ASP.NET)](https://dotnet.microsoft.com)
  - [UI Components Library (MudBlazor)](https://mudblazor.com)
  - [Charts (Blazor ApexCharts)](https://www.nuget.org/packages/Blazor-ApexCharts)
  - [QRCode scanner](https://www.nuget.org/packages/ReactorBlazorQRCodeScanner)
  - [Web push notifications](https://github.com/web-push-libs/web-push-csharp)
  - [Timescale DB](https://www.timescale.com)
  - [Mosquitto (container setup)](https://cedalo.com/blog/mosquitto-docker-configuration-ultimate-guide/) 
  
All connections credentials should be stored in environment variables!
To run the localhost test it can be found in IoTPortal.Server/Properties/launchSettings.json

### Deploying app on new server:
1. Generate certificates 
    - chmod +x IoTPortal.Certificates/generate_crt_{YOUR OS HERE}.sh
    - ./IoTPortal.Certificates/generate_crt_{YOUR OS HERE}.sh <IP_OR_HOST_NAME_OF_MQTT_SERVER>
2. Read IoTPortal.Secrets/README.Secrets.md and fill passwords
3. Run install.sh
    - chmod +x install.sh
    - ./install.sh
4. Run run.sh
    - chmod +x run.sh
    - ./run.sh

### For Let's encrypt certificates:
[Certbot instructions](https://certbot.eff.org/instructions?ws=nginx&os=ubuntufocal)

##### Install certbot (For more information read instructions from the link above. If any installation of certbot exists you should remove it.)
```sudo snap install --classic certbot```
```sudo ln -s /snap/bin/certbot /usr/bin/certbot```

1. Test issue a certificate process
```sudo certbot certonly --webroot -w /var/lib/docker/volumes/coolview-client-certbot/_data/ -d coolview.co --dry-run --debug-challenges -v```
##### If it works:
2. run ./lets_encrypt_new.sh

### Updating
- All app: ./docker_init.sh
- All containers: docker compose up --build -d
- One container: docker compose up --build -d TARGET_NAME (client_and_reverse_proxy, server, timescaledb, mosquitto)

### Admin zone
##### To register admin user you need to:
1. Get server id from docker volume coolview-server-certificates/server_id (!VERY IMPORTANT! do not lose until deploy on new server)
2. Register admin user in web ui. Fill user name with string: <YOUR_USER_NAME>@$erver_id=<SERVER_ID>
3. Now you can use admin api

##### Using admin API:
1. Login: ```POST http(s)://<ADDRESS>/api/Authentication/login```
with json in request body:
```
{
    "userName": "user",
    "password": "password"
}
```
2. Get JWT token from answer ("jwt" field) and use it in future requests header `Authorization`: `Bearer <JWT TOKEN HERE>`

##### Admin API:
1. Get device registring format: ```GET http(s)://<ADDRESS>/api/AdminZone/Devices/Format```
2. Register device: Json with format from P.1 in request body.
```POST http(s)://<ADDRESS>/api/AdminZone/Devices/Register```
you will get an answer with device certificates for mqtt broker in PEM format (DO NOT LOSE):
```
{
    "privateKey": "CLIENT_PEM_KEY" 
    "rootCRT": "CA_CRT"
    "clientCRT": "CLIENT_PEM_CRT"
}
```
3. Delete device: ```DELETE http(s)://<ADDRESS>/api/AdminZone/Devices/<DEVICE_ID>```
4. Get devices ids: ```GET http(s)://<ADDRESS>/api/AdminZone/Devices/Ids```
5. Get devices: ```GET http(s)://<ADDRESS>/api/AdminZone/Devices```

### Docker build time configs
1. Nginx configuration is located in IoTPortal.Client
2. Mosquitto configuration is located in IoTPortal.Mosquitto
3. Client app configuration in IoTPortal.Client/wwwroot/config/appsettings.<ENVIRONMENT>.json
4. Server app configuration in IoTPortal.Server/appsettings.<ENVIRONMENT>.json
5. IoTPortal.Secrets: Services passwords for docker build stage
6. IoTPortal.Certificates: SSL and other certificates for app and services in 

### Docker volumes (runtime configs and persistent data)
1. timescale-db-data: postgress persistent storage, data, config
2. mosquitto-data: mosquitto persistent storage
3. mosquitto-config: mosquitto config 
4. mosquitto-log: mosquitto log file
5. coolview-server-certificates: ssl certificates and server ID
6. coolview-server-logs: server app log file
7. coolview-client-nginx-certificates: ssl certificates for nginx and client app
8. coolview-client-nginx-logs: nginx log
9. coolview-client-certbot: volume for certbot .well-known/acme-challenge/