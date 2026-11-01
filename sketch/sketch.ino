#include <Wire.h>
#include <Arduino_RouterBridge.h>

void writeRegister(uint8_t reg, uint8_t val) {
  Wire.beginTransmission(0x74);
  uint8_t data[] = {reg, val};
  Wire.write(data, sizeof data);
  Wire.endTransmission();
}

void clearFrame(uint8_t frame) {
  writeRegister(0xFD, frame);

  for (uint8_t reg = 0x00; reg <= 0x11; reg++) {
    writeRegister(reg, 0x00);
  }

  // set PWM registers
  for (uint8_t reg = 0x24; reg <= 0xB3; reg++) {
    // writeRegister(reg, 0x7F);
    writeRegister(reg, 0x32);
  }
}

void displayFrame(uint8_t frame) {
  writeRegister(0xFD, 0x0B);
  writeRegister(0x01, frame);
}

void setRegister(uint8_t page, uint8_t reg, uint8_t val) {
  writeRegister(0xFD, page);
  writeRegister(reg, val);
}

void setup() {
  Bridge.begin();
  Wire.begin();

  // power off
  writeRegister(0xFD, 0x0B);
  writeRegister(0x0A, 0);

  clearFrame(0);
  clearFrame(1);

  // power on
  writeRegister(0xFD, 0x0B);
  writeRegister(0x0A, 1);

  Bridge.provide("displayFrame", displayFrame);
  Bridge.provide("clearFrame", clearFrame);
  Bridge.provide("setRegister", setRegister);
}

void loop() {}

