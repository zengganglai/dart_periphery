import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_periphery/dart_periphery.dart';

String smiley =
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/4AAAAAAAAAAAAAAAAAAHAAcAAAAAAAAAAAAAAAAAGAAAwAAAAAAAAAAAAAAAAGAAADAAAAAAAAAAAAAAAAGAAAAMAAAAAAAAAAAAAAAGAAAAAwAAAAAAAAAAAAAADAAAAAGAAAAAAAAAAAAAABAAAAAAQAAAAAAAAAAAAAAgAAAAACAAAAAAAAAAAAAAQAMAAwAQAAAAAAAAAAAAAIAHgAeACAAAAAAAAAAAAAEAB4AHgAQAAAAAAAAAAAABAAfAD4AEAAAAAAAAAAAAAgAPwA/AAgAAAAAAAAAAAAQAD8APwAEAAAAAAAAAAAAEAA/AD8ABAAAAAAAAAAAACAAPwA/AAIAAAAAAAAAAAAgAD8APwACAAAAAAAAAAAAQAA/AD8AAQAAAAAAAAAAAEAAPwA/AAEAAAAAAAAAAABAAD8APwABAAAAAAAAAAAAgAA/AD8AAIAAAAAAAAAAAIAAPwA/AACAAAAAAAAAAACAAD8APgAAgAAAAAAAAAAAgAAeAB4AAIAAAAAAAAAAAAAAHgAcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAEAAAAAAAAAAAQAAAAAAAABAAAAAAAAAAAEBwAAAAAPAQAAAAAAAAAABA+AAAAAD8EAAAAAAAAAAAQPAAAAAAOAAAAAAAAAAAAAAwAAAAADAgAAAAAAAAAAAgMAAAAAAwIAAAAAAAAAAAIDAAAAAAYCAAAAAAAAAAACA4AAAAAGAgAAAAAAAAAAAgGAAAAADgIAAAAAAAAAAAEBgAAAAAwEAAAAAAAAAAABAMAAAAAMBAAAAAAAAAAAAQDgAAAAGAQAAAAAAAAAAACAYAAAADgIAAAAAAAAAAAAgHAAAABwCAAAAAAAAAAAAEA4AAAA4BAAAAAAAAAAAABgHAAAAcAwAAAAAAAAAAAAIA4AAAOAIAAAAAAAAAAAADAHgAAPAEAAAAAAAAAAAAAYAeAAPgDAAAAAAAAAAAAACAB8AfgAgAAAAAAAAAAAAAQAH//gAQAAAAAAAAAAAAACAAP/AAIAAAAAAAAAAAAAAQAAAAAEAAAAAAAAAAAAAADAAAAAGAAAAAAAAAAAAAAAYAAAADAAAAAAAAAAAAAAABgAAADAAAAAAAAAAAAAAAAGAAADAAAAAAAAAAAAAAAAA8AAHgAAAAAAAAAAAAAAAAB4APAAAAAAAAAAAAAAAAAAB/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==";

String sadSmiley =
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAHw+AAAAAAAAAAAAAAAAAAOAAcAAAAAAAAAAAAAAAAAMAAAwAAAAAAAAAAAAAAAAGAAAGAAAAAAAAAAAAAAAAGAAAAYAAAAAAAAAAAAAAADAAAADAAAAAAAAAAAAAAABgAAAAIAAAAAAAAAAAAAAAwAAAABAAAAAAAAAAAAAAAYAAAAAYAAAAAAAAAAAAAAEAAAAACAAAAAAAAAAAAAACAAAAAAQAAAAAAAAAAAAABgfAAD4CAAAAAAAAAAAAAAQMIABBAgAAAAAAAAAAAAAIAAAAAAEAAAAAAAAAAAAACAAAAAABAAAAAAAAAAAAAAgHwAA+AAAAAAAAAAAAAAAQCCAAQQCAAAAAAAAAAAAAEAggAEEAgAAAAAAAAAAAABAIEACBAIAAAAAAAAAAAAAQCCAAQQCAAAAAAAAAAAAAEAggAEEAQAAAAAAAAAAAACAHwAA+AEAAAAAAAAAAAAAgAAAAAABAAAAAAAAAAAAAIAAAAAAAQAAAAAAAAAAAACAAAAAAAEAAAAAAAAAAAAAgAAAAAABAAAAAAAAAAAAAEAAAAAAAgAAAAAAAAAAAABAAAAAAAIAAAAAAAAAAAAAQAAAAAACAAAAAAAAAAAAAEAAD/AAAgAAAAAAAAAAAAAAADAMAAIAAAAAAAAAAAAAIABAAgAEAAAAAAAAAAAAACAAgAGABAAAAAAAAAAAAAAQAQAAgAgAAAAAAAAAAAAAEAIAAEAIAAAAAAAAAAAAAAgAAAAAEAAAAAAAAAAAAAAMAAAAADAAAAAAAAAAAAAABAAAAAAgAAAAAAAAAAAAAAIAAAAAQAAAAAAAAAAAAAABAAAAAIAAAAAAAAAAAAAAAIAAAAEAAAAAAAAAAAAAAABgAAAGAAAAAAAAAAAAAAAAMAAADAAAAAAAAAAAAAAAAAwAADAAAAAAAAAAAAAAAAADAADAAAAAAAAAAAAAAAAAAPgPAAAAAAAAAAAAAAAAAAAH8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==";

void main() {
  // Select the right I2C bus number /dev/i2c-?
  // 1 for Raspberry Pi, 0 for NanoPi (Armbian), 2 Banana Pi (Armbian), 4 BPI-F3
  var i2c = I2C(1);
  try {
    print("dart_periphery Version: $dartPeripheryVersion");
    print("c-periphery Version   : ${getCperipheryVersion()}");
    print('I2C info: ${i2c.getI2Cinfo()}');

    var oled = SSD1306(i2c);

    oled.clear();

    Uint8List dataSmiley = base64.decode(smiley);
    Uint8List dataSadSmiley = base64.decode(sadSmiley);

    int index = 0;
    while (true) {
      oled.displayBitmap(index % 2 == 0 ? dataSmiley : dataSadSmiley);
      sleep(Duration(milliseconds: 1500));
      ++index;
    }
  } finally {
    i2c.dispose();
  }
}
