import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:h_smart/features/Hospital/domain/repositories/hospitalrepo.dart';

import '../../domain/entities/hospitalmodel.dart';
import '../../domain/states/hospitalStates.dart';

class GetHospitalProvider extends ChangeNotifier {
  final HospitalRepo hospitalRepo;

  GetHospitalProvider(this.hospitalRepo);

  int private1 = 0;
  String errormessage = '';
  List<Result> hospitalData = [];
  List<Result> governmenthospital = [];
  List<Result> privatehospital = [];
  List<Result> governmenthospitalall = [];
  List<Result> privatehospitalall = [];
  String imagetag = '';
  String imagetag1 = '';
  HospitalResult hospitalResult =
      HospitalResult(HospitalResultStates.isIdle, HospitalModel());
  bool enablehero = false;
  int index1 = 0;
  List clickedHospital = [];

  Future<void> getHospital() async {
    hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, HospitalModel());
    notifyListeners();
    final response = await hospitalRepo.getHospital();

    hospitalResult = response;

    // final decodedres =
    //     HospitalModel.fromJson(response[1][0] as Map<String, dynamic>);
    hospitalData = response.response.results ?? [];
    governmenthospital = hospitalData
        .where((element) => element.type == 'government')
        .take(4)
        .toList();
    privatehospital = hospitalData
        .where((element) => element.type == 'private')
        .take(4)
        .toList();
    governmenthospitalall =
        hospitalData.where((element) => element.type == 'government').toList();
    privatehospitalall =
        hospitalData.where((element) => element.type == 'private').toList();

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
