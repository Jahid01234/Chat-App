import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:chat_app/data/services/chat/chat_services.dart';
import 'package:chat_app/presentation/widgets/app_bar_widget.dart';
import 'package:chat_app/presentation/widgets/chat_bubble.dart';
import 'package:chat_app/presentation/widgets/snack_bar_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';



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
  final ScrollController _scrollController = ScrollController();

  // for focus node
  final FocusNode _myFocusNode = FocusNode();



  // Send audio call invitation.........
  void sendAudioCallInvitation() async {
    try {
      debugPrint('Sending audio call invitation to: ${widget.receiverID}');

      await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [
          ZegoCallUser(
            widget.receiverID,
            widget.receiverEmail,
          ),
        ],
        isVideoCall: false,
      );

      debugPrint('Audio call invitation sent successfully');
    } catch (e) {
      if (mounted) {
        showSnackBarMessage(context,e.toString());
      }
    }
  }

  // Send video call invitation.....
  void sendVideoCallInvitation() async {
    try {
      debugPrint('Sending video call invitation to: ${widget.receiverID}');

      await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [
          ZegoCallUser(
            widget.receiverID,
            widget.receiverEmail,
          ),
        ],
        isVideoCall: true,
      );

      debugPrint('Video call invitation sent successfully');
    } catch (e) {
      if (mounted) {
        showSnackBarMessage(context,e.toString());
      }
    }
  }




  // send message method.............................
  void sendMessage() async {
    // if there is something inside textField
    if(_messageController.text.isNotEmpty){
      // send the message
      await chatServices.sendMessage(widget.receiverID, _messageController.text);
      // clear text controller
      _messageController.clear();
    }

    // for message scroll down
    scrollDown();
  }

  // scroll down controller...........
  void scrollDown(){
    _scrollController.animateTo(
         _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    // add listener to focus node(for textField scroll)
    _myFocusNode.addListener(() {
      if(_myFocusNode.hasFocus){
        // keyboard has time to show up
        // then scroll down
        Future.delayed(
            const Duration(milliseconds: 500),
            ()=> scrollDown(),
        );
      }
    });

    // wait a bit for listView to be built, the scroll to bottom(for ListView message scroll)
    Future.delayed(
      const Duration(milliseconds: 500),
          ()=> scrollDown(),
    );
  }






@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWidget(
        title: widget.receiverEmail,
        text: "Online",
        showAvatar: true,
        actions: [
            // Audio call button
            IconButton(
              onPressed: sendAudioCallInvitation,
              icon: const Icon(Icons.call, size: 26),
              tooltip: 'Audio Call',
            ),
            // Video call button
            IconButton(
              onPressed: sendVideoCallInvitation,
              icon: const Icon(Icons.video_call_outlined, size: 28),
              tooltip: 'Video Call',
            ),

        ],
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
          controller: _scrollController,
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
                messageID: doc.id,
                userID: data["senderID"],
                otherUserID: widget.receiverID,
                isCurrentUser: isCurrentUser,
            ),

          ],
        ),
    );
  }

  // build user input text field and send message button.........
  Widget _buildUserInputMessage(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // text input field
          Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _myFocusNode,
                maxLines: null, // Allow multiline input
                textInputAction: TextInputAction.newline,// space new line
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
              ),
          ),
          const SizedBox(width: 10),

          // send the message icon
          Container(
            decoration:const BoxDecoration(
              color: Colors.blueGrey,
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
    _scrollController.dispose();
    _myFocusNode.dispose();
    super.dispose();
  }
}




