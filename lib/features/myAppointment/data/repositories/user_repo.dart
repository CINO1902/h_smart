import 'dart:io';

abstract class UserDataSource {
  Future<List<String>> edit_profile(
      firstname, lastname, phone, email, address, File? image, imagelink);
}
