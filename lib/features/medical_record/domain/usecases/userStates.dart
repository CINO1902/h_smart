import 'package:h_smart/features/medical_record/domain/entities/GetOverView.dart';

class GetOverResult {
  final GetOverResultStates status;

  final GetOverView data;

  GetOverResult({required this.status, required this.data});
}

enum GetOverResultStates {
  success,
  idle,
  fail,
  loading,
}
