import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/screens/ChatScreen.dart'; // Import the chat screen

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example list of users
    final List<Map<String, String>> users = [
      {'name': 'John Doe', 'lastMessage': 'Hey, how are you?', 'time': '7:40 AM'},
      {'name': 'Jane Smith', 'lastMessage': 'Let’s catch up soon!', 'time': 'Thu'},
      {'name': 'Michael Brown', 'lastMessage': 'Can you send me the details?', 'time': 'Wed'},
      {'name': 'Pallavi Tandan', 'lastMessage': 'Kindly check your mail.', 'time': 'Thu'},
      {'name': 'Srinivas Pachipula', 'lastMessage': 'I am available.', 'time': 'Thu'},
      {'name': 'John Doe', 'lastMessage': 'Hey, how are you?', 'time': '7:40 AM'},
      {'name': 'Jane Smith', 'lastMessage': 'Let’s catch up soon!', 'time': 'Thu'},
      {'name': 'Michael Brown', 'lastMessage': 'Can you send me the details?', 'time': 'Wed'},
      {'name': 'Pallavi Tandan', 'lastMessage': 'Kindly check your mail.', 'time': 'Thu'},
      {'name': 'Srinivas Pachipula', 'lastMessage': 'I am available.', 'time': 'Thu'},
      {'name': 'John Doe', 'lastMessage': 'Hey, how are you?', 'time': '7:40 AM'},
      {'name': 'Jane Smith', 'lastMessage': 'Let’s catch up soon!', 'time': 'Thu'},
      {'name': 'Michael Brown', 'lastMessage': 'Can you send me the details?', 'time': 'Wed'},
      {'name': 'Pallavi Tandan', 'lastMessage': 'Kindly check your mail.', 'time': 'Thu'},
      {'name': 'Srinivas Pachipula', 'lastMessage': 'I am available.', 'time': 'Thu'},
      {'name': 'John Doe', 'lastMessage': 'Hey, how are you?', 'time': '7:40 AM'},
      {'name': 'Jane Smith', 'lastMessage': 'Let’s catch up soon!', 'time': 'Thu'},
      {'name': 'Michael Brown', 'lastMessage': 'Can you send me the details?', 'time': 'Wed'},
      {'name': 'Pallavi Tandan', 'lastMessage': 'Kindly check your mail.', 'time': 'Thu'},
      {'name': 'Srinivas Pachipula', 'lastMessage': 'I am available.', 'time': 'Thu'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primary),
            onPressed: () {
              // Add functionality for more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: const Color(0xFFE7EDF4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // List of users with dividers
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFE7EDF4), // Divider color
                thickness: 1, // Divider thickness
                indent: 16, // Left padding
                endIndent: 16, // Right padding
              ),
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary, // Outline color
                        width: 2, // Outline width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFFBE3C7),
                      child: Text(user['name']![0]), // Display first letter of name
                    ),
                  ),
                  title: Text(
                    user['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user['lastMessage']!),
                  trailing: Text(
                    user['time']!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    // Navigate to ChatScreen when a user is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(userName: user['name']!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button for composing a new message
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          // Add functionality for composing a new message
        },
      ),
    );
  }
}