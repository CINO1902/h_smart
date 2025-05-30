import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:h_smart/features/Hospital/data/datasources/remoteDatasource.dart';
import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';
import 'package:h_smart/features/Hospital/domain/repositories/hospitalrepo.dart';
import 'package:h_smart/features/auth/data/datasources/remotedatasource.dart';
import 'package:h_smart/features/auth/domain/repositories/authrepo.dart';
import 'package:h_smart/features/doctorRecord/data/datasources/remote_datasource.dart';
import 'package:h_smart/features/doctorRecord/data/repositories/doctorRepo.dart';
import 'package:h_smart/features/doctorRecord/domain/repositories/doctor_repo.dart';
import 'package:h_smart/features/medical_record/data/datasources/remotedatasource.dart';
import 'package:h_smart/features/medical_record/data/repositories/medicalRecordRepo.dart';
import 'package:h_smart/features/medical_record/domain/repositories/MedicalRecord_repo.dart';

import '../../features/Hospital/presentation/controller/hospitalController.dart';
import '../../features/auth/data/repositories/auth_repo.dart';
import '../../features/auth/presentation/controller/auth_controller.dart';
import '../../features/chat/data/datasource/remoteDatasource.dart';
import '../../features/chat/data/repositories/chat_repo.dart';
import '../../features/chat/domains/repositories/chat_repo.dart';
import '../../features/chat/presentation/controller/chatservice.dart';
import '../../features/doctorRecord/presentation/controller/doctorRecordController.dart';
import '../../features/medical_record/presentation/controller/medicalRecordController.dart';
import '../../features/myAppointment/data/datasources/remotedatasource.dart';
import '../../features/myAppointment/data/repositories/user_repo.dart';
import '../../features/myAppointment/domain/repositories/user_repo.dart';
import '../../features/myAppointment/presentation/controller/myAppointmentController.dart';
import 'dio_service.dart';
import 'http_service.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator
    ..registerLazySingleton<AuthDatasourceImp>(
        () => AuthDatasourceImp(locator()))
    ..registerLazySingleton<AuthDatasource>(() => AuthDatasourceImp(locator()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(locator()))
    ..registerLazySingleton(() => Authprovider(locator()))
    //DoctorDetails
    ..registerLazySingleton<DoctorDatasourceImp>(
        () => DoctorDatasourceImp(locator()))
    ..registerLazySingleton<DoctorDatasource>(
        () => DoctorDatasourceImp(locator()))
    ..registerLazySingleton<DoctorRepository>(() => DoctorRepoImpl(locator()))
    ..registerLazySingleton(() => Doctorprovider(locator()))
    //HospitalDetail
    ..registerLazySingleton<HospitalDataSourceImp>(
        () => HospitalDataSourceImp(locator()))
    ..registerLazySingleton<HospitalDataSource>(
        () => HospitalDataSourceImp(locator()))
    ..registerLazySingleton<HospitalRepo>(() => HospaitalRepoImp(locator()))
    ..registerLazySingleton(() => GetHospitalProvider(locator()))
    //MedicalRecord
    ..registerLazySingleton<MedicalRecordDataSourceImp>(
        () => MedicalRecordDataSourceImp(locator()))
    ..registerLazySingleton<MedicalRecordDatasource>(
        () => MedicalRecordDataSourceImp(locator()))
    ..registerLazySingleton<MedicalRecordRepo>(
        () => MedicalRecordRepoImp(locator()))
    ..registerLazySingleton(() => MedicalRecordprovider(locator()))
    //DashProvider
    ..registerLazySingleton<UserDatasourceImpl>(
        () => UserDatasourceImpl(locator()))
    ..registerLazySingleton<UserDataSource>(() => UserDatasourceImpl(locator()))
    ..registerLazySingleton<UserRepository>(() => UserRepositoryImp(locator()))
    ..registerLazySingleton(() => Mydashprovider(locator()))
    //Chat
    ..registerLazySingleton<ChatDatasourceImp>(
        () => ChatDatasourceImp(locator()))
    ..registerLazySingleton<ChatDataSource>(() => ChatDatasourceImp(locator()))
    ..registerLazySingleton<ChatRepository>(() => ChatRepositoryImp(locator()))
    ..registerLazySingleton(() => ChatController(locator()))
    //packages
    ..registerLazySingleton<HttpService>(() => DioService(locator()))
    ..registerLazySingleton(() => Dio());
}
