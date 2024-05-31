import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/SpecialisedDoctor.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/mydoctor.dart';
import 'package:h_smart/features/doctorRecord/domain/repositories/doctor_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class doctorprpvider extends ChangeNotifier {
  final DoctorRepository doctorRepository;

  doctorprpvider(this.doctorRepository);

  bool loading = true;
  bool error = false;
  String msg = '';
  bool loadfav = false;
  bool mydocloading = true;
  List<Payload> doctorcategory = [];
  List<Payload> categorydoc = [];
  String favdoctorid = '';
  List<PayloadDoc> mydoctorlist = [];
  String clickdoctordescription = '';
  bool doctorclicked = false;
  bool mydoctorclicked = false;
  Doctor clickeddoctorcategory = Doctor(
      firstName: '',
      lastName: '',
      phoneNumber: '',
      bio: '',
      docProfilePicture: '',
      user: User(id: '', email: ''));
  void calldoctorlist() async {
    loading = true;
    final response = await doctorRepository.getDoctorList();
    loading = false;
  }

  void searchbook(String query) {
    print(query);
    final suggestion = categorydoc.where((element) {
      final symptoms = element.name.toLowerCase();
      final input = query.toLowerCase();

      return symptoms.contains(input);
    }).toList();

    doctorcategory = suggestion;
    print(doctorcategory);

    notifyListeners();
  }

  void calldoctorcatergory() async {
    error = false;
    final response = await doctorRepository.getDoctorCategory();
    loading = false;
    if (response[0].contains('1')) {
      error = true;
    } else {
      error = false;

      final decodedres =
          SpecializeDoctor.fromJson(response[1] as Map<String, dynamic>);

      categorydoc = decodedres.payload;
      doctorcategory = categorydoc;
    }
    notifyListeners();
  }

  void getclickeddoctor(index1, index2) {
    doctorclicked = true;
    clickdoctordescription = doctorcategory[index1].name;
    clickeddoctorcategory = doctorcategory[index1].doctors[index2];
  }

  void actionmydoctorclicked() {
    mydoctorclicked = true;
  }

  Future<void> addtoFavourite(doctorid) async {
    loadfav = true;
    notifyListeners();
    final response = await doctorRepository.addtofav(doctorid);
    loadfav = false;
    if (response[0].contains('1')) {
      error = true;
      msg = response[1];
    } else {
      error = false;

      msg = response[1]['message'];
      final pref = await SharedPreferences.getInstance();
      pref.setString('favdoctorid', doctorid);
      favdoctorid = doctorid;
    }
    callmydoctor();
    loadfav = false;
    notifyListeners();
  }

  Future<void> removefromFavourite(doctorid) async {
    loadfav = true;
    notifyListeners();
    final response = await doctorRepository.removefav(favdoctorid);
    loadfav = false;
    if (response[0].contains('1')) {
      error = true;
      msg = response[1];
    } else {
      error = false;
      msg = 'Remove Succesfully';
      final pref = await SharedPreferences.getInstance();
      pref.setString('favdoctorid', '');
      favdoctorid = '';
    }
    notifyListeners();
  }

  void ondispose() {
    doctorclicked = false;
    mydoctorclicked = false;
  }

  Future<void> callmydoctor() async {
    error = false;
    mydocloading = true;

    final response = await doctorRepository.mydoctor();
    mydocloading = false;
    if (response[0].contains('1')) {
      error = true;
      msg = response[1];
    } else {
      error = false;

      final decodedres = Mydoctor.fromJson(response[1] as Map<String, dynamic>);
      mydoctorlist = decodedres.payload;
      final doctorid = mydoctorlist[0].doctor.user.id;
      final pref = await SharedPreferences.getInstance();
      pref.setString('favdoctorid', doctorid);
      favdoctorid = doctorid;
    }
    notifyListeners();
  }

}
