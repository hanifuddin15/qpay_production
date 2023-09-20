import 'package:fluro/fluro.dart';
import 'package:qpay/routers/router_init.dart';
import 'package:qpay/views/camera/nid_scanner/nid_back_scanner_page.dart';
import 'package:qpay/views/camera/nid_scanner/nid_front_scanner_page.dart';
import 'package:qpay/views/faq/faq_page.dart';
import 'package:qpay/views/fee_calculator/fees_calculator_page.dart';
import 'package:qpay/views/home/profile/profile_view_page.dart';
import 'package:qpay/views/home/qr_scan/qr_code_payment_page.dart';
import 'package:qpay/views/home/qr_scan/scan_qr_code_page.dart';
import 'package:qpay/views/notifications/notification_page.dart';
import 'package:qpay/views/reset_password/reset_password_page.dart';
import 'package:qpay/views/support/support_page.dart';
import 'package:qpay/views/transaction_limit/transactions_limit_page.dart';

import '../views/shared/webview_gateway_page.dart';
import '../views/support/live_chat.dart';
import '../views/support/privacy_policy.dart';

class HomeRouter implements IRouterProvider{

  static String resetPasswordPage = 'home/options/security/resetPassword';
  static String nidFrontUpdatePage = 'dashboard/nidFrontUpdatePage';
  static String nidBackUpdatePage = 'dashboard/nidBackUpdatePage';
  static String profileView = 'home/options/profileView';
  static String scanQrCode = 'home/scanQrCode';
  static String qrCodePayment = 'home/scanQrCode/qrCodePayment';
  static String txnLimit = 'home/option/limit';
  static String txnFees = 'home/option/feesCalculator';
  static String faqs = 'home/option/faqs';
  static String support = 'home/option/support';
  static String supportChat = 'home/option/support/chat';
  static String notifications = 'home/option/notifications';
  static String gateway = 'home/openGateway';
  static String privacy = 'home/option/privacy';


  @override
  void initRouter(FluroRouter router) {
    router.define(resetPasswordPage,
        handler: Handler(handlerFunc: (_, __) => ResetPasswordPage()));
    router.define(nidFrontUpdatePage,
        handler: Handler(handlerFunc: (_, __) => NationalIdFrontScannerPage()));
    router.define(nidBackUpdatePage,
        handler: Handler(handlerFunc: (_, __) => NidBackScannerPage()));
    router.define(profileView,
        handler: Handler(handlerFunc: (_,__) => ProfileViewPage()));
    router.define(scanQrCode,
        handler: Handler(handlerFunc: (_, __) => ScanQrCodePage()));
    router.define(qrCodePayment,
        handler: Handler(handlerFunc: (_, __) => QrCodePaymentPage()));
    router.define(txnLimit,
        handler: Handler(handlerFunc: (_, __) => TransactionsLimitPage()));
    router.define(txnFees,
        handler: Handler(handlerFunc: (_, __) => FeesCalculatorPage()));
    router.define(faqs,
        handler: Handler(handlerFunc: (_, __) => FAQPage()));
    router.define(support,
        handler: Handler(handlerFunc: (_, __) => SupportPage()));
    router.define(supportChat,
        handler: Handler(handlerFunc: (_, __) => LiveChatPage()));
    router.define(notifications,
        handler: Handler(handlerFunc: (_, __) => NotificationPage()));
    router.define(privacy,
        handler: Handler(handlerFunc: (_, __) => PrivacyPolicyPage()));
  }
}