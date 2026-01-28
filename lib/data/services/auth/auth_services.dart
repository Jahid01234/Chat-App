import 'package:chat_app/data/constants/app_info.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';


class AuthServices{
  // instance of auth and FireStore..........
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user....................
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  // Initialize Zego for user audio/video call function.....................
  Future<void> initZegoForUser(User user) async {
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
        appID: AppAudioVideoInfo.appId,
        appSign: AppAudioVideoInfo.appSign,
        userID: user.uid,
        userName: user.email ?? user.uid,
        plugins: [ZegoUIKitSignalingPlugin()],
      );

      if (kDebugMode) {
        print('✅ Zego initialized successfully for: ${user.email}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing Zego: $e');
      }
    }
  }

  // sign in.............................
  Future<UserCredential> signInWithEmailAndPassword(String email,password) async{
    try {
      // try log in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );



      // save user information if it does not already exit
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            'uid' : userCredential.user!.uid,
            'email' : email,
          }
      );



      // Initialize Zego after successful login
      await initZegoForUser(userCredential.user!);
      return userCredential;

    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }


  // sign up...........................
  Future<UserCredential> signUpWithEmailPassword(String userName,email,password) async{
    try {
      // create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user information in a separate doc
      // _firestore.collection("Users").doc(userCredential.user!.uid).set(
      //   {
      //     'uid' : userCredential.user!.uid,
      //     'email' : email,
      //   }
      // );

      final userModel = UserModel(
        uid: userCredential.user!.uid,
        userName: userName,
        email: email,
        profileImage: '',
        createdAt: DateTime.now(),
      );

      // ✅ Save user info to Firestore
      await _firestore.collection('Users').doc(userCredential.user!.uid).set(userModel.toMap());


      // Initialize Zego after successful login
      await initZegoForUser(userCredential.user!);
      return userCredential;

    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  // update user live status......
  Future<void> updateLiveStatus( String userId, bool isLive, String? liveId) async{
    await _firestore.collection("Users").doc(userId).update({
      'isLive': isLive,
      'liveId': liveId,
    });
  }

   // sign out..................
  Future<void> signOut() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    await _auth.signOut();
  }
}






