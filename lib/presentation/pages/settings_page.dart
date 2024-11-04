import 'package:chat_app/presentation/pages/blocked_users_page.dart';
import 'package:chat_app/presentation/widgets/app_bar_widget.dart';
import 'package:chat_app/resources/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // access the ThemeProvider class
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(
        title: "SETTINGS",
        centerTitle: true,
      ),
      body:Column(
        children: [
          // Dark/light mode.............
          Container(
            margin: const EdgeInsets.only(top: 25,left: 25,right: 25),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Light and dark mode text show
                Text(
                    themeProvider.isLightMode? "Light Mode" : "Dark Mode",
                    style: TextStyle(
                      color: themeProvider.isLightMode? Colors.grey :null,
                      fontSize: 16,
                    ),
                ),

                // switch toggle
                CupertinoSwitch(
                  value: themeProvider.isLightMode,
                  onChanged: (value){
                      themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
          ),

          // Block user button...........
          Container(
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Block user text show
                Text(
                   "Blocked user" ,
                  style: TextStyle(
                    color: themeProvider.isLightMode? Colors.grey :null,
                    fontSize: 16,
                  ),
                ),

                // arrow Icon button, go to block user page
                IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> const BlockedUsersPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                             Icons.arrow_forward_ios,
                             color: Colors.grey,
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
