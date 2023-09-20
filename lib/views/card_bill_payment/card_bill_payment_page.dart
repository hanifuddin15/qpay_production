import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/transaction_type.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/card_bill_payment/card_bill_payment_confirmation_page.dart';
import 'package:qpay/views/card_bill_payment/card_bill_payment_iview.dart';
import 'package:qpay/views/home/accounts/all_account_selector_page.dart';
import 'package:qpay/views/home/accounts/card_selector_page.dart';
import 'package:qpay/views/shared/transaction_complete_page.dart';
import 'package:qpay/widgets/account_selector.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/number_formatter_two_decimal.dart';
import 'package:qpay/widgets/pin_input_dialog.dart';
import 'package:qpay/widgets/text_field.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';

import 'card_bill_payment_otp_page.dart';
import 'card_bill_payment_presenter.dart';

class CardBillPaymentPage extends StatefulWidget {
  @override
  _CardBillPaymentPageState createState() => _CardBillPaymentPageState();
}

class _CardBillPaymentPageState extends State<CardBillPaymentPage>
    with
        BasePageMixin<CardBillPaymentPage, CardBillPaymentPresenter>,
        AutomaticKeepAliveClientMixin<CardBillPaymentPage>
    implements CardBillPaymentIMvpView {
  var accountSelectionListener = TransactionAccountSelectionListener();
  Widget _cardIcon = CardUtils.getCardIcon(CardType.Others);
  LinkedAccountViewModel _selectedAccount;
  LinkedAccountViewModel _selectedCreditCard;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _clickable = false;
  bool _newEnable = false;
  bool _cvvEnabled = false;
  TransactionViewModel _transaction;
  CardType _cardType;
  String _selectIntent;
  List<TransactionCategoryViewModel> _categoiesList =
  <TransactionCategoryViewModel>[];
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];
  String feeAmount='';
  String vatAmount='';
  bool isOtpRequired=false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_verify);
    _amountController.addListener(_verify);
    _purposeController.addListener(_verify);
    _cvvController.addListener(_verify);
    accountSelectionListener.addListener(_onAccountSelected);
  }

  @override
  void dispose() {
    accountSelectionListener.removeListener(_onAccountSelected);
    _cardNumberController.removeListener(_verify);
    _amountController.removeListener(_verify);
    _cardNumberController.dispose();
    _amountController.dispose();
    _purposeController.removeListener(_verify);
    _purposeController.dispose();
    _cvvController.removeListener(_verify);
    _cvvController.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    _nodeText3.dispose();
    _nodeText4.dispose();
    accountSelectionListener.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).cardBillPayment,
        ),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1, _nodeText2,_nodeText3,_nodeText4]),
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
            _selectIntent = "debit";
            _selectSenderCard();
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Gaps.vGap16,
            MyTextField(
              key: const Key('cvv'),
              iconName: 'cvv',
              focusNode: _nodeText4,
              controller: _cvvController,
              maxLength: 3,
              isInputPwd: true,
              keyboardType: TextInputType.number,
              showCursor: _nodeText4.hasFocus?true:false,
              hintText: AppLocalizations.of(context).inputCVV,
              labelText: AppLocalizations.of(context).inputCVV,
              enabled: _selectedAccount != null,
            ),
          ],
        ),
      ),
      Gaps.vGap16,
      GestureDetector(
        child: AccountSelector("Pay to", _selectedCreditCard),
        onTap: _cvvEnabled?() {
          _selectIntent = "credit";
          _selectReceiver();
        }:null,
      ),
      Gaps.line,
      Gaps.vGap8,
      MyTextField(
        key: const Key('amount'),
        iconName: 'amount',
        focusNode: _nodeText2,
        controller: _amountController,
        maxLength: 9,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        showCursor: _nodeText2.hasFocus?true:false,
        inputFormatterList: <TextInputFormatter>[
          NumberRemoveExtraDotFormatter(),
        ],
        hintText: AppLocalizations.of(context).inputAmount,
        labelText: AppLocalizations.of(context).inputAmount,
        enabled: _selectedCreditCard != null,
      ),
      Gaps.vGap4,
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          AppLocalizations.of(context).cardBillAmountLimit,
          style: TextStyle(fontSize: Dimens.font_sp10,color: Colours.text_gray),
        ),
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('purpose'),
        iconName: 'purpose',
        focusNode: _nodeText3,
        controller: _purposeController,
        maxLength: 50,
        keyboardType: TextInputType.text,
        showCursor: _nodeText3.hasFocus?true:false,
        hintText: AppLocalizations.of(context).inputPurpose,
        labelText: AppLocalizations.of(context).inputPurpose,
        enabled: _newEnable,
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
    final String cvv = _cvvController.text;
    String id = '';
    for(var category in _categoiesList) {
      if (category.type == TransactionType.CreditCardBillPayment.toString().split('.').last) {
        id = category.id;
        break;
      }
    }
    var response = await presenter.transactionFeeCalculate(id, amount);
    if (response != null) {
      txnFees = response;
      for (var vendor in txnFees) {
        if (vendor.vendorName == 'QCash') {
          vendor.fee != 'Free' ? feeAmount = vendor.fee.replaceAll('৳ ', '') : feeAmount = '0';
          vendor.vat !='N/A'? vatAmount = vendor.vat.replaceAll('৳ ', '') : vatAmount = '0';
          isOtpRequired = vendor?.isOtpRequired;
          break;
        }
      }
      showConfirmation(amount,double.parse(feeAmount),double.parse(vatAmount),purpose,cvv,isOtpRequired);
    }
  }

  Future<bool> showConfirmation( double amount, double feeAmount, double vatAmount,String purpose,String cvv,bool isOtpRequired) async{
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CardBillPaymentConfirmationPage(
          amount,
          feeAmount,
          vatAmount,
          AccountSelector("From", _selectedAccount, isEnabled: false),
          AccountSelector("To", _selectedCreditCard, isEnabled: false),
          _selectedAccount,
          _selectedCreditCard,
      purpose,cvv,isOtpRequired);
    }));
    _transaction = result!=null? result : null ;
    if(_transaction.transactionStatus != 'Declined'){
      NavigatorUtils.goBack(context);
    }else{
      _amountController.text = '';
      _purposeController.text = '';
      _cvvController.text = '';
      _selectedAccount = null;
      _selectedCreditCard = null;
    }
  }


  void _selectSenderCard() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: false,
        builder: (_) => CardsSelectorPage(Constant.transactionAccountSelector));
  }

  void _selectReceiver() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: false,
        builder: (_) => /*AllAccountSelectorPage(
          Constant.transactionAccountSelector, 'card_bill', selectedAccountId: _selectedAccount?.id,cardType: 'DebitCard|PrepaidCard',));*/
        CardsSelectorPage(Constant.transactionAccountSelector, selectedAccountId: _selectedAccount?.id,cardType: 'DebitCard|PrepaidCard',pgHide: true,));
  }

  @override
  CardBillPaymentPresenter createPresenter() {
    return new CardBillPaymentPresenter();
  }

  @override
  bool get wantKeepAlive => true;

  void _verify() {
    final String cardNumber =
        CardUtils.getCleanedNumber(_cardNumberController.text);
    final String amountString = _amountController.text;
    final String cvvString = _cvvController.text;
    bool clickable = true;
    bool newEnable = true;
    bool cvvEnabled = true;

    if ((cardNumber.isEmpty || !CardUtils.isValidCardNumber(cardNumber)) &&
        _selectedCreditCard == null) {
      clickable = false;
    }

    if(_selectedAccount != null && _selectedAccount.productType == 'DebitCard') {
      if (cvvString.isEmpty) {
        clickable = false;
        cvvEnabled = false;
      }
      if(cvvString.length<3){
        clickable = false;
        cvvEnabled = false;
      }
    }

    if(_selectedAccount!=null && _selectedCreditCard!=null){
      var debitId = _selectedAccount.id;
      var creditId = _selectedCreditCard.id;
      if(debitId==creditId && _selectedAccount.ownershipType == _selectedCreditCard.ownershipType){
        _selectedCreditCard = null;
        _clickable = false;
      }
    }

    _cardType = CardUtils.getCardTypeFrmNumber(cardNumber);
    if (_cardType == CardType.Invalid) {
//      clickable = false;
    } else {
      var cardIcon = CardUtils.getCardIcon(_cardType);
      if(mounted){
        setState(() {
          _cardIcon = cardIcon;
        });
      }
    }

    if (_selectedAccount == null) {
      clickable = false;
    }
    if (_selectedCreditCard == null) {
      clickable = false;
    }
    if (amountString.isEmpty) {
      clickable = false;
      newEnable = false;
    }

    if (amountString.isNotEmpty) {
      var amount = double.parse(amountString);
      if (amount < 0 || amount>200000) {
        clickable = false;
        newEnable = false;
      }
    }
    if(mounted) {
      if (newEnable != _newEnable) {
        setState(() {
          _newEnable = newEnable;
        });
      }
      if (cvvEnabled != _cvvEnabled) {
        setState(() {
          _cvvEnabled = cvvEnabled;
        });
      }

      if (clickable != _clickable) {
        setState(() {
          _clickable = clickable;
          _nodeText1.unfocus();
          //_nodeText2.unfocus();
          _nodeText3.unfocus();
          _nodeText4.unfocus();
        });
      }
    }
  }

  void _onAccountSelected() {
    var account = accountSelectionListener.selectedAccount;
    if (mounted && account != null) {
      setState(() {
        if (_selectIntent == "credit") {
          _selectedCreditCard = accountSelectionListener.selectedAccount;
          _cardNumberController.text = _selectedCreditCard?.accountNumberMasked;
        } else {
          _selectedAccount = accountSelectionListener.selectedAccount;
        }
        _verify();
      });
    }
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
