#include <ESP8266WiFi.h>
#include <ArduinoJson.h>
WiFiClient client;

const char* ssid     = "P811";
const char* password = "tumotdenchin";
const char* host = "192.168.100.20";

/*
const char* ssid     = "Ptnktd";
const char* password = "hoilamgivay";
const char* host = "192.168.1.29";
*/
const int httpPort = 9000;
int updateFlag = 0;
int receiveFromSystemFlag = 0;
int count = 0;
char stateFromInternetToSystem[18],oldstateFromInternetToSystem[18];
String stateFromSystemToInternet;
char oldstateFromSystemToInternet[18];
char devicesState[18];
char setTimeFromInternetToSystem[11];
char tempDeviceTime[5],flagUpdateSetTime[11],device1TimeOn[5],device1TimeOff[5],device2TimeOn[5],device2TimeOff[5],device3TimeOn[5],device3TimeOff[5];

void wifiInit(void);
void configState(void);
//System
void processDataFromSystem(void);
//Internet
void checkUpdateFlag(void);
void clearUpdateFlag(void);
void controlDevice(String device, String state);
void readJSONFromStatePage (void);
void sendTemperature(int temp);
//void sendState(void);
void sendStateFromInternetToSystem(void);
void sendSetTimeFromInternetToSystem(void);
void sendDataFromSensorToInternet(String type, int value);

void setup() {
    Serial.begin(9600);
    Serial.setTimeout(50);
    delay(100);
    wifiInit();
    configState();
    //Serial.println("System is OK");
    delay(200);
}

void loop() {
    checkUpdateFlag();
    if(updateFlag == 1){
      readJSONFromStatePage();
      //Serial.println("Start Send Set time");
      sendStateFromInternetToSystem();
      sendSetTimeFromInternetToSystem();
      clearUpdateFlag();
      updateFlag = 0;
    }
    if(Serial.available() > 0){
       stateFromSystemToInternet = Serial.readString();
       //Serial.println(stateFromSystemToInternet);
       processDataFromSystem();
    }
}

void wifiInit(void){
    /*
    Serial.println("");
    Serial.print("Connecting to ");
    Serial.println(ssid);
    */
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      //Serial.print(".");
    }
    /*
    Serial.println("");
    Serial.println("WiFi connected");  
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
    Serial.print("Ket noi toi web ");
    Serial.println(host);
    */
}

void configState(void){
    int i;
    stateFromInternetToSystem[0]  = 'S';
    for(i=1;i<17;i++){
      stateFromInternetToSystem[i]='0';
    }
    stateFromInternetToSystem[17] = 'E';
    strcpy(devicesState,stateFromInternetToSystem);
    device1TimeOn[0]='0';
    device1TimeOn[1]='0';
    device1TimeOn[2]=':';
    device1TimeOn[3]='0';
    device1TimeOn[4]='0';
    strcpy(device1TimeOff,device1TimeOn);
    strcpy(device2TimeOn,device1TimeOn);
    strcpy(device2TimeOff,device1TimeOn);
    strcpy(device3TimeOn,device1TimeOn);
    strcpy(device3TimeOff,device1TimeOn);
    setTimeFromInternetToSystem[0] = 'S';
    setTimeFromInternetToSystem[1] = '1';
    setTimeFromInternetToSystem[2] = 'D';
    setTimeFromInternetToSystem[3] = '0';
    setTimeFromInternetToSystem[4] = '1';
    setTimeFromInternetToSystem[5] = '0';
    setTimeFromInternetToSystem[6] = '0';
    setTimeFromInternetToSystem[7] = '0';
    setTimeFromInternetToSystem[8] = '0';
    setTimeFromInternetToSystem[9] = '0';
    setTimeFromInternetToSystem[10]= 'E';
}


