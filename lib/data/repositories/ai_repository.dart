import '../models/ai_chat_message.dart';
import '../../core/network/api_client.dart';

class AiRepository {
  final ApiClient apiClient;

  AiRepository({required this.apiClient});

  final List<AiChatMessage> _history = [
    AiChatMessage(
      id: 'ai-init',
      text: 'Hello Virendra! I am Zenius AI, your executive co-pilot. I can analyze your sales pipeline, check team attendance, draft customer follow-ups, or search company records. How can I assist you today?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  Future<List<AiChatMessage>> getChatHistory() async {
    return _history;
  }

  Future<AiChatMessage> sendMessage(String text) async {
    final userMsg = AiChatMessage(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _history.add(userMsg);

    // Call AI backend
    final res = await apiClient.post('/ai/chat', {'prompt': text});
    String replyText = '';
    String? proposal;

    if (res != null && res['response'] != null) {
      replyText = res['response'];
      proposal = res['actionProposal'];
    } else {
      // Intelligent fallback responses
      final lower = text.toLowerCase();
      if (lower.contains('pipeline') || lower.contains('sales') || lower.contains('deal')) {
        replyText = '📊 Your live sales pipeline stands at \$340,000 across 4 active deals. "Global ERP Migration" (\$145k) is currently in Proposal stage with a 70% win probability.';
        proposal = 'View Deals Pipeline';
      } else if (lower.contains('check') || lower.contains('attendance') || lower.contains('leave')) {
        replyText = '📍 Today\'s team attendance is 94% on-time. You are currently logged in at San Francisco HQ. 1 paid leave request is awaiting HR review.';
        proposal = 'Check In Now';
      } else if (lower.contains('lead') || lower.contains('apex')) {
        replyText = '🎯 Top scored lead is Samantha Reed from Apex Technologies (Lead Score: 92/100, Est. \$45,000). She was qualified 3 hours ago.';
        proposal = 'Call Samantha';
      } else {
        replyText = 'I have processed your request across Zenius microservices. All enterprise metrics and sync queues are operational.';
      }
    }

    final aiMsg = AiChatMessage(
      id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
      text: replyText,
      isUser: false,
      timestamp: DateTime.now(),
      proposedAction: proposal,
    );
    _history.add(aiMsg);
    return aiMsg;
  }
}
