import 'package:chat_app/resources/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    // access the ThemeProvider class
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCurrentUser
                 ? (themeProvider.isLightMode ? Colors.green.shade600 : Colors.green.shade500)
                 : (themeProvider.isLightMode ? Colors.grey.shade200 : Colors.grey.shade800),
      ),
      child: Text(
        message,
        style: TextStyle(
            color: isCurrentUser
                      ? Colors.white
                      : (themeProvider.isLightMode ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
