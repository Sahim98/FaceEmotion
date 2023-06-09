import 'package:facecam/auth/video/video.dart';
import 'package:flutter/material.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: Container(
                color: Colors.white,
                child: Video(
                    url:
                        "https://www.youtube.com/watch?v=Ztd5vvfYmC4&ab_channel=Ben10Hindi")),
          ),
          Expanded(
            child: Container(
                color: Colors.white,
                child: Video(
                    url:
                        "https://www.youtube.com/watch?v=mTsoDEzllFU&ab_channel=GeneralDasher")),
          ),
        ],
      )),
    );
  }
}

/*
Video(url:"https://www.youtube.com/watch?v=W-rHIsDFrzQ&ab_channel=CarelessCoders"),
*/