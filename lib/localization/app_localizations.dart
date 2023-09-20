// Once you've added a Intl.message get run the commands below to update the generated arb and dart files
// flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/localization/l10n lib/localization/app_localizations.dart
// flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/localization/l10n --no-use-deferred-loading lib/localization/app_localizations.dart lib/localization/l10n/intl_*.arb
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;

  String get allTxn {
    return Intl.message(
      'All',
      name: 'allTxn',
      desc: 'allTxn',
      locale: localeName,
    );
  }
  String get qPayTxn {
    return Intl.message(
      'Qpay Transactions',
      name: 'qPayTxn',
      desc: 'qPayTxn',
      locale: localeName,
    );
  }
  String get emiTxn {
    return Intl.message(
      'EMI',
      name: 'emiTxn',
      desc: 'emiTxn',
      locale: localeName,
    );
  }
  String get validToken {
    return Intl.message(
      'Valid',
      name: 'validToken',
      desc: 'validToken',
      locale: localeName,
    );
  }
  String get expiredToken {
    return Intl.message(
      'Revoked',
      name: 'expiredToken',
      desc: 'expiredToken',
      locale: localeName,
    );
  }
  String get reverseToken {
    return Intl.message(
      'Reversed',
      name: 'reverseToken',
      desc: 'reverseToken',
      locale: localeName,
    );
  }
  String get reversePendingToken {
    return Intl.message(
      'Pending',
      name: 'reversePendingToken',
      desc: 'reversePendingToken',
      locale: localeName,
    );
  }
  String get withdrawnToken {
    return Intl.message(
      'Withdrawn',
      name: 'withdrawnToken',
      desc: 'withdrawnToken',
      locale: localeName,
    );
  }
  String get fixThis {
    return Intl.message(
      'Verify',
      name: 'fixThis',
      desc: 'fixThis',
      locale: localeName,
    );
  }

  String get extendThis {
    return Intl.message(
      'Extend',
      name: 'extendThis',
      desc: 'extendThis',
      locale: localeName,
    );
  }
  String get profile {
    return Intl.message(
      'User Profile',
      name: 'profile',
      desc: 'profile',
      locale: localeName,
    );
  }
  String get cashByCodeTokens {
    return Intl.message(
      'Cash by code tokens',
      name: 'cashByCodeTokens',
      desc: 'cashByCodeTokens',
      locale: localeName,
    );
  }

  String get cashByCode {
    return Intl.message(
      'Cash by code',
      name: 'cashByCode',
      desc: 'cashByCode',
      locale: localeName,
    );
  }
  String get changeCvv2 {
    return Intl.message(
      'Generate OWN CVV2',
      name: 'changeCvv2',
      desc: 'changeCvv2',
      locale: localeName,
    );
  }

  String get cardBalance {
    return Intl.message(
      'Card Balance',
      name: 'cardBalance',
      desc: 'cardBalance',
      locale: localeName,
    );
  }

  String get accountStatement {
    return Intl.message(
      'Account Statement',
      name: 'accountStatement',
      desc: 'accountStatement',
      locale: localeName,
    );
  }

  String get cashOutTokenExpireTime {
    return Intl.message(
      'Expiry: ',
      name: 'cashOutTokensExpireTime',
      desc: 'cashOutTokensExpireTime',
      locale: localeName,
    );
  }

  String get cashOutTokenTimeExtend {
    return Intl.message(
      'Token Time',
      name: 'cashOutTokenTimeExtend',
      desc: 'cashOutTokenTimeExtend',
      locale: localeName,
    );
  }

  String get cashOutTokenTimeExtendMessage {
    return Intl.message(
      'Token time extended successfully',
      name: 'cashOutTokenTimeExtend',
      desc: 'cashOutTokenTimeExtend',
      locale: localeName,
    );
  }

  String get tokenList {
    return Intl.message(
      'Token\'s',
      name: 'tokenList',
      desc: 'tokenList',
      locale: localeName,
    );
  }

  String get transactionStatementHistory {
    return Intl.message(
      'Transaction History',
      name: 'statement',
      desc: 'statement',
      locale: localeName,
    );
  }

  String get registrationComplete {
    return Intl.message(
      'Temporary Registration Completed',
      name: 'registrationComplete',
      desc: 'registrationComplete',
      locale: localeName,
    );
  }

  String get profileUpdate {
    return Intl.message(
      'Profile information updated',
      name: 'profileUpdate',
      desc: 'profileUpdate',
      locale: localeName,
    );
  }

  String get profileComplete {
    return Intl.message(
      'Complete profile',
      name: 'profileComplete',
      desc: 'profileComplete',
      locale: localeName,
    );
  }

  String get pinReset {
    return Intl.message(
      'PIN Reset',
      name: 'PINReset',
      desc: 'PINReset',
      locale: localeName,
    );
  }
  String get okay {
    return Intl.message(
      'Okay',
      name: 'okay',
      desc: 'okay',
      locale: localeName,
    );
  }

  String get tryAgain {
    return Intl.message(
      'Try Again',
      name: 'tryAgain',
      desc: 'tryAgain',
      locale: localeName,
    );
  }

  String get pinResetComplete {
    return Intl.message(
      'PIN Reset Successfully',
      name: 'PINResetComplete',
      desc: 'PINResetComplete',
      locale: localeName,
    );
  }

  String get statementDetails {
    return Intl.message(
      'Statement Details',
      name: 'cardDetails',
      desc: 'cardDetails',
      locale: localeName,
    );
  }

  String get emiDetails {
    return Intl.message(
      'EMI Details',
      name: 'emiDetails',
      desc: 'emiDetails',
      locale: localeName,
    );
  }

  String get checkBalance {
    return Intl.message(
      'Card/Account Balance',
      name: 'checkBalance',
      desc: 'checkBalance',
      locale: localeName,
    );
  }

  String get checkStatement {
    return Intl.message(
      'Check Statement',
      name: 'checkStatement',
      desc: 'checkStatement',
      locale: localeName,
    );
  }

  String get transactionControl {
    return Intl.message(
      'Transaction Control',
      name: 'transactionControl',
      desc: 'transactionControl',
      locale: localeName,
    );
  }

  String get unlinkAccount {
    return Intl.message(
      'Unlink your Card/Account',
      name: 'unlinkAccount',
      desc: 'unlinkAccount',
      locale: localeName,
    );
  }
  String get txnFees {
    return Intl.message(
      'Fee Calculator',
      name: 'txnFees',
      desc: 'txnFees',
      locale: localeName,
    );
  }

  String get menuOptions {
    return Intl.message(
      'Options',
      name: 'menuOptions',
      desc: 'menuOptions',
      locale: localeName,
    );
  }

  String get pleaseCompleteYourProfile {
    return Intl.message(
      'Please complete your profile',
      name: 'pleaseCompleteYourProfile',
      desc: 'pleaseCompleteYourProfile',
      locale: localeName,
    );
  }

  String get pleaseContactWithCallCenter {
    return Intl.message(
      'Press below icon for OTP',
      name: 'pleaseContactWithCallCenter',
      desc: 'pleaseContactWithCallCenter',
      locale: localeName,
    );
  }

  String get pressTheIcon {
    return Intl.message(
      'Press the icon to call',
      name: 'pressTheIcon',
      desc: 'pressTheIcon',
      locale: localeName,
    );
  }

  String get pinMustContain {
    return Intl.message(
      "Guidelines for PIN set up:"
          "\n\n\t1. PIN code must be 6 digits in length."
          "\n\n\t2. Use only numeric digits when entering your PIN."
          "\n\n\t3. Do not use zero (0) as the first digit of your PIN."
          "\n\n\t4. Do not use sequential or same numeric digits consecutively as your PIN; E.g. 123456, 987654, 112376, 333444, 555555 etc."
          "\n\n\t5. You can not repeat last 5 used PIN Codes as your new PIN.",
      name: 'pinMustContain',
      desc: 'pinMustContain',
      locale: localeName,
    );
  }

  String get mobileRechargePrePaidAmountLimit {
    return Intl.message(
      "Minimum ৳ 20 - Maximum ৳ 1,000",
      name: 'mobileRechargePrePaidAmountLimit',
      desc: 'mobileRechargePrePaidAmountLimit',
      locale: localeName,
    );
  }
  String get mobileRechargePostAmountLimit {
    return Intl.message(
      "Minimum ৳ 20 - Maximum ৳ 2,000",
      name: 'mobileRechargePostAmountLimit',
      desc: 'mobileRechargePostAmountLimit',
      locale: localeName,
    );
  }

  String get atmCashOutAmountLimit {
    return Intl.message(
      "Minimum ৳ 500 - Maximum ৳ 20,000",
      name: 'atmCashOutAmountLimit',
      desc: 'atmCashOutAmountLimit',
      locale: localeName,
    );
  }

  String get fundTransferAmountLimit {
    return Intl.message(
      "Minimum ৳ 500 - Maximum ৳ 1,00,000",
      name: 'fundTransferAmountLimit',
      desc: 'fundTransferAmountLimit',
      locale: localeName,
    );
  }

  String get cardBillAmountLimit {
    return Intl.message(
      "Minimum ৳ 0 - Maximum ৳ 2,00,000",
      name: 'cardBillAmountLimit',
      desc: 'cardBillAmountLimit',
      locale: localeName,
    );
  }

  String get mfsTransferAmountLimit {
    return Intl.message(
      "Minimum ৳ 50 - Maximum ৳ 50,000",
      name: 'mfsTransferAmountLimit',
      desc: 'mfsTransferAmountLimit',
      locale: localeName,
    );
  }

  String get qrCodePaymentAmountLimit {
    return Intl.message(
      "Minimum ৳ 100 - Maximum ৳ 1,00,000",
      name: 'mfsTransferAmountLimit',
      desc: 'mfsTransferAmountLimit',
      locale: localeName,
    );
  }

  String get billPaymentAmountLimit {
    return Intl.message(
      "Minimum ৳ 10",
      name: 'billPaymentAmountLimit',
      desc: 'billPaymentAmountLimit',
      locale: localeName,
    );
  }

  String get pinDidNotMatch {
    return Intl.message(
      'PIN did not matched',
      name: 'pinDidNotMatch',
      desc: 'pinDidNotMatch',
      locale: localeName,
    );
  }

  String get pinChangedSuccessfully {
    return Intl.message(
      'Your PIN changed successfully.',
      name: 'pinChangedSuccessfully',
      desc: 'pinChangedSuccessfully',
      locale: localeName,
    );
  }


  String get emailVerifyTitle {
    return Intl.message(
      'Email Verify',
      name: 'emailVerifyTitle',
      desc: 'emailVerifyTitle',
      locale: localeName,
    );
  }

  String get emailVerifySuccess {
    return Intl.message(
      'Email successfully Verified',
      name: 'emailVerifySuccess',
      desc: 'emailVerifySuccess',
      locale: localeName,
    );
  }

  String get approvalRequested {
    return Intl.message(
      'Approval requested',
      name: 'approvalRequested',
      desc: 'approvalRequested',
      locale: localeName,
    );
  }

  String get cannotTransferFundBetweenSameAccount {
    return Intl.message(
      'Cannot transfer funds between same account',
      name: 'cannotTransferFundBetweenSameAccount',
      desc: 'cannotTransferFundBetweenSameAccount',
      locale: localeName,
    );
  }

  String get mobileRecharge {
    return Intl.message(
      'Mobile Recharge',
      name: 'mobileRecharge',
      desc: 'mobileRecharge',
      locale: localeName,
    );
  }

  String get billPayment {
    return Intl.message(
      'Bill Pay',
      name: 'billPayment',
      desc: 'billPayment',
      locale: localeName,
    );
  }

  String get cardBillPayment {
    return Intl.message(
      'Card Bill Payment',
      name: 'cardBillPayment',
      desc: 'cardBillPayment',
      locale: localeName,
    );
  }

  String get fundTransfer {
    return Intl.message(
      'Fund transfer',
      name: 'fundTransfer',
      desc: 'fundTransfer',
      locale: localeName,
    );
  }String get qrPayment {
    return Intl.message(
      'QR Payment',
      name: 'qrPayment',
      desc: 'qrPayment',
      locale: localeName,
    );
  }
  String get walletTransfer {
    return Intl.message(
      'Wallet transfer',
      name: 'walletTransfer',
      desc: 'walletTransfer',
      locale: localeName,
    );
  }
  String get welcomeOnBoard {
    return Intl.message(
      'Welcome to QPAY!',
      name: 'welcomeOnBoard',
      desc: 'welcomeOnBoard',
      locale: localeName,
    );
  }

  String get selectAccountType {
    return Intl.message(
      'Select account type',
      name: 'selectAccountType',
      desc: 'selectAccountType',
      locale: localeName,
    );
  }

  String get selectAccount {
    return Intl.message(
      'Select',
      name: 'selectAccount',
      desc: 'selectAccount',
      locale: localeName,
    );
  }

  String get selectLinkedAccount {
    return Intl.message(
      'Select linked account',
      name: 'selectLinkedAccount',
      desc: 'selectLinkedAccount',
      locale: localeName,
    );
  }

  String get selectContact {
    return Intl.message(
      'Phonebook',
      name: 'selectContact',
      desc: 'selectContact',
      locale: localeName,
    );
  }

  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: 'unknown',
      locale: localeName,
    );
  }

  String get ownCards {
    return Intl.message(
      'Cards',
      name: 'ownCards',
      desc: 'ownCards',
      locale: localeName,
    );
  }

  String get beneficiaries {
    return Intl.message(
      'Beneficiaries',
      name: 'beneficiaries',
      desc: 'beneficiaries',
      locale: localeName,
    );
  }

  String get beneficiaryWallets {
    return Intl.message(
      'Beneficiary MFS',
      name: 'beneficiaryWallets',
      desc: 'beneficiaryWallets',
      locale: localeName,
    );
  }

  String get banks {
    return Intl.message(
      'Banks',
      name: 'banks',
      desc: 'Banks',
      locale: localeName,
    );
  }
  String get bankAndFI {
    return Intl.message(
      'Select Bank/FI',
      name: 'banks',
      desc: 'Banks',
      locale: localeName,
    );
  }

  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: 'accounts',
      locale: localeName,
    );
  }

  String get addCard {
    return Intl.message(
      'Add Card',
      name: 'addCard',
      desc: 'addCard',
      locale: localeName,
    );
  }

  String get addBankAccount {
    return Intl.message(
      'Add Bank Account',
      name: 'addBankAccount',
      desc: 'addBankAccount',
      locale: localeName,
    );
  }

  String get addBeneficiary {
    return Intl.message(
      'Add Beneficiary',
      name: 'addBeneficiary',
      desc: 'addBeneficiary',
      locale: localeName,
    );
  }

  String get invalidPIN {
    return Intl.message(
      'Invalid PIN',
      name: 'invalidPIN',
      desc: 'invalidPIN',
      locale: localeName,
    );
  }

  String get invalidVerificationCode {
    return Intl.message(
      'invalid Verification Code',
      name: 'invalidVerificationCode',
      desc: 'invalidVerificationCode',
      locale: localeName,
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'cancel',
      locale: localeName,
    );
  }

  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: 'skip',
      locale: localeName,
    );
  }

  String get invalid {
    return Intl.message(
      'Invalid',
      name: 'invalid',
      desc: 'invalid',
      locale: localeName,
    );
  }

  String get setAppPIN {
    return Intl.message(
      'Change PIN',
      name: 'setAppPIN',
      desc: 'setAppPIN',
      locale: localeName,
    );
  }

  String get inputNewPINHint {
    return Intl.message(
      'Insert your new PIN',
      name: 'inputNewPINHint',
      desc: 'inputNewPINHint',
      locale: localeName,
    );
  }
  String get inputConfirmPINHint {
    return Intl.message(
      'Confirm your new PIN',
      name: 'inputConfirmPINHint',
      desc: 'inputConfirmPINHint',
      locale: localeName,
    );
  }
  String get inputOldPINHint {
    return Intl.message(
      'Insert your old PIN',
      name: 'inputOldPINHint',
      desc: 'inputOldPINHint',
      locale: localeName,
    );
  }

  String get inputCardNumberHint {
    return Intl.message(
      'XXXX XXXX XXXX XXXX',
      name: 'inputCardNumberHint',
      desc: 'inputCardNumberHint',
      locale: localeName,
    );
  }
  String get inputCardNumberLabel {
    return Intl.message(
      'Insert card number',
      name: 'inputCardNumberLabel',
      desc: 'inputCardNumberLabel',
      locale: localeName,
    );
  }

  String get inputBankAccountNumberHint {
    return Intl.message(
      'XXX XXX XXX XXX XXX',
      name: 'inputBankAccountNumberHint',
      desc: 'inputBankAccountNumberHint',
      locale: localeName,
    );
  }
  String get inputBankAccountNumberLabel {
    return Intl.message(
      'Bank account number',
      name: 'inputBankAccountNumberLabel',
      desc: 'inputBankAccountNumberLabel',
      locale: localeName,
    );
  }

  String get inputBeneficiaryName{
    return Intl.message(
      'Beneficiary name',
      name: 'inputBeneficiaryName',
      desc: 'inputBeneficiaryName',
      locale: localeName,
    );
  }
  String get inputShortName{
    return Intl.message(
      'Short name',
      name: 'inputShortName',
      desc: 'inputShortName',
      locale: localeName,
    );
  }
  String get inputExpireFormatDate {
    return Intl.message(
      'MM/YY',
      name: 'inputExpireFormatDate',
      desc: 'inputExpireFormatDate',
      locale: localeName,
    );
  }
  String get inputExpireDateHint {
    return Intl.message(
      'Expiry Date',
      name: 'inputExpireDateHint',
      desc: 'inputExpireDateHint',
      locale: localeName,
    );
  }
  String get inputExpireMonthHint {
    return Intl.message(
      'MM',
      name: 'inputExpireMonthHint',
      desc: 'inputExpireMonthHint',
      locale: localeName,
    );
  }

  String get inputExpireYearHint {
    return Intl.message(
      'YY',
      name: 'inputExpireYearHint',
      desc: 'inputExpireYearHint',
      locale: localeName,
    );
  }

  String get setAppPINDescription {
    return Intl.message(
      'Protect your account from unwanted access.',
      name: 'setAppPINDescription',
      desc: 'setAppPINDescription',
      locale: localeName,
    );
  }

  String get oneTouchAuthNotEnabled {
    return Intl.message(
      'Enable one touch auth from Security',
      name: 'oneTouchAuthNotEnabled',
      desc: 'oneTouchAuthNotEnabled',
      locale: localeName,
    );
  }

  String get insertOtp {
    return Intl.message(
      'Enter your OTP',
      name: 'insertOtp',
      desc: 'insert Otp',
      locale: localeName,
    );
  }

  String get takeIdImage {
    return Intl.message(
      'Take Image of your national Id card',
      name: 'takeIdImage',
      desc: 'Take nid Image',
      locale: localeName,
    );
  }

  String get thisWillTake2Minutes {
    return Intl.message(
      'This will take less than 2 minutes',
      name: 'thisWillTake2Minutes',
      desc: 'this will take 2 minutes',
      locale: localeName,
    );
  }

  String get cantReadData {
    return Intl.message(
      "Can't read data, take a clear picture",
      name: 'cantReadData',
      desc: 'cantReadData',
      locale: localeName,
    );
  }

  String get takeClearNidPic {
    return Intl.message(
      "Take a clear picture of your National ID card",
      name: 'takeClearNidPic',
      desc: 'takeClearNidPic',
      locale: localeName,
    );
  }
  String get placementClearNidPic {
    return Intl.message(
      "NID card image must be placed inside the rectangle",
      name: 'placementClearNidPic',
      desc: 'placementClearNidPic',
      locale: localeName,
    );
  }

  /**
   * texts below have translations
   */

  String get verifyAccount {
    return Intl.message(
      'Verify your account',
      name: 'verifyAccount',
      desc: 'verify account',
      locale: localeName,
    );
  }

  String get verifyIdentity {
    return Intl.message(
      'Verify your identity',
      name: 'verifyIdentity',
      desc: 'verify identity',
      locale: localeName,
    );
  }

  String get takeASelfie {
    return Intl.message(
      'Take a Selfie',
      name: 'takeASelfie',
      desc: 'takeASelfie',
      locale: localeName,
    );
  }
  String get takeAPhoto {
    return Intl.message(
      'Take a Selfie',
      name: 'takeAPhoto',
      desc: 'takeAPhoto',
      locale: localeName,
    );
  }

  String get verifyNID {
    return Intl.message(
      'Verify your NID',
      name: 'verifyNID',
      desc: 'verifyNID',
      locale: localeName,
    );
  }
  String get registerUser {
    return Intl.message(
      'User Registration',
      name: 'registerUser',
      desc: 'registerUser',
      locale: localeName,
    );
  }
  String get pinConstraint {
    return Intl.message(
      'PIN must be at least 6 characters long.',
      name: 'pinConstraint',
      desc: 'pinConstraint',
      locale: localeName,
    );
  }

  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: 'Services',
      locale: localeName,
    );
  }

  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: 'submit',
      locale: localeName,
    );
  }

  String get faceNotFound {
    return Intl.message(
      'Face not found',
      name: 'faceNotFound',
      desc: 'Face not found',
      locale: localeName,
    );
  }

  String get lookLeft {
    return Intl.message(
      'Look left',
      name: 'lookLeft',
      desc: 'look left',
      locale: localeName,
    );
  }

  String get lookRight {
    return Intl.message(
      'Look Right',
      name: 'lookRight',
      desc: 'look Right',
      locale: localeName,
    );
  }

  String get smilePlease {
    return Intl.message(
      'Smile Please',
      name: 'smilePlease',
      desc: 'smile Please',
      locale: localeName,
    );
  }

  String get verified {
    return Intl.message(
      'Verified',
      name: 'verified',
      desc: 'verified',
      locale: localeName,
    );
  }

  String get error {
    return Intl.message(
      'Error!',
      name: 'error',
      desc: 'error',
      locale: localeName,
    );
  }

  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: 'Confirm action',
      locale: localeName,
    );
  }
  String get resendOTP {
    return Intl.message(
      'Resend OTP',
      name: 'resendOTP',
      desc: 'resendOTP',
      locale: localeName,
    );
  }
  String get goodMorning {
    return Intl.message(
      'Good Morning!',
      name: 'goodMorning',
      desc: 'Good morning',
      locale: localeName,
    );
  }

  String get goodEvening {
    return Intl.message(
      'Good Evening',
      name: 'goodEvening',
      desc: 'Good Evening',
      locale: localeName,
    );
  }

  String get goodAfternoon {
    return Intl.message(
      'Good Afternoon',
      name: 'goodAfternoon',
      desc: 'Good Afternoon',
      locale: localeName,
    );
  }

  String get whatsUp {
    return Intl.message(
      'How are you doing!',
      name: 'whatsUp',
      desc: 'How are you doing!',
      locale: localeName,
    );
  }

  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: 'Notifications',
      locale: localeName,
    );
  }

 String get faqs {
    return Intl.message(
      'FAQ',
      name: 'faqs',
      desc: 'faqs',
      locale: localeName,
    );
  }

  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: 'support',
      locale: localeName,
    );
  }

  String get supportChat {
    return Intl.message(
      'Live Chat',
      name: 'supportChat',
      desc: 'supportChat',
      locale: localeName,
    );
  }
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: 'privacyPolicy',
      locale: localeName,
    );
  }

  String get doubleTapToExit {
    return Intl.message(
      'Click again to exit the application',
      name: 'doubleTapToExit',
      desc: 'Double click to exit',
      locale: localeName,
    );
  }

  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: 'exit',
      locale: localeName,
    );
  }

  String get usersImage {
    return Intl.message(
      'Users image',
      name: 'usersImage',
      desc: 'Users image',
      locale: localeName,
    );
  }

  String get takeSelfie {
    return Intl.message(
      'Click here to take a selfie',
      name: 'takeSelfie',
      desc: 'Take a selfie',
      locale: localeName,
    );
  }

  String get nidFrontUpload {
    return Intl.message(
      'Upload front side of your NID',
      name: 'nidFrontUpload',
      desc: 'Take nidFront image',
      locale: localeName,
    );
  }

  String get nidBackUpload {
    return Intl.message(
      'Upload back side of your NID',
      name: 'nidBackUpload',
      desc: 'nidBackUpload',
      locale: localeName,
    );
  }

  String get upload {
    return Intl.message(
      'Upload',
      name: 'uploadImage',
      desc: 'uploadImage',
      locale: localeName,
    );
  }

  String get resetPIN {
    return Intl.message(
      'Reset your PIN',
      name: 'resetPIN',
      desc: 'Reset your PIN',
      locale: localeName,
    );
  }

  String get title {
    return Intl.message(
      'QPay',
      name: 'title',
      desc: 'Title for the application',
      locale: localeName,
    );
  }

  String get verificationCodeLogin {
    return Intl.message('Verification Code Login',
        name: 'verificationCodeLogin',
        desc: 'Title for the Login page',
        locale: localeName);
  }

  String get changeLanguage {
    return Intl.message('বাংলা ভাষা',
        name: 'changeLanguage',
        desc: 'Change app language',
        locale: localeName);
  }


  String get pinLogin {
    return Intl.message('PIN Login',
        name: 'PINLogin', desc: 'PIN Login', locale: localeName);
  }

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: 'Login',
      locale: localeName,
    );
  }
