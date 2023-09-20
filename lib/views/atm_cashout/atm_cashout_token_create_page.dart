import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/providers/cash_out_token_provide.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/dashboard_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/transaction_type.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/atm_cashout/atm_cashout_iview.dart';
import 'package:qpay/views/atm_cashout/atm_cashout_presenter.dart';
import 'package:qpay/views/atm_cashout/atm_cashout_token_create_otp_page.dart';
import 'package:qpay/views/home/accounts/all_account_selector_page.dart';
import 'package:qpay/views/home/accounts/card_selector_page.dart';
import 'package:qpay/views/shared/transaction_complete_page.dart';
import 'package:qpay/widgets/account_selector.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/pin_input_dialog.dart';
import 'package:qpay/widgets/text_field.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';

import 'atm_cashout_token_create_confirmation_page.dart';

class AtmCashOutTokenCreatePage extends StatefulWidget {
  @override
  _CashOutTokenCreatePageState createState() => _CashOutTokenCreatePageState();
}

class _CashOutTokenCreatePageState extends State<AtmCashOutTokenCreatePage>
    with
        BasePageMixin<AtmCashOutTokenCreatePage, AtmCashOutPresenter>,
        AutomaticKeepAliveClientMixin<AtmCashOutTokenCreatePage>
    implements AtmCashOutIMvpView {
  var accountSelectionListener = TransactionAccountSelectionListener();
  LinkedAccountViewModel _selectedAccount;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _clickable = false;
  TransactionViewModel _transaction;
  CashOutTokenProvider _cashOutTokenProvider = CashOutTokenProvider();
  List<TransactionCategoryViewModel> _categoiesList =
  <TransactionCategoryViewModel>[];
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];
  String feeAmount='';
  String vatAmount='';
  bool isOtpRequired=false;
  bool _newEnable = false;
  bool _cvvEnabled = false;
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_verify);
    _purposeController.addListener(_verify);
    _cvvController.addListener(_verify);
    accountSelectionListener.addListener(_onAccountSelected);
  }

  @override
  void dispose() {
    accountSelectionListener.removeListener(_onAccountSelected);
    _amountController.removeListener(_verify);
    _amountController.dispose();
    _purposeController.removeListener(_verify);
    _purposeController.dispose();
    _cvvController.removeListener(_verify);
    _cvvController.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    _nodeText3.dispose();
    accountSelectionListener.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).cashByCode,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton:  MediaQuery.of(context).viewInsets.bottom != 0.0?null: FloatingActionButton.extended(
            elevation: 0.0,
            icon: Icon(Icons.list),
            label: Text(AppLocalizations.of(context).tokenList),
            backgroundColor: Colours.app_main,
            onPressed: _createNewToken),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1,_nodeText2,_nodeText3]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return [
      GestureDetector(
          child: AccountSelector("Pay from", _selectedAccount,isSource: true,),
          onTap: () {
            _selectAccount();
          }),
      Gaps.line,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gaps.vGap16,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: ()=>{
                  availableBalace(_selectedAccount.id)
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    AppLocalizations.of(context).availBalance,
                    style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.app_main,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      Visibility(
        visible: _selectedAccount != null && _selectedAccount.productType == 'DebitCard',
        child: Column(
          children: [
            Gaps.vGap16,
            MyTextField(
              key: const Key('cvv'),
              iconName: 'cvv',
              focusNode: _nodeText3,
              controller: _cvvController,
              maxLength: 3,
              isInputPwd: true,
              keyboardType: TextInputType.number,
              showCursor: _nodeText3.hasFocus?true:false,
              hintText: AppLocalizations.of(context).inputCVV,
              labelText: AppLocalizations.of(context).inputCVV,
              enabled: _selectedAccount != null,
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
      Gaps.vGap16,
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "* Input Amount Should be 500 or it\'s multiples",
          style: TextStyle(fontSize: Dimens.font_sp10,color: Colours.text_gray),
        ),
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('amount'),
        iconName: 'amount',
        focusNode: _nodeText1,
        controller: _amountController,
        maxLength: 5,
        keyboardType: TextInputType.number,
        showCursor: _nodeText1.hasFocus?true:false,
        hintText: AppLocalizations.of(context).inputAmount,
        labelText: AppLocalizations.of(context).inputAmount,
        enabled: _selectedAccount != null && _selectedAccount.productType == 'DebitCard'?_cvvEnabled:_selectedAccount != null,
        textInputAction: TextInputAction.done,
      ),
      Gaps.vGap4,
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          AppLocalizations.of(context).atmCashOutAmountLimit,
          style: TextStyle(fontSize: Dimens.font_sp10,color: Colours.text_gray),
        ),
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('purpose'),
        iconName: 'purpose',
        focusNode: _nodeText2,
        controller: _purposeController,
        maxLength: 50,
        keyboardType: TextInputType.text,
        showCursor: _nodeText2.hasFocus?true:false,
        hintText: AppLocalizations.of(context).inputPurpose,
        labelText: AppLocalizations.of(context).inputPurpose,
        textInputAction: TextInputAction.done,
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
              "If a generated Cash by Code token is expired or disputed, to settle the transaction, it may take upto 3 business days.",
              style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),
            ),
          ),
        ],
      ),
      Gaps.vGap24,
      MyButton(
        key: const Key('confirm'),
        onPressed: _clickable ? _next : null,
        text: AppLocalizations.of(context).nextStep,
      ),
    ];
  }

  void availableBalace(int accountId) async{
    var balanceResponse = await presenter.accountBalance(accountId);
    if(balanceResponse != null){
      showBalanceDialoge(balanceResponse);
    }
  }

  void _next() async {
    final double amount = double.parse(_amountController.text);
    final String purpose = _purposeController.text;
    final String cvvString = _cvvController.text;
    String id = '';
    for(var category in _categoiesList) {
      if (category.type == TransactionType.CashByCode.toString().split('.').last) {
        id = category.id;
        break;
      }
    }
    var response = await presenter.transactionFeeCalculate(id, amount);
    if (response != null) {
      txnFees = response;
      for (var vendor in txnFees) {
        if (vendor.vendorName == 'QCash') {
          vendor.fee != 'Free' ? feeAmount = vendor?.fee?.replaceAll('৳ ', '') : feeAmount = '0';
          vendor.vat !='N/A'? vatAmount = vendor?.vat?.replaceAll('৳ ', '') : vatAmount = '0';
          isOtpRequired = vendor?.isOtpRequired;
          break;
        }
      }
      showConfirmation(amount,cvvString,double.parse(feeAmount),double.parse(vatAmount),purpose,isOtpRequired);
    }
  }

  Future<bool> showConfirmation(double amount, String cvvString,double feeAmount,double vatAmount,String purpose,bool isOtpRequired) async{
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AtmCashOutTokenCreateConfirmationPage(
          amount,
          feeAmount,
          vatAmount,
          AccountSelector("From", _selectedAccount, isEnabled: false),
          _selectedAccount,purpose,cvvString,isOtpRequired);
    }));
    _transaction = result!=null? result : null ;
    if(_transaction.transactionStatus != 'Declined'){
      NavigatorUtils.goBack(context);
    }else{
      _purposeController.text = '';
      _amountController.text = '';
      _cvvController.text = '';
      _selectedAccount = null;
    }
  }

  void _selectAccount() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: false,
        builder: (_) => CardsSelectorPage(Constant.transactionAccountSelector));
  }

  @override
  AtmCashOutPresenter createPresenter() {
    return AtmCashOutPresenter(false);
  }

  @override
  void setTokens(List<CashOutTokenViewModel> tokens) {
  }



  @override
  bool get wantKeepAlive => true;

  void _verify() {
    final String amountString = _amountController.text;
    final String cvvString = _cvvController.text;
    bool clickable = true;
    bool newEnable = true;
    bool cvvEnabled = true;

    if (_selectedAccount == null) {
      clickable = false;
    }

    if (amountString.isEmpty) {
      clickable = false;
      newEnable = false;
    }
    if (_selectedAccount != null &&
        _selectedAccount.productType == 'DebitCard') {
      if (cvvString.isEmpty) {
        clickable = false;
        cvvEnabled = false;
      }
      if (cvvString.length < 3) {
        clickable = false;
        cvvEnabled = false;
      }
    }

    if (amountString.isNotEmpty) {
      var amount = double.parse(amountString);
      if (amount < 500 || amount > 20000) {
        clickable = false;
        newEnable = false;
      }
    }

    if (amountString.isNotEmpty) {
      var amount = double.parse(amountString);
      if (amount % 500 != 0.0) {
        clickable = false;
      }
    }

    if (_value == false) {
      clickable = false;
    }

    if (mounted) {
      if (cvvEnabled != _cvvEnabled) {
        setState(() {
          _cvvEnabled = cvvEnabled;
        });
      }
      if (newEnable != _newEnable) {
        setState(() {
          _newEnable = newEnable;
        });
      }
      if (clickable != _clickable) {
        setState(() {
          _clickable = clickable;
          // _nodeText1.unfocus();
          _nodeText2.unfocus();
          _nodeText3.unfocus();
        });
      }
    }
  }

  void _onAccountSelected() {
    var account = accountSelectionListener.selectedAccount;
    if (mounted && account != null) {
      setState(() {
        _selectedAccount = accountSelectionListener.selectedAccount;
        _verify();
      });
    }
  }

  void _createNewToken() {
    NavigatorUtils.push(context, DashboardRouter.atmCashOutPage);
  }

  @override
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel) {
    if(mounted) {
      setState(() {
        _categoiesList = transactionCategoryViewModel;
      });
    }
  }

  void showBalanceDialoge(List<AccountBalanceViewModel> balanceResponse) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: "",
            title: AppLocalizations.of(context).availBalance,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: balanceResponse.length,
                  itemBuilder: (context, index){
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gaps.vGap8,
                        Text("Available Balance:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                        Gaps.vGap8,
                        Text(balanceResponse[index].currency+" " + balanceResponse[index].balance,style: TextStyle(color: Colours.textBlueColor,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: 'SF'),),
                        Gaps.vGap8,
                      ],
                    ),
                  );
                  }),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }
}
