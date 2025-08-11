import 'package:flutter_test/flutter_test.dart';
import 'package:h_smart/features/Hospital/domain/entities/DefaultHospitalResponse.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/Hospital/domain/states/hospitalStates.dart';

void main() {
  group('Default Hospital Integration Tests', () {
    test('DefaultHospitalResponse should parse JSON correctly', () {
      // Sample JSON response based on the provided API structure
      final jsonResponse = {
        "error": false,
        "message": "Default hospital retrieved successfully",
        "payload": {
          "hospitals": [
            {
              "id": "hospital-123",
              "hospital_name": "General Hospital",
              "street": "123 Main St",
              "phone": "+1234567890",
              "email": "info@generalhospital.com",
              "ownershiptype": "public",
              "is_default": true,
              "facilities": ["Emergency", "ICU"],
              "total_beds": 100,
              "icu_beds": 20
            }
          ],
          "summary": {
            "has_default": true,
            "total_connected": 1,
            "default_hospital": null
          }
        }
      };

      final response = DefaultHospitalResponse.fromJson(jsonResponse);

      expect(response.error, false);
      expect(response.message, "Default hospital retrieved successfully");
      expect(response.payload, isNotNull);
      expect(response.payload!.hospitals.length, 1);

      final hospital = response.payload!.hospitals.first;
      expect(hospital.id, "hospital-123");
      expect(hospital.hospitalName, "General Hospital");

      expect(hospital.totalBeds, 100);
    });

    test('DefaultHospitalResult should handle different states correctly', () {
      // Test loading state
      final loadingResult = DefaultHospitalResult(
        DefaultHospitalResultStates.isLoading,
        DefaultHospitalResponse(error: true, message: ''),
      );
      expect(loadingResult.isLoading, true);
      expect(loadingResult.isData, false);
      expect(loadingResult.isError, false);

      // Test data state
      final dataResult = DefaultHospitalResult(
        DefaultHospitalResultStates.isData,
        DefaultHospitalResponse(
          error: false,
          message: "Success",
          payload: DefaultHospitalPayload(
            hospitals: [],
            summary:
                DefaultHospitalSummary(hasDefault: false, totalConnected: 0),
          ),
        ),
      );
      expect(dataResult.isData, true);
      expect(dataResult.isLoading, false);
      expect(dataResult.isError, false);

      // Test error state
      final errorResult = DefaultHospitalResult(
        DefaultHospitalResultStates.isError,
        DefaultHospitalResponse(error: true, message: "Error occurred"),
      );
      expect(errorResult.isError, true);
      expect(errorResult.isLoading, false);
      expect(errorResult.isData, false);
    });

    test('DefaultHospital should handle optional fields correctly', () {
      final hospital = Hospital(
        id: "test-id",
        hospitalName: "Test Hospital",
        street: "Test Street",
        phone: "123456789",
        email: "test@hospital.com",
        ownershiptype: "private",
        facilities: ["Emergency"],
        totalBeds: 50,
        icuBeds: 10,
      );

      expect(hospital.id, "test-id");
      expect(hospital.hospitalName, "Test Hospital");

      expect(hospital.totalBeds, 50);
    });
  });
}
