import 'package:flutter/material.dart';
import 'package:naka/screens/ChatScreen.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
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
      backgroundColor: appearance.brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        elevation: 0,
        title: Text(
          'Messages',
          style: TextStyle(
            color: appearance.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appearance.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: appearance.primaryColor),
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
                prefixIcon: Icon(Icons.search, color: appearance.primaryColor),
                filled: true,
                fillColor: appearance.brightness == Brightness.dark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFE7EDF4),
                hintStyle: TextStyle(
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[600]
                      : Colors.grey[400],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // List of users with dividers
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) => Divider(
                color: appearance.brightness == Brightness.dark
                    ? Colors.grey[700]
                    : const Color(0xFFE7EDF4),
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: appearance.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFFBE3C7),
                      child: Text(
                        user['name']![0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  title: Text(
                    user['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appearance.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    user['lastMessage']!,
                    style: TextStyle(
                      color: appearance.brightness == Brightness.dark
                          ? Colors.grey[500]
                          : Colors.grey[600],
                    ),
                  ),
                  trailing: Text(
                    user['time']!,
                    style: TextStyle(
                      color: appearance.brightness == Brightness.dark
                          ? Colors.grey[500]
                          : Colors.grey[500],
                    ),
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
        backgroundColor: appearance.primaryColor,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          // Add functionality for composing a new message
        },
      ),
    );
      },
    );
  }
}