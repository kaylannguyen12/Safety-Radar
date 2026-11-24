#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Servo.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64

#define TRIG 32
#define ECHO 33
#define SERVO_PIN 9

#define NUM_ANGLES 23

#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Servo.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64

#define TRIG 32
#define ECHO 33
#define SERVO_PIN 9

#define MAX_DISTANCE 100
#define ANGLE_STEP 4

#define BLOCK_DISTANCE_LIMIT 25

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);
Servo radarServo;

float getDistance() {

  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);

  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);

  long duration = pulseIn(ECHO, HIGH, 30000);

  if (duration == 0) {
    return -1;
  }

  return duration * 0.0343 / 2.0;
}

void drawOLEDInfo(int angle, float dist) {
  display.clearDisplay();

  display.setTextSize(1);
  display.setTextColor(WHITE);

  display.setCursor(0, 0);
  display.print("SAFETY RADAR");

  display.drawLine(0, 10, 127, 10, WHITE);

  display.setCursor(0, 18);
  display.print("ANGLE: ");
  display.print(angle);
  display.print((char)247);

  display.setCursor(0, 32);
  display.print("DIST: ");

  if (dist < 0) {
    display.print("--");
  } else {
    display.print(dist, 0);
    display.print(" cm");
  }

  display.setCursor(0, 48);

  if (dist > 0 && dist <= BLOCK_DISTANCE_LIMIT) {
    display.print("STATUS: DANGER");
  } else {
    display.print("STATUS: SAFE");
  }

  display.display();
}

void scanAtAngle(int angle) {

  radarServo.write(angle);

  delay(60);

  float d = getDistance();

  // Send data to Processing radar
  Serial.print(angle);
  Serial.print(",");
  Serial.println(d);

  // OLED status display
  drawOLEDInfo(angle, d);
}

void setup() {

  Serial.begin(9600);

  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);

  radarServo.attach(SERVO_PIN);

  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    while (true);
  }

  display.clearDisplay();
  display.display();
}

void loop() {

  for (int angle = 0; angle <= 180; angle += ANGLE_STEP) {
    scanAtAngle(angle);
  }

  for (int angle = 180; angle >= 0; angle -= ANGLE_STEP) {
    scanAtAngle(angle);
  }
}
