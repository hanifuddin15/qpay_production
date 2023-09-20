import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/bill_inquiry_response_vm.dart';
import 'package:qpay/net/contract/bill_vendor_params_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/reference_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/providers/vendor_id_provider.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_iview.dart';

class VendorBillPaymentPresenter extends BasePagePresenter<VendorBillPaymentIMvpView>{
  BillVendorViewModel vendor = VendorIdListener().selectedVendor;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        transactionLoad();
        vendorParamsLoad(vendor.id);
      } catch (e) {
        view.showErrorDialog('Failed to get response!');
        view.closeProgress();
      }
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
  vendorParamsLoad(int id) async {
    BillVendorParamsViewModel response;
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.vendorParams(id),
      onSuccess: (data) {
        var apiResult =  Result.fromJson(data);
        if(apiResult.isSuccess) {
          response = BillVendorParamsViewModel.fromJson(apiResult.body);
          view.setVendorParams(response);
        }else{
          view.showErrorDialog('Failed to get response!');
          view.closeProgress();
        }
      },
    );
  }

  Future<ReferenceViewModel> getAkashSubscriber(String phoneNumber,String subscriberId) async {
    final Map<String, dynamic> queryParams = {
      'PhoneNumber': phoneNumber,
      'SubscriberAccountNumber': subscriberId
    };
    ReferenceViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.akashSubscriberCheck,
        queryParameters: queryParams,
        onSuccess: (data) {
           var apiResult =  Result.fromJson(data);
           if(apiResult.isSuccess) {
             response = ReferenceViewModel.fromJson(apiResult.body);
           }else{
             view.showErrorDialog('Failed to get response!');
             view.closeProgress();
           }
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<TransactionViewModel> billPayment(
      double amount,
      int vendorId,
      int connectionId,
      int debitAccountId,
      String referenceId,
      String subscriberAccountNumber,
      String purpose,String cvv) async {
    FormData formData = FormData.fromMap({
      'Credit.ReferenceId': referenceId,
      'Amount': amount,
      'Credit.VendorId': vendorId,
      'Credit.ConnectionId': connectionId,
      'DebitAccountId': debitAccountId,
      'Credit.SubscriberAccountNumber': subscriberAccountNumber,
      'Remarks' : purpose,
      'SecurityCode' : cvv
    });
    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.billPayment,
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

  Future<BillInquiryResponseViewModel> billPaymentInquiry(
      String billNo,
      String accountNo,
      String mobileNumber,
      String billType,
      String billMonth,
      int billYear,
      int vendorId,
      int connectionId) async {
    FormData formData = FormData.fromMap({
      'Credit.BillNo': billNo,
      'Credit.AccountNumber': accountNo,
      'Credit.MobileNumber': mobileNumber,
      'Credit.BillingType': billType,
      'Credit.BillingMonth': billMonth,
      'Credit.BillingYear': billYear,
      'Credit.ConnectionId': connectionId,
      'Credit.VendorId': vendorId,
    });
    BillInquiryResponseViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.billPaymentInquiry,
        params: formData,
        onSuccess: (data) {
          var responseJson = data["body"];
          response = BillInquiryResponseViewModel.fromJson(responseJson);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<TransactionViewModel> confirmTransaction(
      String transactionId, String otp) async {
    FormData formData = FormData.fromMap({
      'TransactionId': transactionId,
      'Otp': otp,
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.billPaymentConfirm,
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