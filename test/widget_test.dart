// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medicrush/main.dart';

void main() {
  testWidgets('MediCrush app displays logo and navigation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MediCrushApp());

    // Verify that the MediCrush logo text is present.
    expect(find.text('MediCrush'), findsOneWidget);

    // Verify that the search input field is present.
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the bottom navigation bar items are present.
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
