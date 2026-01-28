import 'package:chat_app/data/constants/app_info.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatelessWidget {
  final String userId;
  final String userName;
  final bool isHost;
  final String liveId;
  final String hostName;

  const LivePage({
    super.key,
    required this.userId,
    required this.userName,
    required this.isHost,
    required this.liveId,
    required this.hostName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: AppLiveStreamingInfo.appId,
        appSign: AppLiveStreamingInfo.appSign,
        userID: userId,
        userName: userName,
        liveID: liveId,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}