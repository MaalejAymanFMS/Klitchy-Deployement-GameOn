import 'package:klitchyapp/models/rooms.dart';

abstract class RoomInteractor {
  Future<Rooms> addRoom(Map<String, dynamic> body);
  // Future<dynamic> updateRoom(Map<String, dynamic> body);
  Future<ListRooms> getAllRooms(Map<String, dynamic> params);
}