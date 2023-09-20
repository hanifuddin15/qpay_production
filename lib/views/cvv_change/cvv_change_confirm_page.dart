import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/views/cvv_change/cvv_change_iview.dart';

import '../../localization/app_localizations.dart';
import '../../mvp/base_page.dart';
import '../../net/contract/linked_account_vm.dart';
import '../../net/contract/transaction_vm.dart';
import '../../routers/fluro_navigator.dart';
import '../../utils/helper_utils.dart';
import '../../widgets/account_selector.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/confirmation_screen_column_box.dart';
import '../../widgets/load_image.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_scroll_view.dart';
import '../../widgets/transaction_account_selector.dart';
import '../../widgets/transaction_description_widget.dart';
import '../shared/transaction_complete_page.dart';
import 'cvv_change_otp_page.dart';
import 'cvv_change_presenter.dart';

class Cvv2ChangeConfirmPage extends StatefulWidget{
  final double feeAmount;
  final double vatAmount;
  final AccountSelector from;
  final LinkedAccountViewModel selectedAccount;
  final String newCvvSecurity;
  final String purpose;

  Cvv2ChangeConfirmPage(this.feeAmount, this.vatAmount, this.from, this.selectedAccount, this.newCvvSecurity, this.purpose);

  @override
  _Cvv2ChangeConfirmPageState createState() => _Cvv2ChangeConfirmPageState(selectedAccount,feeAmount,vatAmount,from,newCvvSecurity,purpose);
}

class _Cvv2ChangeConfirmPageState extends State<Cvv2ChangeConfirmPage>
    with
        BasePageMixin<Cvv2ChangeConfirmPage, Cvv2ChangePresenter>,
        AutomaticKeepAliveClientMixin<Cvv2ChangeConfirmPage>
    implements Cvv2ChangeIMvpView{
  TransactionViewModel _transaction;
  final LinkedAccountViewModel _selectedAccount;
  final double _feeAmount;
  final double _vatAmount;
  final AccountSelector from;
  final String _newCvvSecurity;
  final String _purpose;
  double totalAmount = 0;
  bool _value = false;
  bool _clickable = false;

  _Cvv2ChangeConfirmPageState(this._selectedAccount, this._feeAmount, this._vatAmount, this.from,this._newCvvSecurity, this._purpose);

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
          centerTitle: AppLocalizations.of(context).changeCvv2,
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
                          ConfirmScreenAmountColumnBox('Amount',HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(0.0))),
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
                    ],
                  ),
                ),
              ),
              Gaps.vGap16,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _value,
                    onChanged: (bool value) {
                      if(mounted) {
                        setState(() {
                          _value = value;
                          _verify();
                        });
                      }
                    },
                  ),
                  Flexible(
                    child: Text(
                      'I agree that once the existing CVV2 is changed, only the generated CVV2 will work for online or e-commerce transactions.',
                      style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text),
                    ),
                  ),
                ],
              ),
              Gaps.vGap24,
              MyButton(
                key: const Key('confirm'),
                onPressed:  _clickable? _initiate:null,
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
    if(_feeAmount.toString() != null  && _vatAmount.toString() != null){
      totalAmount = _feeAmount+_vatAmount;
    }
  }

  void _verify(){
    bool clickable = true;
    if(_value == false){
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _initiate() async {
    final int debitAccountId = _selectedAccount.id;
    final String cvv = '123';
    final String newCvv = _newCvvSecurity;
    final String purpose = _purpose;

     var response =
    await presenter.cvvChangeTransfer(debitAccountId,purpose,cvv,newCvv);

    if (response != null) {
      _transaction = response;
      if (_transaction != null) {
        _showPinDialog(_transaction);
      }
    }
  }

  Future<bool> _showPinDialog(TransactionViewModel transaction) async {

    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Cvv2ChangeOtpPage(transaction,TransactionAmountDescriptionWidget(transaction));}));
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
        TransactionAccountSelector('From',_selectedAccount,isEnabled: false),
        null,
        transaction,
      ),
    );
    future.then((value) => NavigatorUtils.goBackWithParams(context,transaction));
  }

  void _onSuccess(TransactionViewModel transaction) {
    _showSuccessDialog(transaction);
  }

  @override
  Cvv2ChangePresenter createPresenter() =>Cvv2ChangePresenter();



  @override
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel) {
  }

  @override
  bool get wantKeepAlive => true;
  
}