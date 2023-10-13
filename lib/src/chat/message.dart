import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:webrtc_flutter_matrix/src/message_management.dart';
import 'package:webrtc_flutter_matrix/src/utils/utils.dart';

class MessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final Event event;
  final Event? nextEvent;
  final Timeline timeline;

  const MessageBubble({
    Key? key,
    required this.event,
    required this.timeline,
    this.nextEvent,
    required this.isOwnMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAttachmentMessage = event.getAttachmentUrl() != null ? true : false;

    // Conditionally set the alignment based on whether it's your message or not
    final alignment =
        isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

    return Row(
      mainAxisAlignment: alignment, // Use the 'alignment' variable
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isOwnMessage ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Always align text to start
            children: [
              Row(
                children: [
                  FutureBuilder<ProfileInformation>(
                    future: getUserById(event.senderId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Text(
                          data.displayname.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          event.senderId, // Use senderId as a fallback
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Text(
                event.redacted
                    ? 'Message is redacted'
                    : event.getDisplayEvent(timeline).body,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Emoji',
                ),
              ),
              if (isAttachmentMessage &&
                  event.attachmentMimetype.contains("image"))
                Image.network(
                  event.getAttachmentUrl().toString(),
                  width: 100,
                  height: 100,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpeacialEvent extends StatelessWidget {
  final Event event;
  final Timeline timeline;

  // ignore: use_key_in_widget_constructors
  const SpeacialEvent({Key? key, required this.event, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          Text(
            _getEventText(),
            style: const TextStyle(
              fontSize: 12, // Adjust the font size as desired
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getEventText() {
    String eventContent = event.getDisplayEvent(timeline).body;
    List<String> contentSplit = eventContent.split(".");
    String content = contentSplit[contentSplit.length - 1];
    String senderId = event.senderId;
    switch (eventContent) {
      case 'm.room.create':
        return '$senderId is created this room';
      case 'm.room.member':
        Object? display = event.content.tryGet("displayname");
        final membership = event.content.tryGet('membership');
        if (membership == 'leave') {
          return '$senderId is leave';
        }
        if (membership == "invite") {
          return '$senderId is invite $display';
        }
        if (membership == "join") {
          return '$display is join room';
        }
        return '';
      default:
        return '$senderId is updated $content';
    }
  }
}