void checkUpdateFlag (void)
{
    if (!client.connect(host, httpPort)) { 
    //Serial.println("Khong ket noi duoc");
    return;
    }
    client.print(String("GET /") + "checkChangedFlag" +" HTTP/1.1\r\n" +
              "Host: " + host + "\r\n" +
              "Connection: close\r\n\r\n"); 
    
    unsigned long timeout = millis();
    while (client.available() == 0) {
        if (millis() - timeout > 5000) {
          //Serial.println(">>> Client Timeout !");
          client.stop();
          return;
        }
    }

    while (client.available()) {
        String line = client.readStringUntil('\R');
        String result = line.substring(118);
        int size = result.length()+1;
        char json[size];
        result.toCharArray(json, size);
        StaticJsonBuffer<200> jsonBuffer;
        JsonObject& json_parsed = jsonBuffer.parseObject(json);
        if (strcmp(json_parsed["changedFlagStatus"], "true") == 0) { 
            updateFlag = 1;
        }
    }
}

void clearUpdateFlag(void){
    String clearUpdateFlag = "checkChangedFlag?device=NodeMCU";
    if (!client.connect(host, httpPort)) { 
      //Serial.println("Khong ket noi duoc");
      return;
    }
    client.print(String("GET /") + clearUpdateFlag +" HTTP/1.1\r\n" +
                "Host: " + host + "\r\n" +
                "Connection: close\r\n\r\n");             
    delay(100);
}

void readJSONFromStatePage (void)
{
    if (!client.connect(host, httpPort)) { 
        //Serial.println("Khong ket noi duoc");
        return;
    }
    client.print(String("GET /") + "state" +" HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" +
               "Connection: close\r\n\r\n");

    unsigned long timeout = millis();
    while (client.available() == 0) {
        if (millis() - timeout > 5000) {
          //Serial.println(">>> Client Timeout !");
          client.stop();
          return;
        }
    }  
          
    while (client.available()) {
        String line = client.readStringUntil('\R');
        String result = line.substring(118);
        int size = result.length()+1;
        char json[size];
        result.toCharArray(json, size);
        StaticJsonBuffer<200> jsonBuffer;
        JsonObject& json_parsed = jsonBuffer.parseObject(json);
        if (strcmp(json_parsed["device1"], "on") == 0) { 
            //Serial.println("Thiet bi 1 ON");
            stateFromInternetToSystem[2]  = '1';
        }
        if (strcmp(json_parsed["device1"], "off") == 0) { 
            //Serial.println("Thiet bi 1 OFF");
            stateFromInternetToSystem[2]  = '0';
        }
        if (strcmp(json_parsed["device2"], "on") == 0) { 
            //Serial.println("Thiet bi 2 ON");
            stateFromInternetToSystem[3]  = '1';
        }
        if (strcmp(json_parsed["device2"], "off") == 0) { 
            //Serial.println("Thiet bi 2 OFF");
            stateFromInternetToSystem[3]  = '0';   
        }
        if (strcmp(json_parsed["device3"], "on") == 0) { 
            //Serial.println("Thiet bi 2 ON");
            stateFromInternetToSystem[4]  = '1';
        }
        if (strcmp(json_parsed["device3"], "off") == 0) { 
            //Serial.println("Thiet bi 2 ON");
            stateFromInternetToSystem[4]  = '0';
        }
        strcpy(tempDeviceTime, json_parsed["device1TimeOn"]);
        if (strcmp(device1TimeOn,tempDeviceTime) != 0){
          strcpy(device1TimeOn, json_parsed["device1TimeOn"]);
          flagUpdateSetTime[1] = 1;
        }
        strcpy(tempDeviceTime, json_parsed["device1TimeOff"]);
        if (strcmp(device1TimeOff,tempDeviceTime) != 0){
          strcpy(device1TimeOff, json_parsed["device1TimeOff"]);
          flagUpdateSetTime[1] = 1;
        }
        
        
        strcpy(tempDeviceTime, json_parsed["device2TimeOn"]);
        if (strcmp(device2TimeOn,tempDeviceTime) !=0){
          strcpy(device2TimeOn, json_parsed["device2TimeOn"]);
          flagUpdateSetTime[2] = 1;
        }
        strcpy(tempDeviceTime, json_parsed["device2TimeOff"]);
        if (strcmp(device2TimeOff,tempDeviceTime) !=0){
          strcpy(device2TimeOff, json_parsed["device2TimeOff"]);
          flagUpdateSetTime[2] = 1;
        }

        
        strcpy(tempDeviceTime, json_parsed["device3TimeOn"]);
        if (strcmp(device3TimeOn,tempDeviceTime) !=0){
          strcpy(device3TimeOn, json_parsed["device3TimeOn"]);
          flagUpdateSetTime[3] = 1;
        }
        strcpy(tempDeviceTime, json_parsed["device3TimeOff"]);
        if (strcmp(device3TimeOff,tempDeviceTime) !=0){
          strcpy(device3TimeOff, json_parsed["device3TimeOff"]);
          flagUpdateSetTime[3] = 1;
        }
        /*
        Serial.println(device1TimeOn);
        Serial.println(device1TimeOff);
        Serial.println(device2TimeOn);
        Serial.println(device2TimeOff);
        Serial.println(device3TimeOn);
        Serial.println(device3TimeOff);
        */
    }
    //Serial.println("closing connection");
}

