import 'package:chat_app/app.dart';
import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/resources/themes/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set navigator key for Zego
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(ChatApp.navigatorKey);
  // Check if user is already logged in and initialize Zego
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await AuthServices().initZegoForUser(currentUser);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const ChatApp(),
    ),
  );
}






