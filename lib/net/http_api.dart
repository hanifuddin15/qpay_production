
import 'package:flutter/cupertino.dart';

class ApiEndpoint{
  static const String IDSCore = "https://identity01.qpaybd.com.bd";
  static const String IDS = "https://identity01.qpaybd.com.bd/api/v1";
  static const String Q2 = "https://api01.qpaybd.com.bd/api/v2";
  static const String profile = '$Q2/profile';
  static const String search = 'search/';
  static const String register = '$IDS/accounts';
  static const String profileUpdate = '$IDS/profiles';
  static const String profileImageUpdate = '$Q2/profile/own-profile-image-upload';
  static const String requestOtp = 'account/request-otp';
  static const String phoneVerificationCodeRequest = '$IDS/verification/phone';
  static const String phoneVerificationSubmit = '$IDS/verification/phone/verify';

  static const String emailVerificationCodeRequest = '$IDS/profiles/email';
  static const String emailVerificationSubmit = '$IDS/profiles/email/verify';

  static const String deviceChange = '$IDS/accounts/device';

  static const String nidUpdate = '$IDS/kyc/ocr';
  static const String requestApproval = 'profile/request-approval';
  static const String token = '$IDSCore/connect/token';
  static const String bankList = '$Q2/financialinstitutes';
  static const String linkedOwnAccounts = 'profile/personal-accounts';
  static const String linkedAccounts = '$Q2/profile/accounts';
  static const String linkedBeneficiaryAccounts = '$Q2/beneficiaries';
  static String myTransactions(int id) => '$Q2/financialaccounts/$id/transactions';
  static const String resetPassword = '$IDS/profiles/password';
  static const String myCashOutTokens = '$Q2/virtualcash/tokens';

  static const String mobileRecharge = '$Q2/mobilerecharge';
  static const String mobileRechargeConfirm = '$Q2/mobilerecharge/auth';

  static const String atmCashOut = '$Q2/virtualcash/tokens';
  static const String atmCashOutConfirm = '$Q2/virtualcash/tokens/auth';

  static const String fundTransfer = '$Q2/fundtransfer';
  static const String cardBill = '$Q2/fundtransfer/card-bill';
  static const String bkashCashIn = '$Q2/fundtransfer/bkash';
  static const String fundTransferConfirm = '$Q2/fundtransfer/auth';

  static const String cardBillPayment = '$Q2/transactions/fund-transfer/2';
  static const String cardBillPaymentConfirm = '$Q2/transactions/fund-transfer/2/auth';

  static const String cvvChangePayment = '$Q2/cardverificationvalue';
  static const String cvvChangePaymentConfirm = '$Q2/cardverificationvalue/auth';

  static const String bankAccountLink = '$Q2/banklink';
  static const String bankAccountUnLink = '$Q2/banklink/remove';

  static const String beneficiaryAdd = '$Q2/beneficiaries';
  static const String beneficiaryAddBkash = '$Q2/beneficiaries/bkash';


  static const String cardLink = '$Q2/financialaccounts/cards';
  static const String cardLinkVerify = '$Q2/financialaccounts/cards/verify';
  static String beneficiaryUnLink(int id) => '$Q2/beneficiaries/$id';
  static String accountUnLink(int id) => '$Q2/financialaccounts/$id';

  static  String accountBalance = '$Q2/financialaccounts/balance';
  static  String accountStatement = '$Q2/financialaccounts/statement';
  static const String forgetPassword = '$IDS/accounts/password/token';
  static const String forgetPasswordConfirm = '$IDS/password/password/reset';

  static const String emiRequest = '$Q2/financialaccounts/emi';
  static String tqRequest(int id) => '$Q2/financialaccounts/$id/tq';
  static  String accountDetail(int id) => '$Q2/financialaccounts/$id/details';
  static  String checkReward(int id) => '$Q2/financialaccounts/$id/rewards';
  static  String checkStatus(int id) => '$Q2/financialaccounts/cards/$id/status';
  static  String checkEMIDetail(int id) => '$Q2/financialaccounts/$id/emi-details';
  static const String qrCodeRequest = '$Q2/qrcode';
  static const String merchantByQrRequest = '$Q2/qrcode/terminus';
  static const String qrCodePayment = '$Q2/payment/qr-code/1';
  static const String qrCodePaymentConfirm = '$Q2/payment/qr-code/1/auth';
  static const String transactionLimit = '$Q2/transactions/limits';
  static const String transactionCategory = '$Q2/transactions';
  static const String transactionFees = '$Q2/transactions/fees';

  static const String vendorList = '$Q2/vendors';
  static const String vendorCategory = '$Q2/vendors/utilities';
  static String vendorParams(int id) => '$Q2/vendors/$id/utilitydetails';
  static const String billPayment = '$Q2/billpayments/initiateutilitypayment';
  static const String billPaymentInquiry = '$Q2/billpayments/inquiryutilitypayment';
  static const String billPaymentConfirm = '$Q2/billpayments/authpayment';
  static const String akashSubscriberCheck = '$Q2/billpayments/akash/subscriber';
  static const String notificationCount = '$Q2/notifications/count';
  static const String faqList = '$Q2/generalinformation/faq';
  static String notificationsList(pageNumber,isRead,pageSize) => '$Q2/notifications?PageNumber=$pageNumber&IsRead=$isRead&PageSize=$pageSize';
  static  String getTransactionById(String txnId) => '$Q2/transactions/$txnId/details';
}