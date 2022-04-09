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

String getFlexString()
{
    String toReturn = "";
    toReturn += "{\"f1\":" + getFlexValue(FINGER1) + ", \"f2\":" + getFlexValue(FINGER2) + ", \"f3\":" + getFlexValue(FINGER3) + ", \"f4\":" + getFlexValue(FINGER4) +"}";
    return toReturn;
}

void setup()
{
    pinMode(FINGER1, OUTPUT);
    pinMode(FINGER2, OUTPUT);
    pinMode(FINGER3, OUTPUT);
    pinMode(FINGER4, OUTPUT);
}

void loop()
{
    Serial.print(getFlexString());
    delay(50);
}
