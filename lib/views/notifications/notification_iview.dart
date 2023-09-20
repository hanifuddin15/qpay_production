import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/notification_vm.dart';

abstract class NotificationIMvpView implements IMvpView {
  void setNotifications(List<NotificationViewModel> notifications);
}