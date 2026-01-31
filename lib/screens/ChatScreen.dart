import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';

class ChatScreen extends StatelessWidget {
  final String userName;

  const ChatScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://i.postimg.cc/zDLDCwp7/image2.jpg',
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(fontSize: 14, color: AppColors.success),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildMessageBubble(
                  message: 'Hi Sarah, we\'re impressed with your portfolio and would like to schedule an interview. Are you available next week?',
                  time: '12:30 PM',
                  isSentByMe: false,
                  senderName: 'Tech Innovators Inc.',
                  avatarUrl: 'https://i.postimg.cc/zDLDCwp7/image2.jpg',
                ),
                _buildMessageBubble(
                  message: 'Hello, I\'m thrilled to hear that! Yes, I\'m available next week. Please let me know the available time slots.',
                  time: '12:31 PM',
                  isSentByMe: true,
                  senderName: 'Sarah',
                  avatarUrl: 'https://i.postimg.cc/zDLDCwp7/image2.jpg',
                ),
              ],
            ),
          ),
          // Input field for sending messages
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      filled: true,
                      fillColor: AppColors.searchBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: AppColors.white),
                    onPressed: () {
                      // Add functionality to send messages
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build message bubbles
  Widget _buildMessageBubble({
    required String message,
    required String time,
    required bool isSentByMe,
    required String senderName,
    required String avatarUrl,
  }) {
    return Row(
      mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSentByMe)
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
          ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                senderName,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSentByMe ? AppColors.primary : AppColors.searchBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSentByMe ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (isSentByMe)
          const SizedBox(width: 8),
        if (isSentByMe)
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
          ),
      ],
    );
  }
}