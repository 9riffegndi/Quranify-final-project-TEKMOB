import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/chat_message.dart';

/**
 * Widget untuk menampilkan pesan chat dalam conversation
 * 
 * Mendukung berbagai tipe pesan dengan styling yang berbeda
 * untuk user dan AI, serta fitur copy text
 */
class ChatMessageWidget extends StatelessWidget {
  /// Data pesan yang akan ditampilkan
  final ChatMessage message;
  
  /// Callback ketika user menekan tombol copy
  final VoidCallback? onCopy;

  /**
   * Constructor untuk ChatMessageWidget
   * 
   * @param message - Data pesan yang akan ditampilkan
   * @param onCopy - Callback untuk fitur copy (opsional)
   */
  const ChatMessageWidget({
    Key? key,
    required this.message,
    this.onCopy,
  }) : super(key: key);

  /**
   * Method build utama untuk membangun widget
   * 
   * Menentukan tampilan berdasarkan tipe pesan
   * Loading message memiliki tampilan khusus
   * 
   * @param context - BuildContext untuk akses theme dan media query
   * @return Widget yang akan ditampilkan
   */
  @override
  Widget build(BuildContext context) {
    // Jika pesan bertipe loading, tampilkan loading indicator
    if (message.type == MessageType.loading) {
      return _buildLoadingMessage();
    }

    // Tampilan normal untuk pesan biasa
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Pesan user di kanan, AI di kiri
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Avatar AI (hanya untuk pesan AI)
          if (!message.isUser) ...[
            _buildAvatar(false),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? const Color(0xFF219EBC) 
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isUser)
                    Text(
                      message.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  else
                    MarkdownBody(
                      data: message.text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        h1: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        strong: const TextStyle(
                          color: Color(0xFF219EBC),
                          fontWeight: FontWeight.bold,
                        ),
                        code: TextStyle(
                          backgroundColor: Colors.grey.shade200,
                          fontFamily: 'monospace',
                        ),
                        blockquote: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: message.isUser 
                              ? Colors.white70 
                              : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      if (!message.isUser && onCopy != null)
                        GestureDetector(
                          onTap: onCopy,
                          child: Icon(
                            Icons.copy,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isUser 
          ? const Color(0xFF219EBC) 
          : Colors.green.shade100,
      child: Icon(
        isUser ? Icons.person : Icons.psychology,
        size: 20,
        color: isUser ? Colors.white : Colors.green.shade700,
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          _buildAvatar(false),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Asisten sedang berpikir...',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
