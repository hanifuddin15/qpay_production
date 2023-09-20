import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/support_vm.dart';
import 'package:qpay/providers/dashboard_provider.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

import '../../routers/fluro_navigator.dart';
import '../../routers/home_router.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  List<SupportViewModel> _supportList = <SupportViewModel>[];
  final provider = DashboardProvider();
  @override
  void initState() {
    super.initState();
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
            centerTitle: AppLocalizations.of(context).support,
          ),
          body: MyScrollView(
            padding: EdgeInsets.all(8.0),
            children: [
              Gaps.vGap16,
              InkWell(
                onTap: () => {_callNumber()},
                child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colours.app_main, width: .5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colours.app_main,
                              size: 36,
                            ),
                            Gaps.hGap12,
                            Text(
                              'Call Center',
                              style: TextStyle(
                                  fontSize: Dimens.font_sp16,
                                  color: Colours.text,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Gaps.vGap8,
              InkWell(
                onTap: () => {_startLiveChat()},
                child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colours.app_main, width: .5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.chat,
                              color: Colours.app_main,
                              size: 36,
                            ),
                            Gaps.hGap12,
                            Text(
                              'Live Chat',
                              style: TextStyle(
                                  fontSize: Dimens.font_sp16,
                                  color: Colours.text,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Gaps.vGap8,
              InkWell(
                onTap: () => {_sendEmail()},
                child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colours.app_main, width: .5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.email,
                              color: Colours.app_main,
                              size: 36,
                            ),
                            Gaps.hGap12,
                            Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: Dimens.font_sp16,
                                  color: Colours.text,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Gaps.vGap32,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:'Customer representatives are available from',
                        style: TextStyle(
                          color: Colours.text,
                          fontSize:Dimens.font_sp18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text:' Sunday -Thursday, 9am-6pm',
                        style: TextStyle(
                          color: Colours.text,
                          fontSize:Dimens.font_sp18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _startLiveChat(){
    NavigatorUtils.push(context, HomeRouter.supportChat);
  }
  _callNumber() async {
    const number = '+8809666727279'; //set the number here
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  _sendEmail() async {
    EmailContent email = EmailContent(
      to: [
        'support@qpaybd.com.bd',
      ],
      subject: 'QPay BD Support for - ${[provider.user.name,provider.user.phoneNumber]}',
      body: '',
      cc: [],
      bcc: [],
    );
    OpenMailAppResult result =
    await OpenMailApp.composeNewEmailInMailApp(
        nativePickerTitle: 'Select email app to compose',
        emailContent: email);
    if (!result.didOpen && !result.canOpen) {
      showNoMailAppsDialog(context);
      // iOS: if multiple mail apps found, show dialog to select.
      // There is no native intent/default app system in iOS so
      // you have to do it yourself.
    } else if (!result.didOpen && result.canOpen) {
      showDialog(
        context: context,
        builder: (_) => MailAppPickerDialog(
          mailApps: result.options,
          emailContent: email,
        ),
      );
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}
