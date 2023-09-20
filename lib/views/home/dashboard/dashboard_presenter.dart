import 'package:flutter/material.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/notification_count_vm.dart';
import 'package:qpay/net/contract/profile_vm.dart';
import 'package:qpay/providers/dashboard_provider.dart';
import 'package:qpay/views/home/dashboard/dashboard_iview.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';

class DashboardPagePresenter extends BasePagePresenter<DashboardIMvpView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var storedUser = DashboardProvider().user;
      if (view.isAccessibilityTest && (storedUser != null) ) {
        view.setUser(storedUser);
        return;
      }
      try {
        loadProfile();
        notificationCount();
      } catch (e) {
        view.showErrorDialog('Failed to get response!');
        view.closeProgress();
      }
    });
  }

  Future loadProfile() async{
    asyncRequestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.profile,
      onSuccess: (data) {
        ProfileViewModel userData = ProfileViewModel.fromJson(data);
        view.setUser(userData);
      },
    );
  }

  Future<ApiBasicViewModel> requestApproval() async {
    ApiBasicViewModel response;
    try {
      await requestNetwork(
        Method.post,
        url: ApiEndpoint.requestApproval,
        onSuccess: (data) {
          response = ApiBasicViewModel.fromJson(data);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
    }
    return response;
  }

  Future<NotificationCountViewModel> notificationCount() async {
    NotificationCountViewModel response;
    try {
      await requestNetwork(
        Method.get,
        url: ApiEndpoint.notificationCount,
        onSuccess: (data) {
          var items = data["body"];
          response = NotificationCountViewModel.fromJson(items);
          view.setNotificationCount(response);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
    }
    return response;
  }


}
