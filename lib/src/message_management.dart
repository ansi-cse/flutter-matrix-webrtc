import 'package:matrix/matrix.dart';
import 'package:webrtc_flutter_matrix/client_management.dart';

class MessageManagement {
  static Future<String?> sendTextMessage({
    required String roomId,
    required String message,
    String? replyEventId,
    String? editEventId,
  }) async {
    final room = _getRoomById(roomId);
    if (room != null) {
      final replyEvent =
          replyEventId != null ? await room.getEventById(replyEventId) : null;
      return await room.sendTextEvent(message,
          editEventId: editEventId, inReplyTo: replyEvent);
    }
    return null;
  }

  static Future<String?> reactToMessage({
    required String roomId,
    required String eventId,
    required String emoji,
  }) async {
    final room = _getRoomById(roomId);
    if (room != null) {
      return await room.sendReaction(eventId, emoji);
    }
    return null;
  }

  static Future<String?> sendFileMessage({
    required String roomId,
    required MatrixFile file,
    String? replyEventId,
    String? editEventId,
  }) async {
    final room = _getRoomById(roomId);
    if (room != null) {
      final replyEvent =
          replyEventId != null ? await room.getEventById(replyEventId) : null;
      return await room.sendFileEvent(file,
          editEventId: editEventId, inReplyTo: replyEvent);
    }
    return null;
  }

  static Future<String?> deleteEvent({
    required String roomId,
    required String eventId,
  }) async {
    final room = _getRoomById(roomId);
    if (room != null) {
      return await room.redactEvent(eventId);
    }
    return null;
  }

  static Future<Event?> getEvent({
    required String roomId,
    required String eventId,
  }) async {
    final room = _getRoomById(roomId);
    if (room != null) {
      return await room.getEventById(eventId);
    }
    return null;
  }

  static Room? _getRoomById(String roomId) {
    final client = ClientManagement().client;
    final room = client.getRoomById(roomId);
    if (room == null) {
      throw Exception("Room not found");
    }
    return room;
  }
}
