import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/connectedHospitalDoctors.dart';

void main() {
  group('ConnectedHospitalDoctorsPage Tests', () {
    testWidgets('should show browse hospitals message when no hospital connected', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ConnectedHospitalDoctorsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show the browse hospitals message
      expect(find.text('Browse Hospitals'), findsOneWidget);
      expect(find.text('You are not connected to any hospital. Browse hospitals to connect and view their doctors.'), findsOneWidget);
    });

    testWidgets('should show app bar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ConnectedHospitalDoctorsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show the correct app bar title
      expect(find.text('Hospital Doctors'), findsOneWidget);
    });

    testWidgets('should show search bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ConnectedHospitalDoctorsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show search bar
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search doctors...'), findsOneWidget);
    });
  });
}