import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/scanned_qr_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/views/home/qr_scan/qr_code_payment_otp_page.dart';
import 'package:qpay/views/home/qr_scan/scan_qr_code_iview.dart';
import 'package:qpay/views/home/qr_scan/scan_qr_code_page_presenter.dart';
import 'package:qpay/views/shared/transaction_complete_page.dart';
import 'package:qpay/widgets/account_selector.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/confirmation_screen_column_box.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/transaction_account_selector.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';

import '../../../utils/utils.dart';
import '../../../widgets/my_dialog.dart';


class QrCodePaymentConfirmationPage extends StatefulWidget{
  final double amount;
  final double feeAmount;
  final double vatAmount;
  final AccountSelector from;
  final LinkedAccountViewModel selectedDebitAccount;
  final String selectedCreditAccountIssuer;
  final AccountSelector to;
  final String qrData;
  final String purpose;
  final ScannedQrViewModel scannedQrViewModel ;
  final MerchantPansViewModel merchantViewModel;
  final String cvv;
  final bool isOtpRequired;
  final double transactionTipOrConvenience;
  final String tipsOrConvenience;

  QrCodePaymentConfirmationPage(this.amount, this.feeAmount, this.vatAmount, this.from, this.to,
      this.selectedDebitAccount, this.selectedCreditAccountIssuer, this.qrData, this.purpose,this.scannedQrViewModel,this.merchantViewModel,this.cvv, this.isOtpRequired,this.transactionTipOrConvenience,this.tipsOrConvenience);

  @override
  _QrCodePaymentConfirmationPageState createState() => _QrCodePaymentConfirmationPageState(selectedDebitAccount,selectedCreditAccountIssuer,amount,feeAmount,vatAmount,from,to,qrData,purpose,scannedQrViewModel,merchantViewModel,cvv,isOtpRequired,transactionTipOrConvenience,tipsOrConvenience);
}

class _QrCodePaymentConfirmationPageState extends State<QrCodePaymentConfirmationPage>
    with
        BasePageMixin<QrCodePaymentConfirmationPage, ScanQrCodePagePresenter>,
        AutomaticKeepAliveClientMixin<QrCodePaymentConfirmationPage>
    implements ScanQrCodeIMvpView {
  TransactionViewModel _transaction;
  final LinkedAccountViewModel _selectedDebitAccount;
  final String _selectedCreditAccountIssuer;
  final double _amount;
  final double _feeAmount;
  final double _vatAmount;
  final AccountSelector from;
  final AccountSelector to;
  final String _qrData;
  final String _purpose;
  final ScannedQrViewModel _scannedQrViewModel ;
  final MerchantPansViewModel _merchantViewModel ;
  double totalAmount = 0;
  final String _cvv;
  final bool _isOtpRequired;
  final double _transactionTipOrConvenience;
  final String _tipsOrConvenience;

  _QrCodePaymentConfirmationPageState(
      this._selectedDebitAccount,
      this._selectedCreditAccountIssuer,
      this._amount,
      this._feeAmount,
      this._vatAmount,
      this.from,
      this.to,
      this._qrData,
      this._purpose, this._scannedQrViewModel, this._merchantViewModel,this._cvv, this._isOtpRequired,this._transactionTipOrConvenience,
      this._tipsOrConvenience);

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
          centerTitle: AppLocalizations.of(context).qrPayment,
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
                          ConfirmScreenAmountColumnBox(_tipsOrConvenience,HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(_transactionTipOrConvenience))),
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
                text: _isOtpRequired?AppLocalizations.of(context).getVCode:AppLocalizations.of(context).submit,
              ),
              Gaps.vGap16,
              Visibility(
                  visible:_isOtpRequired,
                  child: Text('Your OTP will be sent to your registered mobile number',style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),)),
            ],
          ),
        ),
      ),
    ),
  ];

  void totalTransactionAmount(){
    if(_feeAmount.toString() != null && _amount.toString() != null&& _vatAmount.toString() != null&& _transactionTipOrConvenience.toString() != null){
      totalAmount = _feeAmount+_amount+_vatAmount+_transactionTipOrConvenience;
    }
  }

  void _initiate() async {
    final double amount = _amount;
    final int debitAccountId = _selectedDebitAccount.id;
    final String creditAccountIssuer =_selectedCreditAccountIssuer;
    final String purpose = _purpose;
    final String qrCodeData = _qrData;
    final String cvv = _cvv;
    final double tipOrConvenienceAmount = _transactionTipOrConvenience;

    var response = await presenter.qrFundTransfer(
        amount, debitAccountId, creditAccountIssuer, qrCodeData,purpose,cvv,tipOrConvenienceAmount);
    if (response != null) {
      _transaction = response;
      if (_transaction != null) {
        if(_isOtpRequired) {
          await _showPinDialog(_transaction);
        }else{
          if(_transaction.transactionStatus != 'Declined'){
            _onSuccess(_transaction);
          }else{
            _onFailed(_transaction);
          }
        }
      }
    }
  }

  Future<bool> _showPinDialog(TransactionViewModel transaction) async{
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QrCodePaymentOtpPage(transaction,TransactionAmountDescriptionWidget(transaction));}));
    _transaction = result!=null? result : null ;
    if(_transaction != null){
      if(_transaction.transactionStatus != 'Declined'){
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
      builder: (_) => TransactionCompletedPage(
        /*TransactionAmountDescriptionWidget(transaction),*/
        TransactionAccountSelector('From',_selectedDebitAccount,isEnabled: false),
        TransactionAccountSelector('To  ', LinkedAccountViewModel(
            accountNumberMasked: _merchantViewModel?.pan,
            accountHolderName: _scannedQrViewModel?.retailerName,
            instituteName:_scannedQrViewModel?.retailerName), isEnabled: false,),
        transaction,
      ),
    );
    future.then((value) => NavigatorUtils.goBackWithParams(context,transaction));
  }

  void _onSuccess(TransactionViewModel transaction) {
    _showSuccessDialog(transaction);
  }

  void _onFailed(TransactionViewModel transaction) {
    _showFailedDialog(transaction);
  }

  void _showFailedDialog(TransactionViewModel transaction) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: "",
            title: transaction.transactionStatus,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(transaction.transactionDetails,
                  textAlign: TextAlign.center),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
              NavigatorUtils.goBackWithParams(context,_transaction);
            },
          );
        });
  }


  @override
  bool get wantKeepAlive =>true;


  @override
  void setData(ScannedQrViewModel model) {
  }

  @override
  ScanQrCodePagePresenter createPresenter() =>ScanQrCodePagePresenter();

  @override
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel) {
  }


}