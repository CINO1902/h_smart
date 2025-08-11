import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/Hospital/domain/repositories/hospitalrepo.dart';
import 'package:http/http.dart' as http;

import 'package:h_smart/features/doctorRecord/domain/entities/DoctorsResponse.dart';
import '../../domain/entities/DefaultHospitalResponse.dart';
import '../../domain/states/hospitalStates.dart';

class GetHospitalProvider extends ChangeNotifier {
  final HospitalRepo hospitalRepo;
  GetHospitalProvider(this.hospitalRepo);

  List<Hospital> hospitalData = [];
  List<Hospital> searchData = [];
  List<Doctor> doctorsData = [];
  String errormessage = '';
  String currentOwnership = '';
  String lastSearchTerm = '';
  int page = 1;
  bool hasMoreData = true;

  HospitalResult hospitalResult =
      HospitalResult(HospitalResultStates.isIdle, GetHospital());
  DoctorResult doctorResult = DoctorResult(
      DoctorResultStates.isIdle, DoctorsResponse(doctors: [], message: ''));
  HospitalResult searchResult =
      HospitalResult(HospitalResultStates.isIdle, GetHospital());
  HospitalResult hospitalResultMore =
      HospitalResult(HospitalResultStates.isIdle, GetHospital());
  ConnectToHospitalResult connectToHospitalResult =
      ConnectToHospitalResult(ConnectToHospitalResultStates.isIdle, '');
  DisconnectFromHospitalResult disconnectFromHospitalResult =
      DisconnectFromHospitalResult(DisconnectFromHospitalResultStates.isIdle, '');
  DefaultHospitalResult defaultHospitalResult =
      DefaultHospitalResult(DefaultHospitalResultStates.isIdle, 
          DefaultHospitalResponse(error: true, message: ''));
  String imagetag = '';
  String imagetag1 = '';
  bool enablehero = false;
  int index1 = 0;

  /// Initial load of all hospitals
  Future<void> getHospital() async {
    hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());
    notifyListeners();

    try {
      final response = await hospitalRepo.getHospital();
      hospitalResult = response;

      if (hospitalResult.state == HospitalResultStates.isData) {
        hospitalData = response.response.payload?.hospitals ?? [];
        print(
            'Hospitals loaded successfully: ${hospitalData.length} hospitals');
        // Initialize pagination data
        final pagination = response.response.payload?.pagination;
        if (pagination != null) {
          page = pagination.currentPage ?? 1;
          hasMoreData = page < (pagination.totalPages ?? 1);
        }
      } else {
        print('Hospital API error: ${response.state}');
        if (response.response.message != null) {
          print('Error message: ${response.response.message}');
        }
      }
    } catch (e) {
      print('Exception in getHospital: $e');
      hospitalResult =
          HospitalResult(HospitalResultStates.isError, GetHospital());
    }

