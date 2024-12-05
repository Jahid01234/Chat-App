import 'package:chat_app/data/constants/app_info.dart';
import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';


class CallInvitationPage extends StatefulWidget {
  final String callId;

  const CallInvitationPage({
    super.key,
    required this.callId,
  });

  @override
  State<CallInvitationPage> createState() => _CallInvitationPageState();
}

class _CallInvitationPageState extends State<CallInvitationPage> {
  // access the auth Services
  final AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:AppInfo.appId,
      appSign: AppInfo.appSign,
      callID: widget.callId,
      userID: authServices.getCurrentUser()!.uid,
      userName: authServices.getCurrentUser()!.email.toString(),
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );

  }
}

