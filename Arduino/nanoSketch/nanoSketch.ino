// This is a test sketch to use the IMU on board the Arduino Nano 33 BLE

#include <Arduino_LSM9DS1.h>
#include <ArduinoBLE.h>

BLEService imuService("26548447-3cd0-4460-b683-43b332274c2b");
BLECharacteristic imuCharacteristic("20831a75-7aaf-4284-888f-47c41dc6b976", BLERead | BLENotify, 600);


String generateAccelerometerJSON()
{
  float x,y,z;
  if (IMU.accelerationAvailable()) 
  {
    IMU.readAcceleration(x, y, z);
  }
  else
  {
    return String("accelerometer reading error");
  }

  String toReturn = "x:" + String(x) + ",y:" + String(y) + ",z:" + String(z);
  return toReturn;
}

String generateGyroscopeJSON()
{
  float x,y,z;
  if (IMU.gyroscopeAvailable()) 
  {
    IMU.readGyroscope(x, y, z);
  }
  else
  {
    return String("gyroscope reading error");
  }

  String toReturn = "x:" + String(x) + ",y:" + String(y) + ",z:" + String(z);
  return toReturn;
}

String generateMagnetometerJSON()
{
  float x,y,z;
  if (IMU.magneticFieldAvailable()) 
  {
    IMU.readMagneticField(x, y, z);
  }
  else
  {
    return String("gyroscope reading error");
  }

  String toReturn = "x:" + String(x) + ",y:" + String(y) + ",z:" + String(z);
  return toReturn;
}

String generateJSONString()
{
  String toReturn = ("{\nt:" + String(millis()));
  // Add accelerometer values
  toReturn += ",\na:{" + generateAccelerometerJSON() + "}";
  // Add gyroscope values
  toReturn += ",\ng:{" + generateGyroscopeJSON() + "}";
  // Add magnetometer values
  toReturn += ",\nm:{" + generateMagnetometerJSON() + "}";

  toReturn += "\n}";

  return toReturn;
}

void setup() 
{
  // put your setup code here, to run once:

  Serial.begin(9600);
  
  // setup the IMU
  if (!IMU.begin()) 
  {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }

  // begin BLE
  if (!BLE.begin())
  {
    Serial.println("starting BLE failed");
    while(1);
  }

  BLE.setLocalName("MITS Mark 1");
  BLE.setAdvertisedService(imuService);

  imuService.addCharacteristic(imuCharacteristic);
  BLE.addService(imuService);

  imuCharacteristic.writeValue("");
  // start advertising
  BLE.advertise();

  Serial.println("Bluetooth device active, waiting for connections...");
  
}

void loop()
{

  // wait for a BLE central
  BLEDevice central = BLE.central();

  // if a central is connected to the peripheral:
  if (central) 
  {
    Serial.println("Connected to central");
    while (central.connected())
    {
      Serial.println("Writing message to central");
      long time = millis();
      Serial.println(time);
      imuCharacteristic.writeValue(generateJSONString().c_str());
      delay(100);
    }
    
  }
  
  
//  float x, y, z;
//


}
