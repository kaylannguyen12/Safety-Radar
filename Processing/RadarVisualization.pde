import processing.serial.*;

Serial myPort;

int currentAngle = 0;
float currentDistance = -1;

float[] blockedDistance = new float[181];
boolean[] blocked = new boolean[181];

float MAX_DISTANCE = 55;
float BLOCK_DISTANCE_LIMIT = 25; // lower this if walls get detected

void setup() {
  size(1200, 700);
  smooth();

  myPort = new Serial(this, "/dev/cu.usbmodem14101", 9600);
  myPort.bufferUntil('\n');

  for (int i = 0; i < 181; i++) {
    blocked[i] = false;
    blockedDistance[i] = -1;
  }
}

void draw() {
  background(0);

  drawRadar();
  drawBlockedAreas();   // red areas are drawn from memory
  drawSweepLine();      // green line moves by itself
  drawText();
}

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');

  if (data == null) return;

  data = trim(data);
  String[] values = split(data, ',');

  if (values.length == 2) {
    currentAngle = int(values[0]);
    currentDistance = float(values[1]);

    updateBlockedMap(currentAngle, currentDistance);
  }
}

void updateBlockedMap(int angle, float distance) {
  if (angle < 0 || angle > 180) return;

  // If object is close enough, mark this angle blocked
  if (distance > 0 && distance <= BLOCK_DISTANCE_LIMIT) {
    blocked[angle] = true;
    blockedDistance[angle] = distance;
  } 
  // If nothing close at this angle, clear this angle
  else {
    blocked[angle] = false;
    blockedDistance[angle] = -1;
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - 70);

  stroke(98, 245, 31);
  strokeWeight(2);
  noFill();

  arc(0, 0, 1000, 1000, PI, TWO_PI);
  arc(0, 0, 750, 750, PI, TWO_PI);
  arc(0, 0, 500, 500, PI, TWO_PI);
  arc(0, 0, 250, 250, PI, TWO_PI);

  line(-500, 0, 500, 0);

  for (int a = 0; a <= 180; a += 30) {
    float x = cos(radians(a)) * 500;
    float y = -sin(radians(a)) * 500;
    line(0, 0, x, y);
  }

  popMatrix();
}

void drawBlockedAreas() {
  pushMatrix();
  translate(width / 2, height - 70);

  noStroke();
  fill(255, 0, 0, 120);

  for (int a = 0; a <= 180; a++) {
    if (blocked[a] && blockedDistance[a] > 0) {

      float r = map(blockedDistance[a], 0, MAX_DISTANCE, 0, 500);

      float startA = radians(a - 2);
      float endA = radians(a + 2);

      beginShape();
      vertex(0, 0);

      for (float theta = startA; theta <= endA; theta += 0.02) {
        float x = cos(theta) * r;
        float y = -sin(theta) * r;
        vertex(x, y);
      }

      endShape(CLOSE);
    }
  }

  popMatrix();
}

void drawSweepLine() {
  pushMatrix();
  translate(width / 2, height - 70);

  stroke(30, 250, 60);
  strokeWeight(4);

  float x = cos(radians(currentAngle)) * 500;
  float y = -sin(radians(currentAngle)) * 500;

  line(0, 0, x, y);

  popMatrix();
}

void drawText() {
  fill(0);
  noStroke();
  rect(0, height - 60, width, 60);
  rect(20, 20, 300, 90);

  fill(98, 245, 31);
  textSize(32);
  text("Safety Radar", 25, height - 20);

  textSize(24);
  text("Angle: " + currentAngle + "°", 420, height - 22);

  if (currentDistance < 0) {
    text("Distance: --", 620, height - 22);
  } else {
    text("Distance: " + nf(currentDistance, 0, 1) + " cm", 620, height - 22);
  }

  if (currentDistance > 0 && currentDistance <= BLOCK_DISTANCE_LIMIT) {
    fill(255, 0, 0);
    textSize(36);
    text("DANGER", 45, 75);
  } 
  else {
    fill(98, 245, 31);
    textSize(36);
    text("SAFE", 45, 75);
  }
}
