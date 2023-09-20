import 'dart:ffi';

import 'package:qpay/routers/router_init.dart';
import 'package:fluro/fluro.dart';
import 'package:qpay/views/add_account/add_card_otp_page.dart';
import 'package:qpay/views/add_account/select_account_type_page.dart';
import 'package:qpay/views/add_account/add_bank_account_page.dart';
import 'package:qpay/views/add_account/add_card_page.dart';
import 'package:qpay/views/add_beneficiary/add_beneficiary_account_page.dart';
import 'package:qpay/views/atm_cashout/atm_cashout_token_create_page.dart';
import 'package:qpay/views/atm_cashout/atm_cashout_tokens_page.dart';
import 'package:qpay/views/bill_payment/bill_payment_vendor_page.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_page.dart';
import 'package:qpay/views/card_bill_payment/card_bill_payment_page.dart';
import 'package:qpay/views/cvv_change/cvv_change_page.dart';
import 'package:qpay/views/fund_transfer/fund_transfer_page.dart';
import 'package:qpay/views/mobile_recharge/contact_select_page.dart';
import 'package:qpay/views/mobile_recharge/mobile_recharge_page.dart';
import 'package:qpay/views/nid/nid_upload_page.dart';
import 'package:qpay/views/wallet_transfer/wallet_transfer_page.dart';

class DashboardRouter implements IRouterProvider {
  static String notificationPage = 'dashboard/notification';
  static String selectLinkAccountType = 'dashboard/addAccount';
  static String mobileRechargePage = 'dashboard/mobileRecharge';
  static String contactSelectPage = 'dashboard/mobileRecharge/contactSelectPage';
 static String cardBillPaymentPage = 'dashboard/cardBillPayment';
  static String addCardPage = 'dashboard/addAccount/card';
  static String addCardOTPPage = 'dashboard/addAccount/card/addCardOtp';
  static String addBankPage = 'dashboard/addAccount/bank';
  static String sendMoneyPage = 'dashboard/sendMoney';
  static String atmCashOutPage = 'dashboard/atmCashOut';
  static String nidUpdatePage = 'dashboard/nidUpdate';
  static String cashOutTokenCreatePage = 'dashboard/atmCashOutTokenCreate';
  static String addBeneficiary = 'dashboard/addBeneficiary';
  static String walletTransfer = 'dashboard/walletTransfer';
  static String billPayment = 'dashboard/billPayment';
  static String cvvChange = 'dashboard/cvvChange';


  @override
  void initRouter(FluroRouter router) {
    router.define(selectLinkAccountType,
        handler: Handler(handlerFunc: (_, __) => SelectAccountTypePage()));
    router.define(addCardPage,
        handler: Handler(handlerFunc: (_, __) => AddCardPage()));
    router.define(addBankPage,
        handler: Handler(handlerFunc: (_, __) => AddBankCardPage()));
    router.define(sendMoneyPage,
        handler: Handler(handlerFunc: (_, __) => FundTransferPage()));
    router.define(nidUpdatePage,
        handler: Handler(handlerFunc: (_, __) => NidUploadPage()));
    router.define(mobileRechargePage,
        handler: Handler(handlerFunc: (_, __) => MobileRechargePage()));
    router.define(contactSelectPage,
        handler: Handler(handlerFunc: (_, __) => MyContactPage()));
   router.define(cardBillPaymentPage,
       handler: Handler(handlerFunc: (_, __) => CardBillPaymentPage()));
   router.define(atmCashOutPage,
       handler: Handler(handlerFunc: (_, __) => AtmCashOutTokensPage()));
   router.define(cashOutTokenCreatePage,
       handler: Handler(handlerFunc: (_, __) => AtmCashOutTokenCreatePage()));
   router.define(addBeneficiary,
       handler: Handler(handlerFunc: (_,__)=> AddBeneficiaryAccountPage()));
    router.define(walletTransfer,
        handler: Handler(handlerFunc: (_,__)=> WalletTransferPage()));
    router.define(billPayment,
        handler: Handler(handlerFunc: (_,__)=> BillPaymentVendorPage()));
    router.define(cvvChange,
        handler: Handler(handlerFunc: (_,__)=> Cvv2ChangePage()));

    // router.define(addCardOTPPage,
    //     handler: Handler(handlerFunc: (_,__)=> AddCardOTPPage()));
  }
}
