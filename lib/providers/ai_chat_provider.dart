import 'package:flutter/foundation.dart';
import '../data/models/ai_chat_message.dart';
import '../data/repositories/ai_repository.dart';

class AiChatProvider extends ChangeNotifier {
  final AiRepository aiRepository;

  AiChatProvider({required this.aiRepository});

  List<AiChatMessage> _messages = [];
  bool _isTyping = false;

  List<AiChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> loadHistory() async {
    _messages = await aiRepository.getChatHistory();
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _isTyping = true;
    notifyListeners();

    try {
      await aiRepository.sendMessage(text);
      _messages = await aiRepository.getChatHistory();
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }
}
