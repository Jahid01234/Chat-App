import 'package:chat_app/app.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/resources/themes/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'data/constants/app_info.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set navigator key for Zego
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(ChatApp.navigatorKey);

  // Check if user is already logged in and initialize Zego
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    debugPrint('User already logged in: ${currentUser.email}');
    await _initZegoForUser(currentUser);
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





// Initialize Zego for user.......................
Future<void> _initZegoForUser(User user) async {
  try {
    debugPrint('🔄 Starting Zego initialization for: ${user.email}');

    // First uninit if already initialized
    try {
      await ZegoUIKitPrebuiltCallInvitationService().uninit();
      debugPrint('Previous Zego session cleared');
    } catch (e) {
      debugPrint('No previous session to clear');
    }

    // Small delay to ensure clean state
    await Future.delayed(const Duration(milliseconds: 300));

    // Use system calling UI
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    // Initialize Zego call invitation service
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppInfo.appId,
      appSign: AppInfo.appSign,
      userID: user.uid,
      userName: user.email ?? user.uid,
      plugins: [ZegoUIKitSignalingPlugin()],
    );

    debugPrint('✅ Zego initialized successfully for: ${user.email}');
    debugPrint('✅ User ID: ${user.uid}');
    debugPrint('✅ Ready to send/receive calls');
  } catch (e) {
    debugPrint('❌ Error initializing Zego: $e');
  }
}