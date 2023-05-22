import 'package:stream_chat/stream_chat.dart';

class CustomStream {
  static final client = StreamChatClient(
    'your API key here',
    logLevel: Level.INFO,
  );
}
