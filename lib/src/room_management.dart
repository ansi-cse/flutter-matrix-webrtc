import 'package:matrix/matrix.dart';
import 'package:webrtc_flutter_matrix/src/client_management.dart';

class CreateRoomOpts {
  final String? name;
  final String? roomAliasName;
  final List<String> invite;
  CreateRoomOpts({this.name, this.roomAliasName, required this.invite});
}

class RoomManagement {
  static Future<String> _createDirectMessageRoom(
      CreateRoomOpts createRoomOpts) async {
    String roomId = await ClientManagement().client.createRoom(
          isDirect: true,
          preset: CreateRoomPreset.trustedPrivateChat,
          invite: createRoomOpts.invite,
        );
    await ClientManagement()
        .client
        .getRoomById(roomId)
        ?.addToDirectChat(createRoomOpts.invite.first);
    return roomId;
  }

  static Future<String> getOrCreateDirectMessageRoom(String otherUserId) async {
    final rooms = ClientManagement().client.rooms.where((room) {
      return room.directChatMatrixID == otherUserId;
    }).toList();
    if (rooms.isNotEmpty) {
      // Return existing room ID
      return rooms[0].id;
    } else {
      // Create a new room
      return _createDirectMessageRoom(CreateRoomOpts(invite: [otherUserId]));
    }
  }
}
