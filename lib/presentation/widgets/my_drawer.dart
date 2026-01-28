import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:chat_app/presentation/pages/live_streaming_page.dart';
import 'package:chat_app/presentation/pages/profile_page.dart';
import 'package:chat_app/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    // logout  method..........
    void logout() async {
      // access the authServices
      final authServices = AuthServices();
      await authServices.signOut();
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // Logo
          DrawerHeader(
            child: Icon(
              Icons.message,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),

          // Home list tile
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 8),
            child: ListTile(
              leading: Icon(Icons.home,color: Theme.of(context).colorScheme.primary,),
              title: Text('Home',style: TextStyle(
                 color: Theme.of(context).colorScheme.primary,
               ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),

          // Live streaming tile
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 8),
            child: ListTile(
              leading: Icon(Icons.videocam,color: Theme.of(context).colorScheme.primary,),
              title: Text('Live  Streaming',style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>  const LiveStreamingPage(),
                 ),
                );
              },
            ),
          ),

          // Settings list tile
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 8),
            child: ListTile(
              leading: Icon(Icons.person,color: Theme.of(context).colorScheme.primary,),
              title: Text('Profile',style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> const ProfilePage(),
                ),
                );
              },
            ),
          ),

          // Settings list tile
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 8),
            child: ListTile(
              leading: Icon(Icons.settings,color: Theme.of(context).colorScheme.primary,),
              title: Text('Settings',style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
               ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> const SettingsPage(),
                  ),
                );
              },
            ),
          ),

          // Logout list tile
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 8,),
            child: ListTile(
                leading: Icon(Icons.logout,color: Theme.of(context).colorScheme.primary,),
                title: Text('Log out',style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                ),
                onTap: (){
                  logout();
                }
            ),
          ),
        ],
      ),
    );
  }
}