void sendStateFromInternetToSystem(void){
   if(strcmp(stateFromInternetToSystem,devicesState) !=0){
      strcpy(devicesState,stateFromInternetToSystem);
      Serial.println(stateFromInternetToSystem);
      //delay(200);
   }
}
void sendSetTimeFromInternetToSystem(void){
    //Device 1 set time on
    if(flagUpdateSetTime[1] == 1){
      flagUpdateSetTime[1] = 0;
      setTimeFromInternetToSystem[4]='1';
      setTimeFromInternetToSystem[5]=device1TimeOn[0];
      setTimeFromInternetToSystem[6]=device1TimeOn[1];
      setTimeFromInternetToSystem[7]=device1TimeOn[3];
      setTimeFromInternetToSystem[8]=device1TimeOn[4];
      setTimeFromInternetToSystem[9]='1';
      Serial.println(setTimeFromInternetToSystem);
      delay(200);
      //
      setTimeFromInternetToSystem[4]='1';
      setTimeFromInternetToSystem[5]=device1TimeOff[0];
      setTimeFromInternetToSystem[6]=device1TimeOff[1];
      setTimeFromInternetToSystem[7]=device1TimeOff[3];
      setTimeFromInternetToSystem[8]=device1TimeOff[4];
      setTimeFromInternetToSystem[9]='0';
      Serial.println(setTimeFromInternetToSystem);
      delay(200);
    }
    //Device 2 set time on
    if(flagUpdateSetTime[2] == 1){
      flagUpdateSetTime[2]=0;
      setTimeFromInternetToSystem[4]='2';
      setTimeFromInternetToSystem[5]=device2TimeOn[0];
      setTimeFromInternetToSystem[6]=device2TimeOn[1];
      setTimeFromInternetToSystem[7]=device2TimeOn[3];
      setTimeFromInternetToSystem[8]=device2TimeOn[4];
      setTimeFromInternetToSystem[9]='1';
      Serial.println(setTimeFromInternetToSystem);
      delay(200);
      //
      setTimeFromInternetToSystem[4]='2';
      setTimeFromInternetToSystem[5]=device2TimeOff[0];
      setTimeFromInternetToSystem[6]=device2TimeOff[1];
      setTimeFromInternetToSystem[7]=device2TimeOff[3];
      setTimeFromInternetToSystem[8]=device2TimeOff[4];
      setTimeFromInternetToSystem[9]='0';
      Serial.println(setTimeFromInternetToSystem);
      delay(200);
    }
    //Device 3 set time on
    if(flagUpdateSetTime[3] == 1){
      flagUpdateSetTime[3] = 0;
      setTimeFromInternetToSystem[4]='3';
      setTimeFromInternetToSystem[5]=device3TimeOn[0];
      setTimeFromInternetToSystem[6]=device3TimeOn[1];
      setTimeFromInternetToSystem[7]=device3TimeOn[3];
      setTimeFromInternetToSystem[8]=device3TimeOn[4];
      setTimeFromInternetToSystem[9]='1';
      Serial.println(setTimeFromInternetToSystem);
      delay(200);
      //
      setTimeFromInternetToSystem[4]='3';
      setTimeFromInternetToSystem[5]=device3TimeOff[0];
      setTimeFromInternetToSystem[6]=device3TimeOff[1];
      setTimeFromInternetToSystem[7]=device3TimeOff[3];
      setTimeFromInternetToSystem[8]=device3TimeOff[4];
      setTimeFromInternetToSystem[9]='0';
      Serial.println(setTimeFromInternetToSystem);
      delay(200);
    }
}

