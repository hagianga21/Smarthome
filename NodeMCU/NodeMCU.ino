#include <ESP8266WiFi.h>
#include <ArduinoJson.h>

const char* ssid     = "P811";
const char* password = "tumotdenchin";

const char* host = "192.168.100.20";

String url = "device1";
void setup() {
  Serial.begin(115200);
  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.println();
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
  WiFiClient client;
  const int httpPort = 9000;
  
  
  //Control Led
  if (!client.connect(host, httpPort)) { 
    Serial.println("Khong ket noi duoc");
    return;
  }
  client.print(String("POST /") + url +" HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" +
               "Connection: close\r\n\r\n");             
  delay(500);
  Serial.println("OK"); 
  delay(500);

  //ReadJSON
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

void loop() {
;
}

