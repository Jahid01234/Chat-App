import 'package:chat_app/data/services/chat/chat_services.dart';
import 'package:chat_app/resources/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String messageID;
  final String userID;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.messageID,
    required this.userID,
    required this.isCurrentUser,
  });

  // Show Option.................
  void _showOptions(context, String messageID, String userID){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return SafeArea(
              child: Wrap(
                children: [
                  // report message button
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text("Report"),
                    onTap: (){
                       Navigator.of(context).pop(); // Close the modal first
                      _reportMessage(context, messageID, userID);
                    },
                  ),

                  // block user button
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Block User"),
                    onTap: (){
                      Navigator.of(context).pop(); // Close the modal first
                      _blockUser(context, userID);
                    },
                  ),

                  // cancel button
                  ListTile(
                    leading: const Icon(Icons.cancel),
                    title: const Text("Cancel"),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
          );
        },
    );
  }

  // report user message.....................
  void _reportMessage(context, String messageID, String userID){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Report Message"),
            content: const Text("Are you sure that you want to report this message?"),
            actions: [
               // cancel button
               TextButton(
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   child: const Text("Cancel"),
               ),

               // report button
              TextButton(
                onPressed: (){
                  ChatServices().reportUser(messageID,userID);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:Text("Message reported successfully."),
                      ),
                  );
                },
                child: const Text("Report"),
              ),
            ],
          );
        }
    );
  }

  // block user......................
  void _blockUser(context, String userID){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Block user"),
            content: const Text("Are you sure that you want to block this user?"),
            actions: [
              // cancel button
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),

              // block button
              TextButton(
                onPressed: (){
                  ChatServices().blockUser(userID);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:Text("Block user successfully."),
                    ),
                  );
                },
                child: const Text("Block"),
              ),
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    // access the ThemeProvider class
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onLongPress: (){
        // check: the user is not current user
        if(!isCurrentUser){
          _showOptions(context, messageID, userID);
        }
      },
      child: Container(
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
      ),
    );
  }
}
