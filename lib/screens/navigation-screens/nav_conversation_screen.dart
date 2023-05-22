import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../chat-screens/chat_message_screen.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _controller = StreamChannelListController(
    client: widget.client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    channelStateSort: const [SortOption('last_message_at')],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Chats',
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          backgroundColor: const Color(0xFF4ECDE6),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/main'),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _controller.refresh,
          child: StreamChannelListView(
            controller: _controller,
            onChannelTap: (channel) {
              final otherMembers = channel.state!.members
                  .where((member) =>
                      member.user!.id !=
                      StreamChat.of(context).currentUser!.id)
                  .toList();

              if (otherMembers.isNotEmpty) {
                final targetEmail = otherMembers.first.user!.extraData['email'] as String?;
                

                if (targetEmail != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StreamChannel(
                        channel: channel,
                        child: ChannelPage(
                          targetEmail: targetEmail,
                        ),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
      );
}
