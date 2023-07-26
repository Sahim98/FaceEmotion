import 'package:flutter/material.dart';
import 'package:sass/sass.dart' as sass;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SassCodeHighlight extends StatelessWidget {
  final String sassCode = '''
      <html>
      <head>
        <style>
          ${compileSassToCss('''
            \$primaryColor: #800080;
            \$sz:40px;
        
            .container {
              font-size: \$sz;
              background-color: \$primaryColor;
              color: #ffffff;
              padding: 16px;
              position: relative;
              overflow: hidden;
              height: 120px;
            
            }
          
            .highlight {
              font-weight: bold;
              position: absolute;
              top: 60%;
              left: -200%;
              transform: translate(-50%, -50%);
              animation: slideText 8s infinite linear;
            }
            
            .static-text {
              margin-right: 25px; /* Add margin between static text and moving text */
            }
            
            @keyframes slideText {
              0% { left: -100%; }
              100% { left: 100%; }
            }
          ''')}
        </style>
      </head>
      <body>
        <div class="container">
          Some picture create memories.
          <span class="static-text"> </span>
          <span class="highlight">Recent POST</span>
        </div>
      </body>
      </html>
    ''';

  static String compileSassToCss(String sassCode) {
    
    // ignore: deprecated_member_use
    final cssCode = sass.compileString(sassCode);
    return cssCode.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialData: InAppWebViewInitialData(data: sassCode),
      ),
    );
  }
}
