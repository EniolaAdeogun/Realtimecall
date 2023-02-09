import 'dart:ffi';
import 'dart:math';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zego live streaming',
      home: HomePage(),
    );
  }
}

final String userID = Random().nextInt(900000 + 100000).toString();

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final liveIDController =
      TextEditingController(text: Random().nextInt(900000 + 100000).toString());

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF034ada),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'Assets/header_illustration.svg',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const SizedBox(height: 20),
            Text('Your user ID: $userID'),
            Text('Please test with two or more devices'),
            const SizedBox(height: 30),
            TextFormField(
              controller: liveIDController,
              decoration: InputDecoration(
                  labelText: 'Join or start a live by input an id',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  )),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => jumpTolivePage(context,
                  liveID: liveIDController.text, isHost: true),
              child: const Text('Start a live'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => jumpTolivePage(context,
                  liveID: liveIDController.text, isHost: false),
              child: const Text('Join a live'),
            ),
          ],
        ),
      ),
    );
  }

  jumpTolivePage(BuildContext context,
      {required String liveID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          liveId: liveID,
          isHost: isHost,
        ),
      ),
    );
  }
}

class LivePage extends StatelessWidget {
  final String liveId;
  final bool isHost;

  LivePage({Key? key, required this.liveId, this.isHost = false})
      : super(key: key);

  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltLiveStreaming(
            appID: appID,
            appSign: appSign,
            userID: userID,
            userName: 'user_$userID',
            liveID: liveId,
            config: isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                : ZegoUIKitPrebuiltLiveStreamingConfig.audience()));
  }
}
