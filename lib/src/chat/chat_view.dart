// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:webrtc_flutter_matrix/src/chat/chat_controller.dart';
import 'package:webrtc_flutter_matrix/src/chat/message.dart';
import 'package:webrtc_flutter_matrix/src/client_management.dart';

class ChatView extends StatelessWidget {
  final ChatController chatController;

  const ChatView(this.chatController, {Key? key}) : super(key: key);

  void _scrollToBottom() {
    chatController.scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(chatController.widget.displayName == ''
              ? chatController.widget.room.displayname
              : chatController.widget.displayName),
          backgroundColor: Colors.transparent,
          actions: [],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // const ConnectionStatusHeader(),
                  Expanded(
                    child: FutureBuilder<Timeline>(
                      future: chatController.timelineFuture,
                      builder: (context, snapshot) {
                        final timeline = snapshot.data;
                        if (timeline == null) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        if (timeline.canRequestHistory) {
                          timeline.requestHistory();
                        }

                        chatController.count = timeline.events.length;
                        return Column(
                          children: [
                            const Divider(height: 1),
                            Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification is ScrollEndNotification) {
                                    if (notification.metrics.extentAfter == 0 &&
                                        timeline.canRequestHistory) {
                                      timeline
                                          .requestHistory(); // Trigger load more
                                    }
                                  }
                                  return true;
                                },
                                child: AnimatedList(
                                  key: chatController.listKey,
                                  reverse: true,
                                  controller: chatController
                                      .scrollController, // Attach the ScrollController
                                  initialItemCount: timeline.events.length,
                                  itemBuilder: (context, i, animation) {
                                    final event = timeline.events[i];

                                    if (event.relationshipEventId != null) {
                                      return Container(); // Skip relationship events
                                    }

                                    bool isMyMessage = event.senderId ==
                                        ClientManagement().client.userID;

                                    return Column(
                                      children: [
                                        if (event.type.contains(
                                            "m.room.message")) // Check if the event is from others
                                          MessageBubble(
                                              isOwnMessage: isMyMessage,
                                              event: event,
                                              timeline:
                                                  timeline), // Pass timeline here
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: chatController.sendController,
                            decoration: const InputDecoration(
                              hintText: 'Send message',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send_outlined),
                          onPressed: chatController.sendAction,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 60.0,
              right: 16.0,
              child: flutter.Visibility(
                visible: chatController.showScrollButton,
                child: FloatingActionButton.small(
                  onPressed: _scrollToBottom,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
          ],
        ));
  }
}
