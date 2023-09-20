import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/colors.dart';

class LiveChatPage extends StatefulWidget {
  @override
  _LiveChatPageState createState() => _LiveChatPageState();
}

class _LiveChatPageState extends State<LiveChatPage>{
  InAppWebViewController _controller;
  bool isLoading=true;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptEnabled: true,
        useOnDownloadStart: true,
      ),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  PullToRefreshController pullToRefreshController;
  double progress = 0;
  String _checkOutUrl ='https://tawk.to/chat/62dfdc4054f06e12d88b68ff/1g8t78n7j';
  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colours.app_main,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _controller?.reload();
        } else if (Platform.isIOS) {
          _controller?.loadUrl(
              urlRequest: URLRequest(url: await _controller?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).supportChat,
        ),
        body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(_checkOutUrl)),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url;
                  if (uri.toString().toLowerCase().contains('.pdf')) {
                    /*var document = await PDFDocument.fromURL(navigationAction.request.url.toString());
                   await Navigator.push(context, MaterialPageRoute(builder: (context) {
                     return PdfViewerPage(AppLocalizations.of(context).faqs,document);
                   }));*/
                    launchUrl(Uri.parse(navigationAction.request.url.toString()));
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onReceivedServerTrustAuthRequest: (controller, URLAuthenticationChallenge challenge) async {
                  return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                },
              ),
              progress < 1.0 ? LinearProgressIndicator(value: progress)
                  : Stack(),
            ]
        ),
      ),
    );
  }
}