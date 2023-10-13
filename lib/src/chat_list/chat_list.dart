import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:webrtc_flutter_matrix/src/chat/chat_controller.dart';
import 'package:webrtc_flutter_matrix/src/chat_list/chat_list_view.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ChatListController createState() => ChatListController();
}

class ChatListController extends State<ChatListPage> {
  void joinAction(Room room) async {
    if (room.membership != Membership.join) {
      await room.join();
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatPage(
          room: room,
          displayName: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ChatListView(this);
}
