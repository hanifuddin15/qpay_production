import 'package:flutter/material.dart';
import 'package:qpay/widgets/load_image.dart';

class TransactionViewModel {
  String amount;
  double amountDecimal;
  String transactionName;
  String type;
  String fee;
  double feeDecimal;
  String debitAccount;
  String creditAccount;
  String transactionId;
  String transactionStatus;
  String transactionDetails;
  String remarks;
  String dateTime;
  String reflection;
  String approvalCode;
  bool isRedirectAllow ;
  String redirectUrl ;
  String referenceInfo ;

  TransactionViewModel.fromJson(Map<String, dynamic> json) {
    if (json['amount'] != null) {
      amount = json['amount']?.toString();
      amountDecimal = double.parse(amount);
    }
    transactionName = json['transactionName']?.toString()??null;
    if (json['fee'] != null) {
      fee = json['fee']?.toString();
      feeDecimal = double.parse(fee);
    }
    debitAccount = json['debitAccount']?.toString() ?? null;
    type = json['type']?.toString() ?? null;
    creditAccount = json['creditAccount']?.toString() ?? null;
    transactionId = json['transactionId']?.toString() ?? null;
    transactionStatus = json['transactionStatus']?.toString() ?? null;
    transactionDetails = json['transactionDetails']?.toString() ?? null;
    remarks = json['remarks']?.toString() ?? null;
    dateTime = json['dateTime']?.toString() ?? null;
    reflection = json['reflection']?.toString() ?? null;
    approvalCode = json['approvalCode']?.toString() ?? null;
    isRedirectAllow = json['isRedirectAllow'] ?? false;
    redirectUrl = json['redirectUrl']?.toString() ?? null;
    referenceInfo = json['referenceInfo']?.toString() ?? null;
  }

  String get total => (amountDecimal + feeDecimal).toStringAsFixed(
      (amountDecimal + feeDecimal).truncateToDouble() ==
              (amountDecimal + feeDecimal)
          ? 0
          : 2);

  String get amountFormatted => amountDecimal.toStringAsFixed(
      amountDecimal.truncateToDouble() == amountDecimal ? 0 : 2);

  String get feeFormatted => feeDecimal
      .toStringAsFixed(feeDecimal.truncateToDouble() == feeDecimal ? 0 : 2);

  bool isSuccessful() {
    return transactionStatus == "Success";
  }

  LoadAssetImage getTransactionIcon(){

    if(transactionStatus == "Success"){
      return LoadAssetImage("tr_success", width: 48.0) ;
    }
    if(transactionStatus.contains("Declined")){
      return LoadAssetImage("tr_pending", width: 48.0) ;
    }
    if(transactionStatus.contains("Processing")){
      return LoadAssetImage("tr_pending", width: 48.0) ;
    }
    return LoadAssetImage("tr_failed", width: 48.0) ;
  }

  Color getTranSactionColor(){
    if(transactionStatus == "Success"){
      return Colors.green[400] ;
    }
    if(transactionStatus.contains("Declined")){
      return Colors.blue ;
    }
    if(transactionStatus.contains("Processing")){
      return Colors.blue ;
    }
    return Colors.black ;
  }

  Widget getReflection(){
    if(reflection == "in"){
      AssetImage("assets/images/in_txn.png");
    }
    if(reflection == "out"){
      AssetImage("assets/images/out_txn.png");
    }
  }
}
