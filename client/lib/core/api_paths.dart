String _messagesRoute({required String chatId}) =>
    '/api/chats/$chatId/messages';
String _chatDetail({required String chatId}) => '/api/chats/$chatId';
String _userProfile({required String userId}) => '/api/users/$userId';

enum ApiGet<T> {
  chats('/api/chats'),
  users('/api/users'),
  userOf(_userProfile),
  messages(_messagesRoute),
  chatOf(_chatDetail),
  profile('/api/profile');

  final T path;
  const ApiGet(this.path);
}

enum ApiPost<T> {
  login('/api/auth/login'),
  register('/api/auth/register'),

  chats('/api/chats'),
  messages(_messagesRoute),

  profileUpdateName('/api/profile/update-name'),
  profileUpdatePhoto('/api/profile/update-photo'),
  profileUpdatePassword('/api/profile/update-password');

  final T path;
  const ApiPost(this.path);
}