    notifyListeners();
  }

  ///Search for hospital
  Future<void> searchHospital(String search) async {
    if (search == lastSearchTerm) {
      return;
    }

    lastSearchTerm = search;
    searchResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());
    notifyListeners();

    try {
      final response = await hospitalRepo.searchHospital(search);
      searchResult = response;

      if (searchResult.state == HospitalResultStates.isData) {
        searchData = response.response.payload?.hospitals ?? [];
        print(
            'Hospital search successful: ${searchData.length} results for "$search"');
      } else {
        print('Hospital search error: ${response.state}');
        if (response.response.message != null) {
          print('Search error message: ${response.response.message}');
        }
      }
    } catch (e) {
      print('Exception in searchHospital: $e');
      searchResult =
          HospitalResult(HospitalResultStates.isError, GetHospital());
    }

    notifyListeners();
  }

  /// Load more for a specific o  wnership type
  Future<void> getMoreSpecificHospitals(String ownership) async {
    // Reset pagination if switching type
    if (ownership != currentOwnership) {
      currentOwnership = ownership;
      page = 1;
      hasMoreData = true;
    }
    // Prevent duplicate loads
    if (hospitalResultMore.state == HospitalResultStates.isLoading ||
        !hasMoreData) {
      return;
    }

    hospitalResultMore =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());
    notifyListeners();

    try {
      final response =
          await hospitalRepo.getMoreSpecificHospital(ownership, page + 1);
      if (response.state == HospitalResultStates.isData) {
        final newOnes = response.response.payload?.hospitals ?? [];
        // filter out existing
        final filtered = newOnes
            .where((n) => hospitalData.every((e) => e.id != n.id))
            .toList();
        if (filtered.isNotEmpty) {
          hospitalData.addAll(filtered);
          page++;
        }

        // Update pagination data
        final pagination = response.response.payload?.pagination;
        if (pagination != null) {
          hasMoreData = page < (pagination.totalPages ?? 1);
        }

        hospitalResultMore =
            HospitalResult(HospitalResultStates.isData, response.response);
      } else if (response.state == HospitalResultStates.isError) {
        hospitalResultMore =
            HospitalResult(HospitalResultStates.isError, GetHospital());
      } else {
        hospitalResultMore =
            HospitalResult(HospitalResultStates.isEmpty, GetHospital());
        hasMoreData = false;
      }
    } catch (e) {
      errormessage = e.toString();
      hospitalResultMore =
          HospitalResult(HospitalResultStates.isError, GetHospital());
    }

    notifyListeners();
  }

  Future<void> callDoctorsbyhospitalid(hospitalId) async {
    doctorResult = DoctorResult(DoctorResultStates.isLoading,
        DoctorsResponse(doctors: [], message: ''));
    notifyListeners();

    final response = await hospitalRepo.GetDoctorsByHospitalId(hospitalId);
    doctorResult = response;

    if (doctorResult.state == DoctorResultStates.isData) {
      doctorsData = response.response.doctors ?? [];
    }
    notifyListeners();
  }

  Future<void> connectToHospital(String hospitalId) async {
    connectToHospitalResult =
        ConnectToHospitalResult(ConnectToHospitalResultStates.isLoading, '');
    notifyListeners();

    final response = await hospitalRepo.connectToHospital(hospitalId);
    if (response.state == ConnectToHospitalResultStates.isData) {
      hospitalData = hospitalData.map((hospital) {
        if (hospital.id == hospitalId) {
          return hospital.copyWith(isConnected: true);
        }
        return hospital;
      }).toList();
    }

    connectToHospitalResult = response;
    notifyListeners();
  }

  Future<void> disconnectFromHospital(String hospitalId) async {
    disconnectFromHospitalResult =
        DisconnectFromHospitalResult(DisconnectFromHospitalResultStates.isLoading, '');
    notifyListeners();

    final response = await hospitalRepo.disconnectFromHospital(hospitalId);
    if (response.state == DisconnectFromHospitalResultStates.isData) {
      hospitalData = hospitalData.map((hospital) {
        if (hospital.id == hospitalId) {
          return hospital.copyWith(isConnected: false);
        }
        return hospital;
      }).toList();
    }

    disconnectFromHospitalResult = response;
    notifyListeners();
  }

  void disposeTapToConnect() {
    connectToHospitalResult =
        ConnectToHospitalResult(ConnectToHospitalResultStates.isIdle, '');
    notifyListeners();
  }

  void disposeTapToDisconnect() {
    disconnectFromHospitalResult =
        DisconnectFromHospitalResult(DisconnectFromHospitalResultStates.isIdle, '');
    notifyListeners();
  }

  Future<void> getDefaultHospital() async {
    defaultHospitalResult =
        DefaultHospitalResult(DefaultHospitalResultStates.isLoading, 
            DefaultHospitalResponse(error: true, message: ''));
    notifyListeners();

    final response = await hospitalRepo.getDefaultHospital();
    defaultHospitalResult = response;
    notifyListeners();
  }

  Future<void> setDefaultHospital(String hospitalId) async {
    connectToHospitalResult =
        ConnectToHospitalResult(ConnectToHospitalResultStates.isLoading, '');
    notifyListeners();

    final response = await hospitalRepo.setDefaultHospital(hospitalId);
    connectToHospitalResult = response;
    
    // If successful, refresh the default hospital data
    if (response.state == ConnectToHospitalResultStates.isData) {
      await getDefaultHospital();
    }
    
    notifyListeners();
  }
}
