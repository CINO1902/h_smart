import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:h_smart/features/Hospital/domain/entities/Doctor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/Hospital/domain/repositories/hospitalrepo.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/DoctorsResponse.dart';
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

  String imagetag = '';
  String imagetag1 = '';
  bool enablehero = false;
  int index1 = 0;
  List clickedHospital = [];

  /// Initial load of all hospitals
  Future<void> getHospital() async {
    hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());
    notifyListeners();

    final response = await hospitalRepo.getHospital();
    hospitalResult = response;

    if (hospitalResult.state == HospitalResultStates.isData) {
      hospitalData = response.response.payload?.hospitals ?? [];
      // Initialize pagination data
      final pagination = response.response.payload?.pagination;
      if (pagination != null) {
        page = pagination.currentPage ?? 1;
        hasMoreData = page < (pagination.totalPages ?? 1);
      }
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

    final response = await hospitalRepo.searchHospital(search);
    searchResult = response;

    if (searchResult.state == HospitalResultStates.isData) {
      searchData = response.response.payload?.hospitals ?? [];
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
}
