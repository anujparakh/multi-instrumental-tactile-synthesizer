#define ANALOG_PIN A0
#define FINGER1 0
#define FINGER2 1
#define FINGER3 2
#define FINGER4 3


// digital write to HIGH and read a flex sensor
String getFlexValue(int flexNumber)
{
    digitalWrite(flexNumber, HIGH);
    int toReturn = analogRead(ANALOG_PIN);
    digitalWrite(flexNumber, LOW);
    return String(toReturn);
}

String getDataString()
{
    AccelerationReading acceleration = Bean.getAcceleration();

    String toReturn = "";
    toReturn += "{\"f1\":" + getFlexValue(FINGER1) + ", \"f2\":" + getFlexValue(FINGER2) + ", \"f3\":" + getFlexValue(FINGER3) + ", \"f4\":" + getFlexValue(FINGER4);
    toReturn = toReturn + ",\"aX\":" + acceleration.xAxis + ", \"aY\": " + acceleration.yAxis + ",\"aZ\": " + acceleration.zAxis;
    toReturn += "}";
    return toReturn; 
}

void setup()
{
    pinMode(FINGER1, OUTPUT);
    pinMode(FINGER2, OUTPUT);
    pinMode(FINGER3, OUTPUT);
    pinMode(FINGER4, OUTPUT);

    Bean.enableWakeOnConnect(true);
}

bool connected;

void loop()
{
    connected = Bean.getConnectionState();
    if(connected)
    {
        Serial.print(getDataString());
        delay(50);
    }
}
