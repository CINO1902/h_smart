import 'package:flutter/material.dart';
import 'package:h_smart/features/medical_record/domain/entities/prescription.dart';
import 'package:h_smart/features/medical_record/domain/repositories/MedicalRecord_repo.dart';

class MedicalRecordprovider extends ChangeNotifier {
  final MedicalRecordRepo medicalRecordRepo;

  MedicalRecordprovider(this.medicalRecordRepo);

  bool loading = true;
  bool error = false;
  bool currentempty = false;
  List<Datum> pres = [];
  String clickdoctordescription = '';
  DoctorName clickeddoctorcategory = DoctorName(
      id: '',
      user: User(email: '', id: ''),
      docProfilePicture: '',
      firstName: '',
      lastName: '',
      phoneNumber: '',
      bio: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      hospital: Hospital(
        address: '',
        name: '',
        id: '',
        city: '',
        state: '',
        coverImage: null,
        type: '',
        country: '',
        phoneNumber: '',
        email: '',
        website: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      specialization: Specializations(
          id: '',
          name: '',
          description: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()),
      couldinaryFileField: '');
  Future<void> getprescription() async {
    final response = await medicalRecordRepo.getprescription();

    loading = false;
    if (response[0].contains('1')) {
      error = true;
    } else {
      error = false;

      if (response[1]['data'].isEmpty) {
        currentempty = true;
      } else {
        print(response[1]);
        final decodedres =
            Prescription.fromJson(response[1] as Map<String, dynamic>);

        pres = decodedres.data;
      }
    }
    notifyListeners();
  }

  void getclickeddoctor(index1) {
    // clickdoctordescription = pres[index1].description;
    clickeddoctorcategory = pres[index1].doctorName;
  }
}
