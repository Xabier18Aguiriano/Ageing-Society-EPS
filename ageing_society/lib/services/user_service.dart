import '../models/user.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final User user = User();

  void updateProfile({required String name, required String age, required String country}) {
    user.name = name;
    user.age = age;
    user.country = country;
  }
}
