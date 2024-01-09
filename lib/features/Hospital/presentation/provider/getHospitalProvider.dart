import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:h_smart/features/Hospital/domain/repositories/hospitalrepo.dart';

import '../../domain/entities/hospitalmodel.dart';

class GetHospitalProvider extends ChangeNotifier {
  final HospitalRepo hospitalRepo;

  GetHospitalProvider(this.hospitalRepo);

  bool loading = true;
  bool error = false;
  int private1 = 0;
  String errormessage = '';
  List<HospitalsDetail> hospitalData = [];
  List<HospitalsDetail> governmenthospital = [];
  List<HospitalsDetail> privatehospital = [];
  List<HospitalsDetail> governmenthospitalall = [];
  List<HospitalsDetail> privatehospitalall = [];
  String imagetag = '';
  String imagetag1 = '';
  bool enablehero = false;
  int index1 = 0;
  List clickedHospital = [];

  Future<void> getHospital() async {
    loading = true;

    final response = await hospitalRepo.getHospital();
    if (response[0].contains('2')) {
      error = true;
      errormessage = response[1][0];
    } else {
      error = false;
      final decodedres =
          HospitalModel.fromJson(response[1][0] as Map<String, dynamic>);
      hospitalData = decodedres.hospitalsDetail;
      governmenthospital = hospitalData
          .where((element) => element.type == 'government')
          .take(4)
          .toList();
      privatehospital = hospitalData
          .where((element) => element.type == 'private')
          .take(4)
          .toList();
      governmenthospitalall = hospitalData
          .where((element) => element.type == 'government')
          .toList();
      privatehospitalall =
          hospitalData.where((element) => element.type == 'private').toList();
    }

    loading = false;
    notifyListeners();
  }

  void getClickedHospital(index, private, name, city) {
    clickedHospital.clear();
    clickedHospital.add(index);
    clickedHospital.add(private);
    clickedHospital.add(name);
    clickedHospital.add(city);
    print(clickedHospital);
    index1 = index;
    enablehero = true;
    private1 = private;
    notifyListeners();
  }

  void disablehero() {
    enablehero = false;
    notifyListeners();
  }

  void createimagetag() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    imagetag = getRandomString(5);
    imagetag1 = imagetag + index1.toString() + private1.toString();

    notifyListeners();
  }
}
