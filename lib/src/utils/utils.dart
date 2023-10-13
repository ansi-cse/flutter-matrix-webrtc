import 'package:matrix/matrix.dart';
import 'package:webrtc_flutter_matrix/src/client_management.dart';

Future<List<Profile>> searchUser(String text) async {
  final client = ClientManagement().client;
  SearchUserDirectoryResponse response;
  response = await client.searchUserDirectory(text, limit: 10);
  return List<Profile>.from(response.results);
}

Future<ProfileInformation> getUserById(String userId) async {
  final client = ClientManagement().client;
  final user = await client.getUserProfile(userId);
  return user;
}
