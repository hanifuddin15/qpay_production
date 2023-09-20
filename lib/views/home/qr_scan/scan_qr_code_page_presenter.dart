import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/scanned_qr_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/views/home/qr_scan/scan_qr_code_iview.dart';

class ScanQrCodePagePresenter extends BasePagePresenter<ScanQrCodeIMvpView>{
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      transactionLoad();
      var scanQr = CachedQrCode().qrData;
      scannedQr(scanQr);
    });
  }

  transactionLoad() async {
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.transactionCategory,
      onSuccess: (data) {
        var items = data["body"] as List;
        var categoty = items
            .map((value) => TransactionCategoryViewModel.fromJson(value))
            .toList();
        view.setTransactionsCategory(categoty);
      },
    );
  }

  scannedQr(String qrData) async{
    final Map<String, dynamic> queryParams = {
      'qr': qrData
    };
    ScannedQrViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.qrCodeRequest,
        queryParameters: queryParams,
        onSuccess: (data) {
          var responseJson = data["body"];
          response = ScannedQrViewModel.formJson(responseJson);
          view.setData(response);
        },
      );
    }catch(e){
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
  getMerchantWithQrAndSource(String qrData,String source) async{
    final Map<String, dynamic> queryParams = {
      'qr': qrData,
      'source':source
    };
    ScannedQrViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.merchantByQrRequest,
        queryParameters: queryParams,
        onSuccess: (data) {
          var responseJson = data["body"];
          response = ScannedQrViewModel.formJson(responseJson);
          view.setData(response);
        },
      );
    }catch(e){
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }


  Future<TransactionViewModel> qrFundTransfer(double amount, int debitAccountId,
      String creditAccountIssuer,String qrCode,String purpose,String cvv,double tipOrConvenienceAmount) async {
    FormData formData = FormData.fromMap({
      'Amount': amount,
      'TipOrConvenienceAmount':tipOrConvenienceAmount,
      'DebitAccountId': debitAccountId,
      'SelectedIdentifier':creditAccountIssuer,
      'QrCode':qrCode,
      'Remarks' : purpose,
      'SecurityCode' : cvv
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.qrCodePayment,
        params: formData,
        onSuccess: (data) {
          var responseJson = data["body"]["transaction"];
          response = TransactionViewModel.fromJson(responseJson);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<TransactionViewModel> confirmTransaction( String transactionId, String pin) async{
    FormData formData = FormData.fromMap({
      'TransactionId': transactionId,
      'Otp': pin,
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.qrCodePaymentConfirm,
        params: formData,
        onSuccess: (data) {
          var responseJson = data["body"]["transaction"];
          response = TransactionViewModel.fromJson(responseJson);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;

  }

  Future<List<TransactionFeeViewModel>> transactionFeeCalculate(String id, double amount) async{
    final Map<String, dynamic> queryParams = {
      'PolicyId':id,
      'Amount': amount,
    };
    List<TransactionFeeViewModel> response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.transactionFees,
        queryParameters: queryParams,
        onSuccess: (data) {
          var items = data["body"] as List;
          var responseList = items
              .map((value)=> TransactionFeeViewModel.fromJson(value))
              .toList();
          response = responseList;

        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<List<AccountBalanceViewModel>> accountBalance (int accountId) async {
    FormData formData = FormData.fromMap({
      'AccountId': accountId,
    });
    List<AccountBalanceViewModel> response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.accountBalance,
        params: formData,
        onSuccess: (data) {
          var responseJson = data["body"]['data']['currencyBalances'] as List;
          response = responseJson.map((e) => AccountBalanceViewModel.fromJson(e)).toList();
        },
      );
    }catch(e){
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
}