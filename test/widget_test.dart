import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nome_app/main.dart';
import 'package:nome_app/constants.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the main title is displayed
    expect(find.text(AppConstants.titoloApp), findsOneWidget);
    
    // Verify that the cycle selection button is present
    expect(find.text(AppConstants.scegliDataCiclo), findsOneWidget);
  });

  testWidgets('Date picker opens when button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    
    // Tap the date selection button
    await tester.tap(find.text(AppConstants.scegliDataCiclo));
    await tester.pumpAndSettle();
    
    // Verify that date picker dialog appears
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
  
  testWidgets('Calendar shows grid layout when cycle is set', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    
    // Simulate setting a cycle date
    await tester.tap(find.text(AppConstants.scegliDataCiclo));
    await tester.pumpAndSettle();
    
    // Tap OK on date picker (assuming today's date)
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    
    // Verify that GridView is present
    expect(find.byType(GridView), findsOneWidget);
    
    // Verify that legend is present
    expect(find.text('Legenda Umore'), findsOneWidget);
  });
}
