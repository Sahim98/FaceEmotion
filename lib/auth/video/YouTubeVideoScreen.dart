import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';

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
                            loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      // The image has been loaded successfully.
                                                      return child;
                                                    } else if (loadingProgress
                                                            .cumulativeBytesLoaded ==
                                                        loadingProgress
                                                            .expectedTotalBytes) {
                                                      // The image failed to load.
                                                      return Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        height: 30,
                                                        width: 150,
                                                        child: const Text(
                                                            'Failed to load!!'),
                                                      );
                                                    } else {
                                                      // The image is still loading.
                                                      return Container(
                                                          child: Lottie.network(
                                                              'https://lottie.host/a2c7b6fe-1363-4562-95e7-1375d3568f92/zmqqT186Ei.json'));
                                                    }
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    // Error occurred while loading the image.
                                                    return Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey[300],
                                                      ),
                                                      height: 30,
                                                      width: 150,
                                                      child: const Text(
                                                          'Failed to load!!'),
                                                    );
                                                  },

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
