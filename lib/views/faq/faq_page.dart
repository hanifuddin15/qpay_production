import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/views/shared/pdf_viewer_page.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../res/colors.dart';
import 'faq_presenter.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage>{
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
  String _checkOutUrl ='https://qpaybd.com.bd/faq.html';
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
         centerTitle: AppLocalizations.of(context).faqs,
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
                   launch(navigationAction.request.url.toString());
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