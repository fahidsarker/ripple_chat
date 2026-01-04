String _messagesRoute(String chatId) => '/api/chats/$chatId/messages';

enum ApiGet<T> {
  chats('/api/chats'),
  users('/api/users'),
  messages(_messagesRoute),
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
  profileUpdatePassword('/api/profile/update-password');

  final T path;
  const ApiPost(this.path);
}
