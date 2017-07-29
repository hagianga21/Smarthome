#include <ESP8266WiFi.h>

const char* ssid     = "P811";
const char* password = "tumotdenchin";

const char* host = "192.168.100.20";

String url = "/process_get?";
void setup() {
  Serial.begin(115200);
  delay(10);
  // We start by connecting to a WiFi network
  url += "first_name";
  url += "def";
  url += "\r\n";
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
  const int httpPort = 3000;
  if (!client.connect(host, httpPort)) { 
    Serial.println("Khong ket noi duoc");
    return;
  }

  client.print(String("GET /process_get?first_name=") + "def" +" HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" +
               "Connection: close\r\n\r\n");
  delay(500);
  Serial.println("OK"); 
  /*
  while (client.available()) {
    String line = client.readStringUntil('\R');
    Serial.print(line);
  }
  Serial.println();
  */
  
}



void loop() {
;
}

