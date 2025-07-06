import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/chat_service.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/chat_input_widget.dart';
import '../config/ai_config.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final AIService _aiService = AIService();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final _uuid = const Uuid();
  
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    // Load chat history
    final history = await _chatService.loadChatHistory();
    
    setState(() {
      if (history.isNotEmpty) {
        _messages.addAll(history);
      } else {
        // Add welcome message
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: AIConfig.welcomeMessage,
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.text,
        ));
      }
      _isInitialized = true;
    });
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      // Add loading message
      _messages.add(ChatMessage(
        id: _uuid.v4(),
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.loading,
      ));
    });

    _scrollToBottom();

    try {
      // Determine message type and get appropriate response
      final messageType = _aiService.categorizeMessage(text);
      ChatMessage aiResponse;

      switch (messageType) {
        case 'quran_recommendation':
          aiResponse = await _aiService.getQuranRecommendation(text);
          break;
        case 'hadith_recommendation':
          aiResponse = await _aiService.getHadithRecommendation(text);
          break;
        case 'islamic_guidance':
          aiResponse = await _aiService.getIslamicGuidance(text);
          break;
        default:
          aiResponse = await _aiService.askQuranQuestion(text);
      }

      setState(() {
        // Remove loading message
        _messages.removeWhere((msg) => msg.type == MessageType.loading);
        _messages.add(aiResponse);
        _isLoading = false;
      });

      // Save chat history
      await _chatService.saveChatHistory(_messages);

    } catch (e) {
      setState(() {
        // Remove loading message
        _messages.removeWhere((msg) => msg.type == MessageType.loading);
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: 'Maaf, terjadi kesalahan. Silakan coba lagi dalam beberapa saat.',
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.text,
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _copyToClipboard(String text) {
    // Remove markdown formatting for clipboard
    final cleanText = text
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1') // Remove bold
        .replaceAll(RegExp(r'\*(.*?)\*'), r'$1') // Remove italic
        .replaceAll(RegExp(r'#{1,6}\s'), '') // Remove headers
        .replaceAll(RegExp(r'^\s*[-*+]\s', multiLine: true), '• '); // Convert lists
    
    Clipboard.setData(ClipboardData(text: cleanText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pesan telah disalin ke clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clearChat() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat Chat'),
        content: const Text('Apakah Anda yakin ingin menghapus semua riwayat chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _chatService.clearChatHistory();
              setState(() {
                _messages.clear();
                _initializeChat();
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.psychology, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Asisten AI Quranify',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF219EBC),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: _clearChat,
            tooltip: 'Hapus riwayat chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: _isInitialized
                ? ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatMessageWidget(
                        message: message,
                        onCopy: message.isUser 
                            ? null 
                            : () => _copyToClipboard(message.text),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          
          // Input area
          ChatInputWidget(
            onSendMessage: _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
