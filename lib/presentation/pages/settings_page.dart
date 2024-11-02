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
        title: "Settings",
        centerTitle: true,
      ),
      body:Container(
        margin: const EdgeInsets.all(25),
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
    );
  }
}
