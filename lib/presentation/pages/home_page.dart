import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:chat_app/data/services/chat/chat_services.dart';
import 'package:chat_app/presentation/pages/chat_page.dart';
import 'package:chat_app/presentation/widgets/my_drawer.dart';
import 'package:chat_app/presentation/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // access the auth and chat Services
  final AuthServices authServices = AuthServices();
  final ChatServices chatServices = ChatServices();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: const Text("USERS"),
        centerTitle:true ,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of users expect for the current logged in user..............
  Widget _buildUserList(){
     return StreamBuilder(
       stream: chatServices.getUsersStreamExcludingBlocked(),
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

         // return list view show user email data
         return ListView(
           primary: false,
           shrinkWrap: true,
           scrollDirection: Axis.vertical,
           children: snapshot.data!
               .map<Widget>((userData) =>
               _buildUserListItem(userData, context)).toList(),
         );
       },
     );
  }


    // build individual list tile for user..................................
    Widget _buildUserListItem(Map<String, dynamic> userData, context){
      // display all users except current user
      if(userData['email'] != authServices.getCurrentUser()!.email) { // do not show current user email
        return UserTile(
          text: userData["email"],
          onTap: () {
            // go to chat page
            Navigator.push(context, MaterialPageRoute(
              builder: (context) =>
                  ChatPage(
                    receiverEmail: userData["email"],
                    receiverID: userData["uid"],
                  ),
              ),
            );
          },
        );
      }else{
        return Container();
      }
    }

}
