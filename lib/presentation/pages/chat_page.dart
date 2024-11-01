import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:chat_app/data/services/chat/chat_services.dart';
import 'package:chat_app/presentation/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail ;
  final String receiverID ;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // access the auth and chat Services
  final AuthServices authServices = AuthServices();
  final ChatServices chatServices = ChatServices();

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // send message method.............................
  void sendMessage() async {
    // if there is something inside textField
    if(_messageController.text.isNotEmpty){
      // send the message
      await chatServices.sendMessage(widget.receiverID, _messageController.text);

      // clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: Text(widget.receiverEmail),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // display all message
            Expanded(
                child: _buildMessageList(),
            ),

            // user text input
            _buildUserInputMessage(),
          ],
        ),
      ),
    );
  }


  // build message list...........
  Widget _buildMessageList(){
    String senderID = authServices.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatServices.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot){
        // loading circle
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // error message
        if(snapshot.hasError){
          return const Center(
            child: Text("Error"),
          );
        }

        // return list view show user messages
        return ListView(
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // build message item.........
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String,dynamic> data = doc.data() as Map<String,dynamic>;

    //is current user check
    bool isCurrentUser = data['senderID'] == authServices.getCurrentUser()!.uid;

    return Container(
         // align message to the right if the senderId is the current user, otherwise left
         alignment: isCurrentUser
                     ? Alignment.centerRight
                     : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
          children: [
            ChatBubble(
                message: data["message"],
                isCurrentUser: isCurrentUser,
            ),
          ],
        ),
    );
  }

  // build user input message.........
  Widget _buildUserInputMessage(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // text input field
          Expanded(
              child: TextField(
                expands: false,
                controller: _messageController,
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding:const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Type a message",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.grey,
                    ),
                  ),
                ),
              )
          ),
          const SizedBox(width: 10),

          // send the message icon
          Container(
            decoration: const BoxDecoration(
              color: Colors.cyan,
              shape: BoxShape.circle,
            ),
            child: IconButton(
                onPressed: sendMessage,// sendMessage method call
                icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 25,
                ),
            ),
          ),
        ]
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
