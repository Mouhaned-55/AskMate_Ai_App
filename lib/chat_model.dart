enum ChatMessageType { user, bot }

class ChatMessage {
  String? text;
  ChatMessageType? type;

  ChatMessage({required this.text, required this.type});
}
