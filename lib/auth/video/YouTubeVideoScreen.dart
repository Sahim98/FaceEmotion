import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YouTubeVideoScreen extends StatefulWidget {
  const YouTubeVideoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _YouTubeVideoScreenState createState() => _YouTubeVideoScreenState();
}

class _YouTubeVideoScreenState extends State<YouTubeVideoScreen> {
  InAppWebViewController? _webViewController;
  int _index = 0;

  final List<String> videoIds = [
    'hG_HD4WmAdc',
    'BhWjnTa03xs',
    '_ghMnRe2K_s',
    'PH71ZLSGNdE',
    'CrGJVEQqjsE',
    'E1wiyp01m3s',
    // Add more video IDs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      'https://www.youtube.com/embed/${videoIds[_index]}'),
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
              ),
            ),
            const Center(
              child: Text(
                'More videos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Builder(
                builder: (BuildContext context) {
                  return GridView.builder(
                    itemCount: videoIds.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final videoId = videoIds[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _index = index;
                          });
                          setState(() {
                            _loadYoutubeVideo(videoId);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.all(6.0),
                          child: Image.network(
                            'https://img.youtube.com/vi/$videoId/0.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadYoutubeVideo(String videoId) {
    if (_webViewController != null) {
      _webViewController!.loadUrl(
        urlRequest: URLRequest(
          url: Uri.parse('https://www.youtube.com/embed/$videoId'),
        ),
      );
    }
  }
}
