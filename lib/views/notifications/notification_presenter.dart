import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/notification_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';

import 'notification_iview.dart';

class NotificationPresenter extends BasePagePresenter<NotificationIMvpView>{
  final int pageNumber;
  final bool isRead;
  final int pageSize;


  NotificationPresenter(this.pageNumber, this.isRead, this.pageSize);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       await loadNotifications(pageNumber,isRead,pageSize);
    });
  }
  Future<List<NotificationViewModel>> loadNotifications(int pageNumber,bool isRead, int pageSize) async{
    try {
      await asyncRequestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.notificationsList(pageNumber, isRead, pageSize),
        onSuccess: (data) {
          var items = data["body"] as List;
          var notifications = items
              .map((value) => NotificationViewModel.fromJson(value))
              .toList();
          view.setNotifications(notifications);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
  }
}