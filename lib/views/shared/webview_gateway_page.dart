import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/views/shared/webview_gateway_iview.dart';
import 'package:qpay/views/shared/webview_gateway_page_presenter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../mvp/base_page.dart';
import '../../widgets/app_bar.dart';

class WebViewGatewayPage extends StatefulWidget{
  final String title;
  final String checkOutUrl;

  WebViewGatewayPage(this.title, this.checkOutUrl);
  @override
  _WebViewGatewayPageState createState() => _WebViewGatewayPageState(title,checkOutUrl);

}

class _WebViewGatewayPageState extends State<WebViewGatewayPage>
    with
        BasePageMixin<WebViewGatewayPage, WebViewGatewayPresenter>,
        AutomaticKeepAliveClientMixin<WebViewGatewayPage>
    implements WebViewGatewayIMvpView {
  TransactionViewModel txnVm;
  InAppWebViewController _controller;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
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
  final String _title;
  final String _checkOutUrl;
  _WebViewGatewayPageState(this._title, this._checkOutUrl);

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: _title,
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
                if (uri.toString().toLowerCase().contains('cardsuccessfail/cardsuccess')) {//converts string to a uri
                  Map<String, String> params = uri.queryParameters; // query parameters automatically populated
                  var id = params['id'].toUpperCase();
                  getTransactionById(context,id);
                  return NavigationActionPolicy.CANCEL;
                }
                if (uri.toString().toLowerCase().contains('cardsuccessfail/cardfail')) {//converts string to a uri
                  Map<String, String> params = uri.queryParameters; // query parameters automatically populated
                  var id = params['id'].toUpperCase();
                  getTransactionById(context,id);
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

  void getTransactionById(BuildContext context,String txnId) async {
    var response = await presenter.getTransactionById(txnId);
    if (response != null) {
      txnVm = response;
      NavigatorUtils.goBackWithParams(context, txnVm);
    }
  }


  @override
  WebViewGatewayPresenter createPresenter() => WebViewGatewayPresenter();

  @override
  bool get wantKeepAlive => true;

}