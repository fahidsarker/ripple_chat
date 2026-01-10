import 'package:socket_io_client/socket_io_client.dart' as IO;

class RippleSocket {
  final IO.Socket socket;

  RippleSocket(this.socket);

  void subscribe<T>(String event, Function(T) onData) {
    socket.on(event, (data) {
      if (data is T) {
        onData(data);
      }
    });
  }

  void dispose() {
    socket.clearListeners();
  }

  void subscribeToChatRoom(
    String chatId,
    Function(Map<String, dynamic>) onMessage,
  ) {
    socket.emit('chat:subscribe', {'chatId': chatId});
    subscribe<Map<String, dynamic>>('chat:$chatId:new-message', onMessage);
  }

  void unSubscribeFromChatRoom(String chatId) {
    socket.emit('chat:unsubscribe', {'chatId': chatId});
  }

  void subscribeToNewChatCreations(Function(Map<String, dynamic>) onMessage) {
    subscribe<Map<String, dynamic>>('chat-list:new-chat', onMessage);
  }

  void subscribeToChatUpdates(Function(Map<String, dynamic>) onMessage) {
    subscribe<Map<String, dynamic>>('chat-list:chat-updates', onMessage);
  }
}