void controlDevice(String device, String state){
    String url = "readStateFromSystem";
    url += "?";
    url += device;
    url += "=";
    url += state;
    if (!client.connect(host, httpPort)) { 
      Serial.println("Khong ket noi duoc");
      return;
    }
    client.print(String("GET /") + url +" HTTP/1.1\r\n" +
              "Host: " + host + "\r\n" +
              "Connection: close\r\n\r\n");             
    delay(200);
    //Serial.println("TURN ON"); 
    //delay(500);
}

void sendDataFromSensorToInternet(String type, int value){
    String url;
    if(type == "Temp"){
      url += "readTempFromSystem?temperature=";
      url += value;
    }
    if(type == "Humid"){
      url += "readHumidFromSystem?humid=";
      url += value;
    }
    if(type == "Gas"){
      url += "readGasFromSystem?gasDetection=";
      if(value == 1)
        url += "YES";
      else
        url += "NO";
    }
    if(type == "Human"){
      url += "readHumanFromSystem?humanDetection=";
      if(value == 1)
        url += "YES";
      else
        url += "NO";
    }
    if (!client.connect(host, httpPort)) { 
      Serial.println("Khong ket noi duoc");
      return;
    }
    client.print(String("GET /") + url +" HTTP/1.1\r\n" +
              "Host: " + host + "\r\n" +
              "Connection: close\r\n\r\n");             
    delay(200);
}

void processDataFromSystem(void){
    int Temp, Humid, Gas, Human;
    if(stateFromSystemToInternet[1] == '0'){
       if(stateFromSystemToInternet[2] == '1' && stateFromSystemToInternet[2] != devicesState[2]){
          devicesState[2] = stateFromSystemToInternet[2];
          controlDevice("device1","on");
       }
       if(stateFromSystemToInternet[2] == '0' && stateFromSystemToInternet[2] != devicesState[2]){
          devicesState[2] = stateFromSystemToInternet[2];
          controlDevice("device1","off");
       }
       if(stateFromSystemToInternet[3] == '1' && stateFromSystemToInternet[3] != devicesState[3]){
          devicesState[3] = stateFromSystemToInternet[3];
          controlDevice("device2","on");
       }
       if(stateFromSystemToInternet[3] == '0' && stateFromSystemToInternet[3] != devicesState[3]){
          devicesState[3] = stateFromSystemToInternet[3];
          controlDevice("device2","off");
       }
       if(stateFromSystemToInternet[4] == '1' && stateFromSystemToInternet[4] != devicesState[4]){
          devicesState[4] = stateFromSystemToInternet[4];
          controlDevice("device3","on");
       }
       if(stateFromSystemToInternet[4] == '0' && stateFromSystemToInternet[4] != devicesState[4]){
          controlDevice("device3","off");
          devicesState[4] = stateFromSystemToInternet[4];
       }
    }
    if(stateFromSystemToInternet[2] == '3'){
        if(stateFromSystemToInternet[9] == 'T'){
          Temp = (stateFromSystemToInternet[7]-48)*10 + (stateFromSystemToInternet[8]-48);
          sendDataFromSensorToInternet("Temp",Temp);
        }
        if(stateFromSystemToInternet[9] == 'H'){
          Humid = (stateFromSystemToInternet[7]-48)*10 + (stateFromSystemToInternet[8]-48);
          sendDataFromSensorToInternet("Humid",Humid);
        }
        if(stateFromSystemToInternet[9] == 'M'){
          Human = (stateFromSystemToInternet[7]-48)*10 + (stateFromSystemToInternet[8]-48);
          sendDataFromSensorToInternet("Human",Human);
        }
        if(stateFromSystemToInternet[9] == 'G'){
          Gas = (stateFromSystemToInternet[7]-48)*10 + (stateFromSystemToInternet[8]-48);
          sendDataFromSensorToInternet("Gas",Gas);
        }
    }
}

