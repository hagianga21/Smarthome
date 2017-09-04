#include <ESP8266WiFi.h>
#include <ArduinoJson.h>
WiFiClient client;
const char* ssid     = "P811";
const char* password = "tumotdenchin";

const char* host = "192.168.100.20";
const int httpPort = 9000;

String url = "device1";
String url1 = "readStateFromSystem";

int updateFlag = 0;

void loginHomePage(void);
void checkUpdateFlag(void);
void clearUpdateFlag(void);
void controlDevice(String device, String state);
void readJSONFromStatePage (void);
void sendState(void);
void setup() {
    Serial.begin(115200);
    delay(10);
    url1 += "?device1=";
    url1 += "on";
    // We start by connecting to a WiFi network
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
    
    controlDevice("device2","on");
}

void loop() {
    checkUpdateFlag();
    if(updateFlag == 1){
      readJSONFromStatePage();
      clearUpdateFlag();
      updateFlag = 0;
    }
}

void loginHomePage(void){
    String login = "logincheckNodeMCU?username=giang&password=admin";
    if (!client.connect(host, httpPort)) { 
      Serial.println("Khong ket noi duoc");
      return;
    }
    client.print(String("GET /") + login +" HTTP/1.1\r\n" +
                "Host: " + host + "\r\n" +
                "Connection: close\r\n\r\n");             
    delay(500);
    Serial.println("LOGIN OK"); 
    delay(500);
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
    Serial.println("Clear Update Flag from Internet"); 
    delay(500);
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
    delay(500);
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
        }
        if (strcmp(json_parsed["device1"], "off") == 0) { 
            Serial.println("Thiet bi 1 OFF");
        }
    }
    Serial.println("closing connection");
}

void sendState(void){
  if (!client.connect(host, httpPort)) { 
    Serial.println("Khong ket noi duoc");
    return;
  }
  client.print(String("GET /") + url1 +" HTTP/1.1\r\n" +
              "Host: " + host + "\r\n" +
              "Connection: close\r\n\r\n");             
  delay(500);
  Serial.println("OK"); 
  delay(500);
}

