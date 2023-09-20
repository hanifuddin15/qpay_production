import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/views/mobile_recharge/mobile_recharge_otp_page.dart';
import 'package:qpay/views/shared/transaction_complete_page.dart';
import 'package:qpay/widgets/account_selector.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/confirmation_screen_column_box.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/transaction_account_selector.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';

import '../../utils/utils.dart';
import '../../widgets/my_dialog.dart';
import '../shared/webview_gateway_page.dart';
import 'mobile_recharge_iview.dart';
import 'mobile_recharge_presenter.dart';

class MobileRechargeConfirmationPage extends StatefulWidget{
  final String phone;
  final double amount;
  final int mobileOperator;
  final int simType;
  final double feeAmount;
  final double vatAmount;
  final AccountSelector from;
  final AccountSelector to;
  final LinkedAccountViewModel selectedAccount;
  final String purpose;final String contactName;
  final String oparetorName;
  final String cvv;
  final bool isOtpRequired;

  MobileRechargeConfirmationPage(this.phone, this.amount, this.mobileOperator,
      this.simType, this.feeAmount, this.vatAmount, this.from, this.to, this.selectedAccount, this.purpose, this.contactName,this.oparetorName, this.cvv, this.isOtpRequired);

  @override
  _MobileRechargeConfirmationPageState createState() => _MobileRechargeConfirmationPageState(selectedAccount,phone,amount,mobileOperator,simType,feeAmount,vatAmount,from,to,purpose,contactName,oparetorName,cvv,isOtpRequired);
}

class _MobileRechargeConfirmationPageState extends State<MobileRechargeConfirmationPage>
    with
        BasePageMixin<MobileRechargeConfirmationPage, MobileRechargePresenter>,
        AutomaticKeepAliveClientMixin<MobileRechargeConfirmationPage>
    implements MobileRechargeIMvpView {
  TransactionViewModel _transaction;
  TransactionViewModel _pgTransaction;
  final LinkedAccountViewModel _selectedAccount;
  final String _phone;
  final double _amount;
  final int _mobileOperator;
  final int _simType;
  final double _feeAmount;
  final double _vatAmount;
  final AccountSelector from;
  final AccountSelector to;
  final String _purpose;
  final String _contactName;
  final String _oparetorName;
  final String _cvv;
  final bool _isOtpRequired;

  double totalAmount = 0;


  _MobileRechargeConfirmationPageState(
      this._selectedAccount,
      this._phone,
      this._amount,
      this._mobileOperator,
      this._simType,
      this._feeAmount,
      this._vatAmount,
      this.from,
      this.to,
      this._purpose,
      this._contactName,
      this._oparetorName,
      this._cvv,
      this._isOtpRequired);

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
          centerTitle: AppLocalizations.of(context).mobileRecharge,
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
                onPressed:   _getOtp,
                text:_selectedAccount!=null && _selectedAccount.id ==-100?AppLocalizations.of(context).submit:_isOtpRequired? AppLocalizations.of(context).getVCode:AppLocalizations.of(context).submit,
              ),
              Gaps.vGap16,
              Visibility(
                  visible: _isOtpRequired,
                  child: Text('Your OTP will be sent to your registered mobile number',style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),)),
            ],
          ),
        ),
      ),
    ),
  ];

  void totalTransactionAmount(){
    if(_feeAmount.toString() != null && _amount.toString() != null&& _vatAmount.toString() != null){
      totalAmount = _feeAmount+_amount+_vatAmount;
    }
  }

  void _getOtp() async{
    final String phone = _phone;
    final double amount =_amount;
    final int mobileOperator = _mobileOperator; //select operator
    final int simType = _simType; //select operator
    final String purpose = _purpose;
    final String cvv = _cvv;
    var response = await presenter.mobileRecharge(amount, mobileOperator,
        simType, _selectedAccount.id, phone,purpose,cvv);
    if (response != null) {
      _transaction = response;
      if (_transaction != null) {
        if (_transaction.isRedirectAllow) {
          var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return WebViewGatewayPage(AppLocalizations.of(context).mobileRecharge,_transaction.redirectUrl);
          }));
          _pgTransaction = result;
          if(_pgTransaction != null){
            if (_pgTransaction.transactionStatus != 'Declined') {
              _onSuccess(_pgTransaction);
            } else {
              _onFailed(_pgTransaction);
            }
          }
        } else {
          if (_isOtpRequired) {
            _showPinDialog(_transaction);
          } else {
            if (_transaction.transactionStatus != 'Declined') {
              _onSuccess(_transaction);
            } else {
              _onFailed(_transaction);
            }
          }
        }
      }
    }
  }

  Future<bool> _showPinDialog(TransactionViewModel transaction) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MobileRechargeOtpPage(transaction,TransactionAmountDescriptionWidget(transaction));}));
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
        TransactionAccountSelector("From", _selectedAccount, isEnabled: false),
        TransactionAccountSelector(
            "To  ",
            LinkedAccountViewModel(
                accountNumberMasked: _phone,
                accountHolderName: _contactName ?? _oparetorName,
                instituteName:_oparetorName),
            isEnabled: false),
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
  MobileRechargePresenter createPresenter() => MobileRechargePresenter();

  @override
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel) {
  }

  @override
  void setVendorList(List<BillVendorViewModel> vendorList) {
  }

  @override
  bool get wantKeepAlive =>true;
}