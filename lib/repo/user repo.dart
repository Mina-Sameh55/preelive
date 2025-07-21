
import '../model/user model.dart';


abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Future<void> blockUser(String userId, Duration duration);
  Future<void> unblockUser(String userId);
  Future<void> banUser(String userId,Duration duration);
  Future<void> unbanUser(String userId);
  Future<void> createUser(Map<String, dynamic> userData);
  Future<void> deleteUser(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> updates);
  Future<void> blockDevice(String userId, String deviceId, Duration duration);
  Future<void> unblockDevice(String userId, String deviceId);}