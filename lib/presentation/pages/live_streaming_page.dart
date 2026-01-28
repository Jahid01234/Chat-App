import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:chat_app/data/services/chat/chat_services.dart';
import 'package:chat_app/presentation/pages/live_page.dart';
import 'package:chat_app/presentation/widgets/app_bar_widget.dart';
import 'package:chat_app/presentation/widgets/snack_bar_message.dart';
import 'package:chat_app/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';


class LiveStreamingPage extends StatefulWidget {
  const LiveStreamingPage({super.key});

  @override
  State<LiveStreamingPage> createState() => _LiveStreamingPageState();
}

class _LiveStreamingPageState extends State<LiveStreamingPage> {
  final ChatServices chatServices = ChatServices();
  final AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(
        title: "Live Streaming",
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10,left: 15, right: 15),
        child: StreamBuilder(
          stream: chatServices.getUsersStreamExcludingBlocked(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }

            if(!snapshot.hasData || snapshot.data!.isEmpty){
              return const Center(child: Text("No users available."));
            }

            List<UserModel> users = snapshot.data!;
            users.sort((a,b){
              if(a.isLive && !b.isLive) return -1;
              if(!a.isLive && b.isLive) return -1;
              return 0;
            });

            return GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: users.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.78
              ),
              itemBuilder: (context, index){
                final user = users[index];
                return UserCard(
                  user: user,
                  onTap: ()=> handleUserOnTap(user)
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.teal,
        onPressed: ()=>startLiveStreaming(),
        icon: const Icon(
          Icons.videocam,
          color: Colors.white,
        ),
        label: const Text(
          "Go Live",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }


  // start live streaming...............
  Future<void> startLiveStreaming() async {
    final currentUser = authServices.getCurrentUser()!;
    final currentUserId = authServices.getCurrentUser()!.uid;
    final liveId = "${currentUserId}_${DateTime.now().microsecondsSinceEpoch}";

    await authServices.updateLiveStatus(currentUserId, true, liveId);

    await Navigator.push(context, MaterialPageRoute(
        builder: (context)=>  LivePage(
          userId: currentUserId,
          userName: currentUser.displayName ?? "Host",
          isHost: true,
          liveId: liveId,
          hostName: currentUser.displayName ?? "Host",
        )
     ),
    );
    await  authServices.updateLiveStatus(currentUserId, false, null);
  }

  // user onTap..................
  void handleUserOnTap(UserModel user){
    if(user.isLive && user.liveId != null){
      // join live stream as audience..
      Navigator.push(context, MaterialPageRoute(
        builder: (context)=>  LivePage(
          userId: authServices.getCurrentUser()!.uid,
          userName: authServices.getCurrentUser()!.displayName ?? "Audience",
          isHost: false,
          liveId: user.liveId!,
          hostName: user.userName,
        )
       ),
      );
    } else{
      // user is not live...
      showSnackBarMessage(context,"${user.userName} is not live right now." );
    }
  }
}