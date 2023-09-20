import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/bill_vendor_params_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_iview.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_otp_page.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_presenter.dart';
import 'package:qpay/views/card_bill_payment/card_bill_payment_otp_page.dart';
import 'package:qpay/views/shared/bill_receipt_page.dart';
import 'package:qpay/views/shared/transaction_complete_page.dart';
import 'package:qpay/widgets/account_selector.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/confirmation_screen_column_box.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/transaction_account_selector.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';

class VendorBillPaymentConfirmationPage extends StatefulWidget{
  final double amount;
  final double feeAmount;
  final double vatAmount;
  final AccountSelector from;
  final AccountSelector to;
  final LinkedAccountViewModel selectedDebitAccount;
  final int billerId;
  final int connectionId;
  final String referenceId;
  final String purpose;
  final String cvv;
  final String subscriberAccountNumber;
  final String billMonthYear;
  final BillVendorViewModel billVendorViewModel;


  VendorBillPaymentConfirmationPage(
      this.amount,
      this.feeAmount,
      this.vatAmount,
      this.from,
      this.to,
      this.selectedDebitAccount,
      this.billerId,
      this.connectionId,
      this.referenceId,
      this.purpose,
      this.subscriberAccountNumber,
      this.billMonthYear, this.billVendorViewModel,this.cvv);

  @override
  _VendorBillPaymentConfirmationPageState createState() => _VendorBillPaymentConfirmationPageState(selectedDebitAccount,amount,feeAmount,vatAmount,from,to,billerId,connectionId,referenceId,purpose,subscriberAccountNumber,billMonthYear,billVendorViewModel,cvv);
}

class _VendorBillPaymentConfirmationPageState extends State<VendorBillPaymentConfirmationPage>
    with
        BasePageMixin<VendorBillPaymentConfirmationPage, VendorBillPaymentPresenter>,
        AutomaticKeepAliveClientMixin<VendorBillPaymentConfirmationPage>
    implements VendorBillPaymentIMvpView {
  TransactionViewModel _transaction;
  final LinkedAccountViewModel _selectedDebitAccount;
  final double _amount;
  final double _feeAmount;
  final double _vatAmount;
  final AccountSelector from;
  final AccountSelector to;
  final int _billerId;
  final int _connectionId;
  final String _referenceId;
  final String _purpose;
  final String _cvv;
  final String _subscriberAccountNumber;
  final String _billMonthYear;
  final BillVendorViewModel _billVendorViewModel;
      double totalAmount = 0;


  _VendorBillPaymentConfirmationPageState(
      this._selectedDebitAccount,
      this._amount,
      this._feeAmount,
      this._vatAmount,
      this.from,
      this.to,
      this._billerId,
      this._connectionId,
      this._referenceId,
      this._purpose,
      this._subscriberAccountNumber, this._billMonthYear, this._billVendorViewModel,this._cvv);

  @override
  void initState() {
    totalTransactionAmount();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).billPayment,
        ),
        body: MyScrollView(
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() => <Widget>[
    Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.vGap8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Gaps.hGap16,
                          ConfirmScreenLargeAmountColumnBox('Total Amount',HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(totalAmount))),
                          Gaps.hGap16,
                        ],
                      ),
                      Gaps.vGap8,
                      Gaps.line,
                      Gaps.vGap8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Gaps.hGap16,
                          ConfirmScreenAmountColumnBox('Amount',HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(_amount))),
                          Gaps.hGap16,
                          Gaps.vLine,
                          Gaps.hGap16,
                          ConfirmScreenAmountColumnBox('Fee',HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(_feeAmount))),
                          Gaps.hGap16,
                          Gaps.vLine,
                          Gaps.hGap16,
                          ConfirmScreenAmountColumnBox('VAT', HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(_vatAmount))),
                          Gaps.hGap16,
                        ],
                      ),
                      Gaps.vGap8,
                      Gaps.line,
                      Gaps.vGap16,
                      from,
                      Gaps.vGap8,
                      to,
                    ],
                  ),
                ),
              ),
              Gaps.vGap24,
              MyButton(
                key: const Key('confirm'),
                onPressed: _initiate,
                text: AppLocalizations.of(context).getVCode,
              ),
              Gaps.vGap16,
              Text('Your OTP will be sent to your registered mobile number',style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),
            ],
          ),
        ),
      ),
    ),
  ];

  void totalTransactionAmount(){
    if(_feeAmount.toString() != null && _amount.toString() != null && _vatAmount.toString() != null){
      totalAmount = _feeAmount+_amount+_vatAmount;
    }
  }

  void _initiate() async {
    final double amount = _amount;
    final int debitAccountId = _selectedDebitAccount.id;
    final int billedId = _billerId;
    final int connectionId = _connectionId;
    final String referenceId = _referenceId;
    final String purpose = _purpose;
    final String cvv = _cvv;
    final String subscriberAccountNumber = _subscriberAccountNumber;
    var billResponse = await presenter.billPayment(amount, billedId,
        connectionId, debitAccountId,referenceId, subscriberAccountNumber,purpose,cvv);
    if (billResponse != null) {
      _transaction = billResponse;
      if (_transaction != null) {
        _showPinDialog(_transaction);
      }
    }
  }

  Future<bool> _showPinDialog(TransactionViewModel transaction) async {
    final result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorBillPaymentOtpPage(
          transaction, TransactionAmountDescriptionWidget(transaction));
    }));
    _transaction = result != null ? result : null;
    if (_transaction != null) {
      if (_transaction.transactionStatus != 'Declined') {
        _onSuccess(_transaction);
      }else{
        NavigatorUtils.goBackWithParams(context,_transaction);
      }
    }
  }

  void _showSuccessDialog(TransactionViewModel transaction) {
    var future = showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (_) => BillReceiptPage(_transaction,_billVendorViewModel,_subscriberAccountNumber,_billMonthYear,TransactionAccountSelector('From',_selectedDebitAccount,isEnabled: false),),
    );
    future.then((value) => NavigatorUtils.goBackWithParams(context,transaction));
  }

  void _onSuccess(TransactionViewModel transaction) {
    _showSuccessDialog(transaction);
  }


  @override
  bool get wantKeepAlive =>true;


  @override
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel) {
  }

  @override
  VendorBillPaymentPresenter createPresenter() => VendorBillPaymentPresenter();

  @override
  void setVendorParams(BillVendorParamsViewModel billVendorParamsViewModel) {
    // TODO: implement setVendorParams
  }



}