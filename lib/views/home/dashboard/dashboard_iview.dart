import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/notification_count_vm.dart';
import 'package:qpay/net/contract/profile_vm.dart';

abstract class DashboardIMvpView implements IMvpView {

  void setUser(ProfileViewModel user);

  void setNotificationCount(NotificationCountViewModel notificationCountViewModel);

  bool get isAccessibilityTest;

}
