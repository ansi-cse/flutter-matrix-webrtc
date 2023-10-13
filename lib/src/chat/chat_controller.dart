import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:webrtc_flutter_matrix/src/chat/chat_view.dart';
import 'package:webrtc_flutter_matrix/src/message_management.dart';

class ChatPage extends StatefulWidget {
  final Room room;
  final String displayname;
  const ChatPage({required this.room, Key? key, required this.displayname}) : super(key: key);

  @override
  ChatController createState() => ChatController();
}

class ChatController extends State<ChatPage> {
  late final Future<Timeline> timelineFuture;

  final ScrollController scrollController = ScrollController();

  bool showScrollButton = false; // Initially, hide the scroll button

  @override
  void dispose() {
    scrollController.removeListener(_checkShowScrollButton);
    super.dispose();
  }

  void _checkShowScrollButton() {
    // Check if we can scroll further up (not at the bottom)
    setState(() {
      showScrollButton = scrollController.position.pixels > 0;
    });
  }

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  int count = 0;
  bool showEmojiPicker = false;

  @override
  void initState() {
    scrollController.addListener(_checkShowScrollButton);
    timelineFuture = widget.room.getTimeline(
        onChange: (i) {
          listKey.currentState?.setState(() {});
        },
        onInsert: (i) {
          listKey.currentState?.insertItem(i);
          count++;
        },
        onRemove: (i) {
          count--;
          listKey.currentState?.removeItem(i, (_, __) => const ListTile());
        },
        onUpdate: () {});
    super.initState();
  }

  final TextEditingController sendController = TextEditingController();

  void sendAction() {
    MessageManagement.sendTextMessage(
      roomId: widget.room.id,
      message: sendController.text.trim(),
      replyEventId: null,
      editEventId: null,
    );
    sendController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ChatView(this);
  }
}

