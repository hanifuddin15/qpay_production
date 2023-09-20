import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/home_router.dart';
import 'package:qpay/views/notifications/notification_page.dart';
import 'package:qpay/widgets/global_navigator.dart';
import 'package:qpay/widgets/load_image.dart';

import 'contract/push_notification_message.dart';

class PushNotificationService {

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final navigatorKey = GlobalKey<NavigatorState>();
  BuildContext get context => null;
  Future<void> initialise() async {
    _fcm.getToken().then((deviceToken) async {
      await FirebaseMessaging.instance.subscribeToTopic('customer');
      SpUtil.putString(Constant.fcmDeviceId, deviceToken);
      print("Firebase Device token: $deviceToken");
    });
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification remoteNotification = message.notification;
      AndroidNotification androidNotification = remoteNotification?.android??null;
      AppleNotification appleNotification = remoteNotification?.apple??null;
      if (remoteNotification != null ) {
        print('Message also contained a notification: ${message.notification}');
        showOverlayNotification((context) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction){
              OverlaySupportEntry.of(context).dismiss(animate: false);
            },
            child: SafeArea(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  onTap: (){
                    _serialiseAndNavigate(message.data,'onMessage');
                    OverlaySupportEntry.of(context).dismiss();
                  },
                  leading: androidNotification != null? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(
                          image: NetworkImage(androidNotification.imageUrl ?? 'https://qpaybd.com.bd/assets/images/logo_dark.png'),
                          height: 32,
                          width: 36,
                        ),
                      ),
                    ],
                  ):appleNotification != null?Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(
                          image: NetworkImage(appleNotification.imageUrl ?? 'https://qpaybd.com.bd/assets/images/logo_dark.png'),
                          height: 32,
                          width: 36,
                        ),
                      ),
                    ],
                  ):LoadAssetImage('logo_white'),
                  title: Text(remoteNotification.title??'Notification',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                  subtitle: Text(remoteNotification.body??'Description', overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 14),),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(new DateFormat.jm().format(DateTime.now()),style: TextStyle(fontSize: 10),),
                    ],
                  ),
                ),
              ),
            ),
          );
        },duration: Duration(milliseconds: 4000));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // NavigatorUtils.push(GlobalVariable.navState.currentContext, AuthRouter.loginPage);
    });
  }
  Future<void> _serialiseAndNavigate(Map<String, dynamic> message,String callTime) async {
    var type =  message['type'];
    var accessToken = SpUtil.getString(Constant.accessToken);
    if(accessToken != "") {
      if (type == 'message') {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          NavigatorUtils.push(GlobalVariable.navState.currentContext, HomeRouter.notifications);
        });
      }
    }else{
     showDialog(context: GlobalVariable.navState.currentContext,
         builder:(BuildContext context) {
           // return object of type Dialog
           return AlertDialog(
             title: new Text("Alert!!!"),
             content:
             new Text("Please login first."),
             actions: <Widget>[
               // usually buttons at the bottom of the dialog
               new TextButton(
                 child: new Text("Accept"),
                 onPressed: () {
                   Navigator.pop(context, true);
                 },
               ),
             ],
           );
         },
     );
    }
  }
}