// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:osappw/Initialize/startup.dart';
import 'package:osappw/services/config.dart';


void main() {
  test('Load Config', () async{
    List<bool> setting = [false,false,true];
    Config configO = new Config();
    await configO.loadSettings();
    var config = configO.settings;
    expect(config, setting);
  });
//  testWidgets('Load App ', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(StartUp());
//
//
//    // Verify that our counter starts at 0.
//
//  });
}
