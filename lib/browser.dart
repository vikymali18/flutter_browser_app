import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

import 'helpers.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late WebViewXController webviewController;
  final scrollController = ScrollController();

  final initialContent =
      '<h4> This is some hardcoded HTML code embedded inside the webview <h4> <h2> Hello world! <h2>';
  final executeJsErrorMessage =
      'Failed to execute this task because the current content is (probably) URL that allows iFrame embedding, on Web.\n\n'
      'A short reason for this is that, when a normal URL is embedded in the iFrame, you do not actually own that content so you cant call your custom functions\n'
      '(read the documentation to find out why).';

  Size get screenSize => MediaQuery.of(context).size;

  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: _textController,
            keyboardType: TextInputType.url,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Enter your text here...',
            ),
            onSubmitted: (value) {
              webviewController.loadContent('https://' + value);
            },
          ),
          actions: [
            TextButton(
              child: Text('Go'),
              onPressed: () {
                // String text = ;
                webviewController
                    .loadContent('https://' + _textController.text);
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
          ),
          child: _buildWebViewX(),
        ),
      ),
    );
  }

  Widget _buildWebViewX() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: "https://www.flutter.dev",
      initialSourceType: SourceType.url,
      // initialContent: initialContent,
      // initialSourceType: SourceType.html,
      height: screenSize.height,
      width: screenSize.width,
      // height: screenSize.height / 2,
      // width: min(screenSize.width * 0.8, 1024),
      onWebViewCreated: (controller) => webviewController = controller,
      onPageStarted: (src) =>
          debugPrint('A new page has started loading: $src\n'),
      onPageFinished: (src) =>
          debugPrint('The page has finished loading: $src\n'),
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },
      dartCallBacks: {
        DartCallback(
          name: 'TestDartCallback',
          callBack: (msg) => showSnackBar(msg.toString(), context),
        )
      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
      navigationDelegate: (navigation) {
        debugPrint(navigation.content.sourceType.toString());
        return NavigationDecision.navigate;
      },
    );
  }
}
