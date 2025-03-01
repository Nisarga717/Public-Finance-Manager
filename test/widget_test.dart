import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_manager/main.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FinanceApp());

    // Check if the title "Finance Manager" is present
    expect(find.text('Finance Manager'), findsOneWidget);
  });
}
