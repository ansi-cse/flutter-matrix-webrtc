import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:webrtc_flutter_matrix/client_management.dart';
import 'package:webrtc_flutter_matrix/src/chat_list/chat_list.dart';

class ChatListView extends StatelessWidget {
  final ChatListController chatListController;

  const ChatListView(this.chatListController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SyncUpdate>(
        stream: ClientManagement().client.onSync.stream,
        builder: (context, snapshot) {
          final dmRooms = ClientManagement()
              .client
              .rooms
              .where((room) => room.isDirectChat);
          final groupRooms = ClientManagement()
              .client
              .rooms
              .where((room) => !room.isDirectChat);
          return Column(
            children: [
              // const ConnectionStatusHeader(),
              const TabBar(
                tabs: [
                  Tab(text: 'Direct Messages'),
                  Tab(text: 'Group Chats'),
                ],
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildRoomList(context, dmRooms),
                    _buildRoomList(context, groupRooms),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _buildRoomList(BuildContext context, Iterable<Room> rooms) {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, i) {
        final room = rooms.elementAt(i);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white, // Change to your desired background color
          child: _buildRoomListItem(context, room),
        );
      },
    );
  }

  Widget _buildRoomListItem(BuildContext context, Room room) {
    // Function to generate an avatar based on the first letter of display name
    Widget generateAvatar(String displayName) {
      final firstLetter =
          displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
      List<User> listUser = room
          .getParticipants()
          .where((user) => user.id != ClientManagement().client.userID)
          .toList();
      String userId = listUser.isNotEmpty ? listUser[0].id : '';
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue, // Background color for the avatar
            child: Text(
              firstLetter,
              style: const TextStyle(
                color: Colors.white, // Text color for the letter
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (room.isDirectChat && userId != '')
            FutureBuilder<GetPresenceResponse>(
                future: ClientManagement().client.getPresence(userId),
                builder: (context, snapshot) {
                  final isOnline = snapshot.data?.presence.isOnline;
                  return Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isOnline == true
                          ? Colors.green
                          : Colors.red, // Customize the badge color
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  );
                })
        ],
      );
    }

    return FutureBuilder<Timeline>(
      future: room.getTimeline(),
      builder: (context, snapshot) {
        final timeline = snapshot.data;
        if (timeline == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: room.avatar == null
              // ignore: deprecated_member_use
              ? generateAvatar(room.displayname)
              : CircleAvatar(
                  foregroundImage: NetworkImage(
                    room.avatar!
                        .getThumbnail(
                          ClientManagement().client,
                          width: 56,
                          height: 56,
                        )
                        .toString(),
                  ),
                ),
          title: Text(
            // ignore: deprecated_member_use
            room.displayname,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {},
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28, // Set a fixed width for the container,
                child: IconButton(
                  icon: const Icon(Icons.chat, size: 18),
                  onPressed: () async {
                    chatListController.joinAction(room);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
