import 'package:chat_app/app.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/resources/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ThemeProvider()),
      ],
      child: const ChatApp(),
    )
  );
}





