#include <ESP8266WiFi.h>
#include <ArduinoJson.h>
WiFiClient client;

const char* ssid     = "P811";
const char* password = "tumotdenchin";
const char* host = "192.168.100.20";
const int httpPort = 9000;
int updateFlag = 0;
int receiveFromSystemFlag = 0;
int count = 0;
char stateFromInternetToSystem[11];
char stateFromSystemToInternet[11];

void wifiInit(void);
void configState(void);
//System
void receiveDataFromSystem(void);
void processDataFromSystem(void);
//Internet
void checkUpdateFlag(void);
void clearUpdateFlag(void);
void controlDevice(String device, String state);
void readJSONFromStatePage (void);
void sendState(void);


void setup() {
    Serial.begin(9600);
    delay(100);
    wifiInit();
    configState();
    controlDevice("device2","on");
}

void loop() {
    checkUpdateFlag();
    if(updateFlag == 1){
      readJSONFromStatePage();
      clearUpdateFlag();
      updateFlag = 0;
    }
    if(Serial.available() > 0){
       receiveDataFromSystem();
    }
    if(receiveFromSystemFlag == 1){
      receiveFromSystemFlag = 0;
      processDataFromSystem();
    }
}

void wifiInit(void){
    Serial.println("");
    Serial.print("Connecting to ");
    Serial.println(ssid);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    Serial.println("");
    Serial.println("WiFi connected");  
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
    Serial.print("Ket noi toi web ");
    Serial.println(host);
}

void configState(void){
    stateFromInternetToSystem[0]  = 'S';
    stateFromInternetToSystem[1]  = '0';
    stateFromInternetToSystem[2]  = '0';
    stateFromInternetToSystem[3]  = '0';
    stateFromInternetToSystem[4]  = '0';
    stateFromInternetToSystem[5]  = '0';
    stateFromInternetToSystem[6]  = '0';
    stateFromInternetToSystem[7]  = '0';
    stateFromInternetToSystem[8]  = '0';
    stateFromInternetToSystem[9]  = '0';
    stateFromInternetToSystem[10] = 'E';
}


void checkUpdateFlag (void)
{
    if (!client.connect(host, httpPort)) { 
    Serial.println("Khong ket noi duoc");
    return;
    }
    client.print(String("GET /") + "checkChangedFlag" +" HTTP/1.1\r\n" +
              "Host: " + host + "\r\n" +
              "Connection: close\r\n\r\n"); 
    
    unsigned long timeout = millis();
    while (client.available() == 0) {
        if (millis() - timeout > 5000) {
          Serial.println(">>> Client Timeout !");
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
      Serial.println("Khong ket noi duoc");
      return;
    }
    client.print(String("GET /") + clearUpdateFlag +" HTTP/1.1\r\n" +
                "Host: " + host + "\r\n" +
                "Connection: close\r\n\r\n");             
    delay(500);
    //Serial.println("Clear Update Flag from Internet"); 
    //delay(500);
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
    delay(500);
    Serial.println("TURN ON"); 
    //delay(500);
}

void readJSONFromStatePage (void)
{
    if (!client.connect(host, httpPort)) { 
        Serial.println("Khong ket noi duoc");
        return;
    }
    client.print(String("GET /") + "state" +" HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" +
               "Connection: close\r\n\r\n");

    unsigned long timeout = millis();
    while (client.available() == 0) {
        if (millis() - timeout > 5000) {
          Serial.println(">>> Client Timeout !");
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
            Serial.println("Thiet bi 1 ON");
            stateFromInternetToSystem[2]  = '1';
        }
        if (strcmp(json_parsed["device1"], "off") == 0) { 
            Serial.println("Thiet bi 1 OFF");
            stateFromInternetToSystem[2]  = '0';
        }
        if (strcmp(json_parsed["device2"], "on") == 0) { 
            Serial.println("Thiet bi 2 ON");
            stateFromInternetToSystem[3]  = '1';
        }
        if (strcmp(json_parsed["device2"], "off") == 0) { 
            Serial.println("Thiet bi 2 OFF");
            stateFromInternetToSystem[3]  = '0';
            
        }
    }
    Serial.println(stateFromInternetToSystem);
    Serial.println("closing connection");
}

void receiveDataFromSystem(void){
    char data;
    data = Serial.read();
    if(data == 'S'){
      count = 0;
      stateFromSystemToInternet[count] = data;
      count++;
    }
    if(data != 'S' && data != 'E'){
      stateFromSystemToInternet[count] = data;
      count++;
    }
    if(data == 'E'){
      stateFromSystemToInternet[count] = data;
      count = 0;
      receiveFromSystemFlag = 1;
      Serial.println(stateFromSystemToInternet);
    }
}

void processDataFromSystem(void){
    if(stateFromSystemToInternet[1] == '0'){
       if(stateFromSystemToInternet[2] == '1'){
          controlDevice("device1","on");
       }
       if(stateFromSystemToInternet[2] == '0'){
          controlDevice("device1","off");
       }
       if(stateFromSystemToInternet[3] == '1'){
          controlDevice("device2","on");
       }
       if(stateFromSystemToInternet[3] == '0'){
          controlDevice("device2","off");
       }
       if(stateFromSystemToInternet[4] == '1'){
          controlDevice("device3","on");
       }
       if(stateFromSystemToInternet[4] == '0'){
          controlDevice("device3","off");
       }
    }  
}

