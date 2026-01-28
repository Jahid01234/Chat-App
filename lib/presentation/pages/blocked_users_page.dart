import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:chat_app/data/services/chat/chat_services.dart';
import 'package:chat_app/presentation/widgets/app_bar_widget.dart';
import 'package:chat_app/presentation/widgets/snack_bar_message.dart';
import 'package:chat_app/presentation/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
   BlockedUsersPage({super.key});

  // access the auth and chat Services
  final AuthServices authServices = AuthServices();
  final ChatServices chatServices = ChatServices();

  // get current user id
  late final String userID = authServices.getCurrentUser()!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(
          title: "BLOCKED USERS",
          centerTitle: true,
      ),
      body:StreamBuilder<List<UserModel>>(
        stream: chatServices.getBlockedUsersStream(userID),
        builder: (context,snapshot){
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

          // get blocked user
          final blockedUsers = snapshot.data ?? [];

          // no blocked user
          if(blockedUsers.isEmpty){
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  Text("No blocked users"),
                ],
              ),
            );
          }

          // return list view show user messages
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context,index){
              final user = blockedUsers[index];
              return UserTile(
                text: user.userName,
                onTap:(){
                  _showUnblockUser(context,user.uid);
                } ,
              );
            },
          );
        },
      ) ,
    );
  }

  // show unblock user......
  void _showUnblockUser(context, String userID){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Unblock User"),
            content: const Text("Are you sure that you want to unblock this user?"),
            actions: [
              // cancel button
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),

              // unblock button
              TextButton(
                onPressed: (){
                  ChatServices().unblockUser(userID);
                  Navigator.pop(context);
                  showSnackBarMessage(context, "Unblock user successfully.");
                },
                child: const Text("Unblock"),
              ),
            ],
          );
        }
    );
  }
}
