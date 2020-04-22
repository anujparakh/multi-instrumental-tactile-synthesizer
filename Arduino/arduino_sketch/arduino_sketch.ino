//#include <Arduino_LSM9DS1.h> // For Arduino Stuff
#include <ArduinoBLE.h> // For BLE Stuff
// Set constants for flex analog inputs
#define FINGER_1 A0
#define FINGER_2 A1
#define FINGER_3 A2
#define FINGER_4 A3
#define FINGER_5 A4 // Right hand only

BLEService theService("26548447-3cd0-4460-b683-43b332274c2b"); // LEFT HAND
//BLEService theService("26548447-3cd0-4460-b683-43b332274c2c"); // RIGHT HAND
//BLECharacteristic imuCharacteristic("20831a75-7aaf-4284-888f-47c41dc6b976", BLERead | BLENotify, 512);
BLECharacteristic flexCharacteristic("43b513cf-08aa-4bd9-bc58-3f626a4248d8", BLERead | BLENotify, 512);


String getFlexValuesString()
{
  String toReturn = "{\"t\":" + String(millis()) +",";
  toReturn += "\"f1\":" + String(analogRead(FINGER_1)) + ",";
  toReturn += "\"f2\":" + String(analogRead(FINGER_2)) + ",";
  toReturn += "\"f3\":" + String(analogRead(FINGER_3)) + ",";
  toReturn += "\"f4\":" + String(analogRead(FINGER_4)) + ",";
  toReturn += "\"fs\":" + String(analogRead(FINGER_5)) + "}";
  return toReturn;
}

void niceDelay(long delayTime)
{
  delay(delayTime);
}


// Called once when sketch is loaded
void setup() 
{
  Serial.begin(9600);
  
  // begin BLE
  if (!BLE.begin())
  {
    Serial.println("starting BLE failed");
    while(1);
  }

  BLE.setLocalName("MITS Mark 2");
  BLE.setAdvertisedService(theService);

//  theService.addCharacteristic(imuCharacteristic);
  theService.addCharacteristic(flexCharacteristic);
  BLE.addService(theService);

  // start advertising
  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");

  
}

// Runs repeatedly
void loop() 
{ 
  BLEDevice central = BLE.central();

  // check if central is found
  if (central)
  {
    Serial.println("Connected to a central!");
    while (central.connected())
    {
      long time = millis();
      flexCharacteristic.writeValue(getFlexValuesString().c_str());
      niceDelay(100);
    }
  }
}
