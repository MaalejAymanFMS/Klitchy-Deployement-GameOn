import '../models/user.dart';

abstract class PinScreenInteractor {
  Future<User> retrieve(String id);
  Future<Login> login(Map<String, dynamic> body);
}