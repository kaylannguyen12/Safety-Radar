# Safety-Radar
Real-time object detection and radar visualization system built with Arduino Mega, HC-SR04 ultrasonic sensor, servo motors, OLED display, C++, and Processing.

## Project Overview

Safety Radar is an Arduino-based proximity detection system designed to detect nearby obstacles and provide real-time visual feedback. The system integrates ultrasonic sensing, servo-controlled scanning, an OLED display, and a graphical radar interface developed in Processing.

The project demonstrates hardware-software integration, embedded systems programming, serial communication, and real-time data visualization.

## Features

- Automated 180° scanning with 4° increments
- Real-time ultrasonic distance measurements
- Live graphical radar visualization
- Dynamic obstacle detection and mapping
- Persistent visualization of detected obstacles until rescanned
- SAFE and DANGER proximity indicators
- Configurable obstacle detection threshold
- OLED display with real-time angle, distance, and safety status
- Serial communication between Arduino and Processing

## Technologies Used

### Software
- C/C++ — Arduino programming
- Java — Processing visualization
- Arduino IDE
- Processing IDE
- Serial Communication (9600 baud)

### Hardware
- Arduino Mega
- Ultrasonic distance sensor
- Servo motor
- 128 × 64 SSD1306 OLED display
- Breadboard and jumper wires

### Libraries
- Wire
- Adafruit GFX
- Adafruit SSD1306
- Servo
- Processing Serial

## How It Works

1. The servo motor rotates the ultrasonic sensor between 0° and 180°.
2. The ultrasonic sensor measures the distance of nearby objects using the travel time of sound waves.
3. The Arduino processes the measurements and transmits angle and distance data to Processing through serial communication.
4. Processing converts the incoming data into a real-time graphical radar visualization.
5. Objects detected within 25 cm are highlighted as blocked areas in red.
6. The OLED display and Processing interface provide live distance, angle, and safety status updates.
7. Previously detected obstacles remain visible until their corresponding angles are scanned again.

## Safety Indicators

| Status | Condition |
|--------|-----------|
| SAFE | No obstacle detected within the configured threshold |
| DANGER | Obstacle detected within 25 cm |

## Hardware Connections

| Component | Arduino Connection |
|-----------|-------------------|
| Ultrasonic Trigger | Digital Pin 32 |
| Ultrasonic Echo | Digital Pin 33 |
| Servo Signal | Digital Pin 9 |
| OLED SDA | SDA |
| OLED SCL | SCL |

The OLED display communicates through I2C using address `0x3C`.

## Repository Structure

    Safety-Radar/
    ├── Arduino/
    │   └── SafetyRadar/
    │       └── SafetyRadar.ino
    ├── Processing/
    │   └── RadarVisualization/
    │       └── RadarVisualization.pde
    └── README.md

## Setup Instructions

### Arduino

1. Install the Arduino IDE.
2. Install the required Arduino libraries.
3. Connect the hardware components.
4. Open `SafetyRadar.ino`.
5. Select the appropriate Arduino board and serial port.
6. Upload the sketch to the Arduino.

### Processing

1. Install Processing.
2. Open `RadarVisualization.pde`.
3. Update the serial port in the code to match your connected Arduino.
4. Ensure the baud rate is set to 9600.
5. Close the Arduino Serial Monitor if it is open.
6. Run the Processing sketch to launch the radar visualization.

## Technical Concepts

- Embedded Systems
- Hardware-Software Integration
- Sensor Data Acquisition
- Serial Communication
- Real-Time Data Processing
- Object Detection
- Polar Coordinate Visualization
- I2C Communication
- Human-Machine Interface (HMI)

## Future Improvements

- Adjustable proximity detection through the graphical interface
- Audible proximity alerts
- Historical sensor data logging
- Expanded obstacle detection coverage
- Improved obstacle mapping and filtering

## Project Demo

A live demonstration of the Safety Radar system, showcasing
ultrasonic obstacle detection, servo-controlled scanning,
OLED feedback, and real-time radar visualization.

https://drive.google.com/file/d/1B4K5wLDzs1ugG_q6tnvRbSWWBqbQ6GNg/view?usp=sharing

## Disclaimer

This project is an educational prototype and is not intended to replace certified safety or collision avoidance systems.
