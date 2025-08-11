import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/Hospital/presentation/pages/hospitalDetailView.dart';

void main() {
  group('HospitalDetailView Tests', () {
    late Hospital connectedHospital;
    late Hospital disconnectedHospital;

    setUp(() {
      connectedHospital = Hospital(
        id: '1',
        hospitalName: 'Test Hospital',
        isConnected: true,
        city: 'Test City',
        country: 'Test Country',
      );

      disconnectedHospital = Hospital(
        id: '2',
        hospitalName: 'Test Hospital 2',
        isConnected: false,
        city: 'Test City 2',
        country: 'Test Country 2',
      );
    });

    testWidgets('should show connection required message when not connected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HospitalDetailView(
              hospital: disconnectedHospital,
              homeref: ref,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show connection required message
      expect(find.text('Connect to View Doctors'), findsOneWidget);
      expect(
          find.text(
              'Please connect to this hospital to view the list of doctors and their information.'),
          findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should show doctors section when connected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HospitalDetailView(
              hospital: connectedHospital,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show doctors section (even if loading or empty)
      expect(find.text('Doctors'), findsOneWidget);
      // Should not show connection required message
      expect(find.text('Connect to View Doctors'), findsNothing);
    });

    testWidgets('should display correct hospital information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HospitalDetailView(
              hospital: connectedHospital,
              homeref: ref,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display hospital name
      expect(find.text('Test Hospital'), findsOneWidget);
    });
  });
}