// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// https://github.com/adafruit/Adafruit_CircuitPython_PCF8591/blob/main/adafruit_pcf8591/pcf8591.py
// https://github.com/ShuDiamonds/PCF8591/blob/master/PCF8591.py
// https://www.waveshare.com/wiki/Raspberry_Pi_Tutorial_Series:_PCF8591_AD/DA
// https://cdn-learn.adafruit.com/downloads/pdf/adafruit-pcf8591-adc-dac.pdf

import 'package:dart_periphery/dart_periphery.dart';

/// [PCF8591] pins
enum Pin { a0, a1, a2, a3 }

/// Default I2C address of the [PCF8591] ADC
const int pcf8591DefaultI2Caddress = 0x48;

/// [PCF8591] exception
class PCF8591exception implements Exception {
  final String errorMsg;
  @override
  String toString() => errorMsg;

  PCF8591exception(this.errorMsg);
}

const pcf8591lowerLimit = 2.5;
const pcf8591UpperLimit = 6.0;
const pcf8591enableDAC = 0x40;

class PCF8591 {
  final I2C i2c;
  final int i2cAddress;
  late final double referenceVoltage;
  bool _dacEnabled = false;
  int _dac = 0;

  PCF8591(this.i2c,
      [double refVoltage = 3.3, this.i2cAddress = pcf8591DefaultI2Caddress]) {
    if (refVoltage <= pcf8591lowerLimit || refVoltage >= pcf8591UpperLimit) {
      throw PCF8591exception("Reference voltage must be from 2.5 - 6.0");
    }
    referenceVoltage = refVoltage;
  }

  List<int> _halfRead(Pin pin) {
    var data = [0, 0];
    if (_dacEnabled) {
      data[0] = pcf8591enableDAC;
      data[1] = _dac;
    }
    data[0] |= pin.index;
    i2c.writeBytes(i2cAddress, data);
    return i2c.readBytes(i2cAddress, 2);
  }

  /// Reads a 8 bit value from a [pin].
  int read(Pin pin) {
    _halfRead(pin); // dummy read
    return _halfRead(pin)[1];
  }

  /// Enables/disables the DAC (Digital Analog Converter).
  void setDAC(bool flag) {
    _dacEnabled = flag;
    List<int> data;
    if (flag) {
      data = [pcf8591enableDAC, _dac];
    } else {
      data = [0, 0];
    }
    i2c.writeBytes(i2cAddress, data);
    i2c.readBytes(i2cAddress, 2);
  }

  /// Is DAC enabled?
  bool getDAC() {
    return _dacEnabled;
  }

  /// Writes a 8-bit [value] to the DAC (Digital Analog Converter) on pin 0.
  void write(int value) {
    if (value < 0 || value > 255) {
      throw PCF8591exception("8-bit DAC - valid range: [0,255]");
    }
    if (!_dacEnabled) {
      throw PCF8591exception("DAC support is not enabled");
    }

    var data = [pcf8591enableDAC, value];
    _dac = value;
    i2c.writeBytes(i2cAddress, data);
    i2c.readBytes(i2cAddress, 2);
  }
}