String get touchLogin {
    return Intl.message(
      'Biometrics Login',
      name: 'touchLogin',
      desc: 'touchLogin',
      locale: localeName,
    );
  }


  String get forgotPINLink {
    return Intl.message('Forgot PIN',
        name: 'forgotPINLink',
        desc: 'Forgot PIN',
        locale: localeName);
  }

  String get inputPINHint {
    return Intl.message('Please enter the PIN',
        name: 'inputPINHint',
        desc: 'inputPINHint',
        locale: localeName);
  }
  String get confirmPINHint {
    return Intl.message('Please confirm the PIN',
        name: 'confirmPINHint',
        desc: 'Please confirm the PIN',
        locale: localeName);
  }

  String get inputUsernameHint {
    return Intl.message('Please input your name',
        name: 'inputUsernameHint',
        desc: 'Please input Username',
        locale: localeName);
  }

  String get noAccountRegister {
    return Intl.message('Don\'t have an account?',
        name: 'noAccountRegister',
        desc: 'Don\'t have an account?',
        locale: localeName);
  }
  String get signUp {
    return Intl.message('Sign Up',
        name: 'signUp',
        desc: 'Sign Up',
        locale: localeName);
  }

  String get noLinkedAccount {
    return Intl.message('No account linked',
        name: 'noAccountLinked', desc: 'No account linked', locale: localeName);
  }

  String get register {
    return Intl.message('Register',
        name: 'register', desc: 'Register', locale: localeName);
  }

  String get openYourAccount {
    return Intl.message('Open your account',
        name: 'openYourAccount', desc: 'Open your account', locale: localeName);
  }

  String get provideYourEmail {
    return Intl.message('Provide your email',
        name: 'provideYourEmail', desc: 'Provide your email', locale: localeName);
  }

  String get inputPhoneHint {
    return Intl.message('Please enter phone number',
        name: 'inputPhoneHint',
        desc: 'Please enter phone number',
        locale: localeName);
  }

  String get inputEmailHint {
    return Intl.message('Please enter Email Address',
        name: 'inputEmailHint',
        desc: 'Please enter email address',
        locale: localeName);
  }

  String get inputWalletAccountHint {
    return Intl.message('01XXXXXXXXX',
        name: 'inputMfsHint',
        desc: 'inputMfsHint',
        locale: localeName);
  }
  String get inputWalletAccountLabel {
    return Intl.message('Insert wallet account number',
        name: 'inputMfsHint',
        desc: 'inputMfsHint',
        locale: localeName);
  }

  String get inputNidHint {
    return Intl.message('Please enter national ID number',
        name: 'inputNidHint',
        desc: 'Please enter national Id number',
        locale: localeName);
  }

  String get inputAmount {
    return Intl.message('Input Amount',
        name: 'inputAmount', desc: 'inputAmount', locale: localeName);
  }
  String get inputTips {
    return Intl.message('Tips',
        name: 'inputTips', desc: 'inputTips', locale: localeName);
  }
  String get inputConvenience {
    return Intl.message('Convenience',
        name: 'inputConvenience', desc: 'inputConvenience', locale: localeName);
  }
  String get inputCVV {
    return Intl.message('CVV2',
        name: 'inputCVV', desc: 'inputCVV', locale: localeName);
  }
  String get newCVV2 {
    return Intl.message('Insert New CVV2',
        name: 'inputCVV', desc: 'inputCVV', locale: localeName);
  }
  String get confirmNewCVV2 {
    return Intl.message('Confirm New CVV2',
        name: 'inputCVV', desc: 'inputCVV', locale: localeName);
  }

  String get inputPurpose {
    return Intl.message('Purpose',
        name: 'inputPurpose', desc: 'inputPurpose', locale: localeName);
  }
  String get hint {
    return Intl.message('PIN Code Hints',
        name: 'hint', desc: 'hint', locale: localeName);
  }

  String get inputSubscriber {
    return Intl.message('Subscriber ID',
        name: 'inputSubscriber', desc: 'inputSubscriber', locale: localeName);
  }

  String get inputVerificationCodeHint {
    return Intl.message('Enter OTP',
        name: 'inputVerificationCodeHint',
        desc: 'inputVerificationCodeHint',
        locale: localeName);
  }
  String get inputOTP {
    return Intl.message('Please enter OTP',
        name: 'inputOTP',
        desc: 'inputOTP',
        locale: localeName);
  }
  String get inputPhoneInvalid {
    return Intl.message('Please input valid mobile phone number',
        name: 'inputPhoneInvalid',
        desc: 'Please input valid mobile phone number',
        locale: localeName);
  }

  String get inputEmailInvalid {
    return Intl.message('Please input valid email address',
        name: 'inputEmailInvalid',
        desc: 'Please input valid email address',
        locale: localeName);
  }

  String get inputNidInvalid {
    return Intl.message('Please input valid national Id number',
        name: 'inputNidInvalid',
        desc: 'Please input valid national Id number',
        locale: localeName);
  }

  String get getVerificationCode {
    return Intl.message('Get verification code',
        name: 'getVerificationCode',
        desc: 'Get verification code',
        locale: localeName);
  }

  String get getDateTime {
    return Intl.message('Get Date',
        name: 'getDateTime',
        desc: 'Get Date',
        locale: localeName);
  }

  String get getUserBengaliName {
    return Intl.message('User\'s Bengali Name',
        name: 'getUserBengaliName',
        desc: 'User Bengali Name',
        locale: localeName);
  }

  String get getUserEnglishName {
    return Intl.message('User\'s English Name',
        name: 'getUserEnglishName',
        desc: 'User English Name',
        locale: localeName);
  }

  String get getUserFathersName {
    return Intl.message('Father\'s Name',
        name: 'getUserFathersName',
        desc: 'Father\'s Name',
        locale: localeName);
  }

  String get getUserMothersName {
    return Intl.message('Mother\'s Name',
        name: 'getUserMothersName',
        desc: 'Mother\'s Name',
        locale: localeName);
  }

  String get getUserDOBName {
    return Intl.message('Date of Birth',
        name: 'getUserDOBName',
        desc: 'Date of Birth',
        locale: localeName);
  }

  String get getUserNIDNo {
    return Intl.message('NID No.',
        name: 'getUserNIDNo',
        desc: 'NID No',
        locale: localeName);
  }

  String get getUserAddress {
    return Intl.message('Address',
        name: 'getUserAddress',
        desc: 'Address',
        locale: localeName);
  }

  String get getUserBloodGroup {
    return Intl.message('Blood Group',
        name: 'getUserBloodGroup',
        desc: 'Blood Group',
        locale: localeName);
  }

  String get nextStep {
    return Intl.message('Next',
        name: 'nextStep', desc: 'Next step', locale: localeName);
  }

  String get checkReward {
    return Intl.message('Available Reward Points',
        name: 'checkReward', desc: 'checkReward', locale: localeName);
  }
  String get checkCardStatus {
    return Intl.message('Card Status',
        name: 'checkCardStatus', desc: 'checkCardStatus', locale: localeName);
  }

  String get checkEMI {
    return Intl.message('EMI Details',
        name: 'checkEMI', desc: 'checkEMI', locale: localeName);
  }

  String get getVCode {
    return Intl.message('Generate OTP',
        name: 'getVCode', desc: 'getVCode', locale: localeName);
  }

  String get checkStatus {
    return Intl.message('Check Status',
        name: 'checkStatus', desc: 'checkStatus', locale: localeName);
  }

  String get putYourFace{
    return Intl.message('Put your face inside the frame and take a clear selfie.',
      name: 'putYourFace',
    desc: 'putYourFace',
    locale: localeName);
  }

  String get putYourNID{
    return Intl.message('Place your National ID on a flat surface, then take a clear photo from above.',
        name: 'putYourNID',
        desc: 'putYourNID',
        locale: localeName);
  }

  String get notBlurryMessage{
    return Intl.message('Make sure that your photo is not blurry',
    name: 'notBlurryMessage',
    desc: 'notBlurryMessage',
    locale: localeName);
  }

  String get tipsImageMessage1{
    return Intl.message('Take a selfie of yourself with neutral expression',
    name: 'tipsImageMessage1',
    desc: 'tipsImageMessage1',
    locale: localeName);
  }String get tipsImageMessage2{
    return Intl.message('Make sure your whole face is visible, centred and your eyes are open',
    name: 'tipsImageMessage2',
    desc: 'tipsImageMessage2',
    locale: localeName);
  }String get tipsImageMessage3{
    return Intl.message('Do not use screenshots of your ID photo',
    name: 'tipsImageMessage3',
    desc: 'tipsImageMessage3',
    locale: localeName);
  }
  String get tipsImageMessage4{
    return Intl.message('Do not hide or alter parts of your face (No hats/beauty images/filters/headgear/sun glass/power glass)',
    name: 'tipsImageMessage4',
    desc: 'tipsImageMessage4',
    locale: localeName);
  }
  String get tipsNIDMessage1{
    return Intl.message('Bangladeshi Old/Smart NID card',
        name: 'tipsNIDMessage1',
        desc: 'tipsNIDMessage1',
        locale: localeName);
  }
  String get tipsNIDMessage2{
    return Intl.message('Original full-size, unedited NID card',
        name: 'tipsNIDMessage2',
        desc: 'tipsNIDMessage2',
        locale: localeName);
  }
  String get tipsNIDMessage3{
    return Intl.message('Place NID card against a single-coloured background',
        name: 'tipsNIDMessage3',
        desc: 'tipsNIDMessage3',
        locale: localeName);
  }
  String get tipsNIDMessage4{
    return Intl.message('Readable, well-lit images of NID card',
        name: 'tipsNIDMessage4',
        desc: 'tipsNIDMessage4',
        locale: localeName);
  }
  String get tipsNIDMessage5{
    return Intl.message('No black and white images',
        name: 'tipsNIDMessage5',
        desc: 'tipsNIDMessage5',
        locale: localeName);
  }
  String get tipsNIDMessage6{
    return Intl.message('No edited or expired NID card',
        name: 'tipsNIDMessage6',
        desc: 'tipsNIDMessage6',
        locale: localeName);
  }
  String get feesAndCharges{
    return Intl.message('Fee\'s',
        name: 'feesAndCharges',
        desc: 'feesAndCharges',
        locale: localeName);
  }
  String get dailyLimit{
    return Intl.message('Daily',
        name: 'dailyLimit',
        desc: 'dailyLimit',
        locale: localeName);
  }
  String get monthlyLimit{
    return Intl.message('Monthly',
        name: 'monthlyLimit',
        desc: 'monthlyLimit',
        locale: localeName);
  }
  String get txnRange{
    return Intl.message('Range',
        name: 'txnRange',
        desc: 'txnRange',
        locale: localeName);
  }
  String get txnLimit{
    return Intl.message('Transaction Limit',
        name: 'txnLimit',
        desc: 'txnLimit',
        locale: localeName);
  }

  String get haveCode {
    return Intl.message('I already have a code',
        name: 'haveCode',
        desc: 'Forgot haveCode',
        locale: localeName);
  }

  String get seeAllNumbers {
    return Intl.message(
        'See All Numbers',
        name: 'seeAllNumbers',
        desc: 'seeAllNumbers',
        locale: localeName);
  }

  String get contactsTitle {
    return Intl.message(
        'Contacts',
        name: 'contactsTitle',
        desc: 'contactsTitle',
        locale: localeName);
  }

  String get searchTitle {
    return Intl.message(
        'Search Contact',
        name: 'searchTitle',
        desc: 'searchTitle',
        locale: localeName);
  }
  String get searchBankAndFI {
    return Intl.message(
        'Search Bank/FI',
        name: 'searchTitle',
        desc: 'searchTitle',
        locale: localeName);
  }

  String get bdt {
    return Intl.message(
        'BDT',
        name: 'bdt',
        desc: 'bdt',
        locale: localeName);
  }

  String get usd {
    return Intl.message(
        'USD',
        name: 'usd',
        desc: 'usd',
        locale: localeName);
  }

  String get notAvailable {
    return Intl.message(
        'N/A',
        name: 'notAvailable',
        desc: 'notAvailable',
        locale: localeName);
  }

  String get emiAvailCondition {
    return Intl.message(
      'You can avail EMI for 3,6,9 & 12 Months',
      name: 'emiAvailCondition',
      desc: 'emiAvailCondition',
      locale: localeName,
    );
  }

  String get emiAvail {
    return Intl.message(
      'Avail EMI',
      name: 'emiAvail',
      desc: 'emiAvail',
      locale: localeName,
    );
  }
  String get availBalance {
    return Intl.message(
      'Available Balance',
      name: 'emiAvail',
      desc: 'emiAvail',
      locale: localeName,
    );
  }
  String get profileAgreement {
    return Intl.message(
      '➢ By tapping the Submit button, you agree that the above-mentioned information is correct.\n\n➢ This information is used for personal verification only, and is kept private and confidential by Qpay Bangladesh.',
      name: 'profileAgreement',
      desc: 'profileAgreement',
      locale: localeName,
    );
  }
  String get cvvChangeWarning {
    return Intl.message(
      'Once you have changed your CVV2, your existing card\'s CVV2 will not work anymore.',
      name: 'profileAgreement',
      desc: 'profileAgreement',
      locale: localeName,
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'bn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}

