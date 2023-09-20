import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/views/cvv_change/cvv_change_confirm_page.dart';
import 'package:qpay/views/cvv_change/cvv_change_iview.dart';
import 'package:qpay/views/cvv_change/cvv_change_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

import '../../common/appconstants.dart';
import '../../localization/app_localizations.dart';
import '../../mvp/base_page.dart';
import '../../net/contract/linked_account_vm.dart';
import '../../net/contract/transaction_fee_vm.dart';
import '../../net/contract/transaction_vm.dart';
import '../../net/contract/transactions_category_vm.dart';
import '../../providers/account_selection_listener.dart';
import '../../res/colors.dart';
import '../../res/dimens.dart';
import '../../res/gaps.dart';
import '../../routers/fluro_navigator.dart';
import '../../static_data/transaction_type.dart';
import '../../utils/utils.dart';
import '../../widgets/account_selector.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_dialog.dart';
import '../../widgets/text_field.dart';
import '../home/accounts/card_selector_page.dart';

class Cvv2ChangePage extends StatefulWidget{
  @override
  _Cvv2ChangePageState createState() => _Cvv2ChangePageState();
}

class _Cvv2ChangePageState extends State<Cvv2ChangePage>
    with
        BasePageMixin<Cvv2ChangePage, Cvv2ChangePresenter>,
        AutomaticKeepAliveClientMixin<Cvv2ChangePage>
    implements Cvv2ChangeIMvpView{
  var accountSelectionListener = TransactionAccountSelectionListener();
  LinkedAccountViewModel _selectedAccount;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();

  final TextEditingController _newCvv2Controller = TextEditingController();
  final TextEditingController _confirmNewCvv2Controller = TextEditingController();
  bool _clickable = false;
  List<TransactionCategoryViewModel> _categoiesList =
  <TransactionCategoryViewModel>[];
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];
  TransactionViewModel _transaction;
  String feeAmount='';
  String vatAmount='';
  String chargedAmount='';
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _newCvv2Controller.addListener(_verify);
    _confirmNewCvv2Controller.addListener(_verify);
    accountSelectionListener.addListener(_onAccountSelected);
  }

  @override
  void dispose() {
    _newCvv2Controller.removeListener(_verify);
    _newCvv2Controller.dispose();
    _confirmNewCvv2Controller.removeListener(_verify);
    _confirmNewCvv2Controller.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    accountSelectionListener.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(centerTitle: AppLocalizations.of(context).changeCvv2,),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1, _nodeText2,_nodeText3]),
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
          child: AccountSelector("Pay from", _selectedAccount, isSource: true,),
          onTap: () {
            _selectAccount();
          }),
      Gaps.line,
      Gaps.vGap16,
      MyTextField(
        key: const Key('cvv_new'),
        iconName: 'cvv',
        focusNode: _nodeText1,
        controller: _newCvv2Controller,
        maxLength: 3,
        isInputPwd: true,
        showCursor: _nodeText1.hasFocus?true:false,
        keyboardType: TextInputType.number,
        hintText: AppLocalizations.of(context).newCVV2,
        labelText: AppLocalizations.of(context).newCVV2,
        enabled:_selectedAccount != null,
      ),
      Gaps.vGap16,
      MyTextField(
        key: const Key('cvv_confirm'),
        iconName: 'cvv',
        focusNode: _nodeText2,
        controller: _confirmNewCvv2Controller,
        maxLength: 3,
        isInputPwd: true,
        showCursor: _nodeText2.hasFocus?true:false,
        keyboardType: TextInputType.number,
        hintText: AppLocalizations.of(context).confirmNewCVV2,
        labelText: AppLocalizations.of(context).confirmNewCVV2,
        enabled: _isEnabled,
      ),
      Gaps.vGap4,
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          'Min and Max length 3',
          style: TextStyle(fontSize: Dimens.font_sp10,color: Colours.text_gray),
        ),
      ),
      Gaps.vGap24,
      MyButton(
        key: const Key('confirm'),
        onPressed: _clickable ? _next : null,
        text: AppLocalizations.of(context).nextStep,
      ),
    ];
  }

  void _next() async {
    final double amount = 1.0;
    final String newCvv2String = _newCvv2Controller.text;
    String id = '';
    for(var category in _categoiesList) {
      if (category.type == TransactionType.CardVerificationValue.toString().split('.').last) {
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
          break;
        }
      }
      showConfirmation(double.parse(feeAmount),double.parse(vatAmount),newCvv2String,null);
    }
  }

  Future<bool> showConfirmation(double feeAmount,double vatAmount,String newCvvString,String purpose) async{
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Cvv2ChangeConfirmPage(
          feeAmount,
          vatAmount,
          AccountSelector("From", _selectedAccount, isEnabled: false),
          _selectedAccount,
          newCvvString,
          purpose);
    }));
    _transaction = result!=null? result : null ;
    if(_transaction.transactionStatus != 'Declined'){
      NavigatorUtils.goBack(context);
    }else{
      _newCvv2Controller.text = '';
      _confirmNewCvv2Controller.text = '';
      _selectedAccount = null;
    }
  }

  void _verify() {
    final String newCvv2String = _newCvv2Controller.text;
    final String confirmCvv2String = _confirmNewCvv2Controller.text;
    bool clickable = true;
    bool isEnabled = true;

    if (_selectedAccount == null) {
      clickable = false;
    }

    if (newCvv2String.isEmpty) {
      clickable = false;
      isEnabled = false;
    }
    if (confirmCvv2String.isEmpty) {
      clickable = false;
    }


    if (newCvv2String.isNotEmpty) {

      if (newCvv2String.length < 3) {
        clickable = false;
        isEnabled = false;

      }
    }

    if (confirmCvv2String.isNotEmpty) {
      if (confirmCvv2String.length < 3) {
        clickable = false;
      }
    }
    if(newCvv2String!= confirmCvv2String){
      clickable = false;
    }

    if(mounted) {
      if (isEnabled != _isEnabled) {
        setState(() {
          _isEnabled = isEnabled;
        });
      }

      if (clickable != _clickable) {
        setState(() {
          _clickable = clickable;
          _nodeText1.unfocus();
          _nodeText2.unfocus();
        });
      }
    }
  }

  void _selectAccount() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: false,
        builder: (_) => CardsSelectorPage(Constant.transactionAccountSelector,pgHide: true,));
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

  @override
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel) {
    if(mounted) {
      setState(() {
        _categoiesList = transactionCategoryViewModel;
      });
    }
    _showWarning(context);
  }

  @override
  Cvv2ChangePresenter createPresenter() => Cvv2ChangePresenter();

  @override
  bool get wantKeepAlive => true;

  _showWarning(BuildContext context){
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).confirm,
            cancelText: AppLocalizations.of(context).cancel,
            title: 'Warning',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadAssetImage('dispute_icon',width: 36,),
                  Gaps.vGap16,
                  Text(AppLocalizations.of(context).cvvChangeWarning,
                      style: TextStyle(fontSize: Dimens.font_sp16),
                      textAlign: TextAlign.justify),
                ],
              ),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
            },
            onBackPressed: (){
              NavigatorUtils.goBack(context);
              NavigatorUtils.goBack(context);
            },
          );
        });
  }
}