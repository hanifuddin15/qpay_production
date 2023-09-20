import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/custom_contact.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/mobile_operator.dart';
import 'package:qpay/net/contract/sim_type.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/dashboard_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/transaction_type.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/home/accounts/all_account_selector_page.dart';
import 'package:qpay/views/home/accounts/card_selector_page.dart';
import 'package:qpay/views/mobile_recharge/mobile_recharge_iview.dart';
import 'package:qpay/views/mobile_recharge/mobile_recharge_presenter.dart';
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

import '../shared/webview_gateway_page.dart';
import 'mobile_recharge_confirmation_page.dart';
import 'mobile_recharge_otp_page.dart';

class MobileRechargePage extends StatefulWidget {
  @override
  _MobileRechargePageState createState() => _MobileRechargePageState();
}

class _MobileRechargePageState extends State<MobileRechargePage>
    with
        BasePageMixin<MobileRechargePage, MobileRechargePresenter>,
        AutomaticKeepAliveClientMixin<MobileRechargePage>
    implements MobileRechargeIMvpView {
  var accountSelectionListener = TransactionAccountSelectionListener();
  LinkedAccountViewModel _selectedAccount;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
/*  List<MobileOperator> _operators = MobileOperator.getMobileOperators();
  List<SimType> _simTypes = SimType.getSimTypes();*/
  List<BillVendorViewModel> _billVendorList = <BillVendorViewModel>[];
  List<ConnectionTypes> _connectionTypeList = <ConnectionTypes>[];
  var _isOperatorChangedByUser = false;
  bool _clickable = false;
  bool _newEnable = false;
  bool _cvvEnabled = false;
  BillVendorViewModel _selectedOperator;
  TransactionViewModel _transaction;
  ConnectionTypes _selectedSimType;
  String _contactName;
  List<TransactionCategoryViewModel> _categoiesList =
  <TransactionCategoryViewModel>[];
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];
  String feeAmount='';
  String vatAmount='';
  String lastSelectedContactNumber='';
  String _selectIntent;
  bool isOtpRequired=false;



  List<DropdownMenuItem<BillVendorViewModel>> buildDropdownOperatorItems(
      List operators) {
    var dataItems = operators ?? List<BillVendorViewModel>();
    List<DropdownMenuItem<BillVendorViewModel>> items = List();
    for (BillVendorViewModel operator in dataItems) {
      items.add(
        DropdownMenuItem(
          value: operator,
          child: Text(operator.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<ConnectionTypes>> buildDropDownSimTypes(List simTypes) {
    var dataItems = simTypes ?? <ConnectionTypes>[];
    List<DropdownMenuItem<ConnectionTypes>> items = [];
    for (ConnectionTypes simType in dataItems) {
      items.add(
        DropdownMenuItem(
          value: simType,
          child: Text(simType.name),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_verify);
    _amountController.addListener(_verify);
    _purposeController.addListener(_verify);
    _cvvController.addListener(_verify);
    _billVendorList.add(BillVendorViewModel(name: 'Select Operator',imageUrl: null,id: 0,connectionTypes: null));
    _connectionTypeList.add(ConnectionTypes(id:0,name:'Connection Type'));
    _selectedOperator = _billVendorList.first;
    _selectedSimType = _connectionTypeList.first;
    accountSelectionListener.addListener(_onAccountSelected);

  }

  @override
  void didChangeDependencies() {
    // _showProminantAlert();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    accountSelectionListener.removeListener(_onAccountSelected);
    _phoneController.removeListener(_verify);
    _phoneController.dispose();
    _amountController.removeListener(_verify);
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
          centerTitle: AppLocalizations.of(context).mobileRecharge,
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
    var width = MediaQuery.of(context).size.width;
    return [
      GestureDetector(
        child: AccountSelector("Pay from", _selectedAccount,isSource: true,),
        onTap: () {
          _selectIntent = "debit";
          _selectAccount();
        }
      ),
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
              showCursor: _nodeText4.hasFocus,
              hintText: AppLocalizations.of(context).inputCVV,
              labelText: AppLocalizations.of(context).inputCVV,
              enabled: _selectedAccount != null,
            ),
          ],
        ),
      ),
      Gaps.vGap16,
      MyTextField(
        key: const Key('phone'),
        iconName: 'phone',
        focusNode: _nodeText1,
        controller: _phoneController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        showCursor: _nodeText1.hasFocus,
        hintText: AppLocalizations.of(context).inputPhoneHint,
        labelText: AppLocalizations.of(context).inputPhoneHint,
        performAction: _showProminantAlert,
        duration: 1,
        actionName: AppLocalizations.of(context).selectContact,
        enabled: _selectedAccount != null && _selectedAccount.productType == 'DebitCard'?_cvvEnabled:_selectedAccount != null,
      ),
      Gaps.vGap8,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            height: 48,
            width: (width / 2) - Dimens.gap_dp24,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(
                  color: Colours.text_gray,
                  width: 1,
                ),),
            child: DropdownButtonHideUnderline(
              child: AbsorbPointer(
                absorbing:_phoneController.text.isEmpty,
                child: DropdownButton(
                  value: _selectedOperator,
                  items: buildDropdownOperatorItems(_billVendorList),
                  onChanged: onOperatorChange,
                  isExpanded: true,
                ),
              ),
            ),
          ),
          Gaps.hGap16,
          Container(
            width: (width / 2) - Dimens.gap_dp24,
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            height: 48,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(
                  color: Colours.text_gray,
                  width: 1,
                ),
                color: Colors.white),
            child: DropdownButtonHideUnderline(
              child: AbsorbPointer(
                absorbing: _selectedOperator.id==0,
                child: DropdownButton(
                  value: _selectedSimType,
                  items: buildDropDownSimTypes(_connectionTypeList),
                  onChanged: onSimTypeChange,
                  isExpanded: true,
                ),
              ),
            ),
          ),
        ],
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('amount'),
        iconName: 'amount',
        focusNode: _nodeText2,
        controller: _amountController,
        maxLength: 9,
        inputFormatterList: [ NumberRemoveExtraDotFormatter(),],
        keyboardType: TextInputType.number,
        showCursor: _nodeText2.hasFocus,
        hintText: AppLocalizations.of(context).inputAmount,
        labelText: AppLocalizations.of(context).inputAmount,
        enabled: _selectedOperator.id != 0 && _selectedSimType.id != 0,
      ),
      Gaps.vGap4,
      Visibility(
        visible: _selectedSimType.name=='Prepaid',
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            AppLocalizations.of(context).mobileRechargePrePaidAmountLimit,
            style: TextStyle(fontSize: Dimens.font_sp10,color: Colours.text_gray),
          ),
        ),
      ),Visibility(
        visible: _selectedSimType.name=='PostPaid',
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            AppLocalizations.of(context).mobileRechargePostAmountLimit,
            style: TextStyle(fontSize: Dimens.font_sp10,color: Colours.text_gray),
          ),
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
        showCursor: _nodeText3.hasFocus,
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
    final String phone = _phoneController.text;
    final double amount = double.parse(_amountController.text);
    final int mobileOperator = _selectedOperator.id; //select operator
    final int simType = _selectedSimType.id;
    final String purpose = _purposeController.text;
    final String cvvSecurity = _cvvController.text;
    String id = '';
    for(var category in _categoiesList) {
      if (category.type == TransactionType.MobileRecharge.toString().split('.').last) {
        id = category.id;
        break;
      }
    }
    var response = await presenter.transactionFeeCalculate(id, amount);
    if (response != null) {
      txnFees = response;
      for (var vendor in txnFees) {
        if (vendor.vendorName == _selectedOperator.name) {
          vendor.fee != 'Free' ? feeAmount = vendor.fee.replaceAll('৳ ', '') : feeAmount = '0';
          vendor.vat !='N/A'? vatAmount = vendor.vat.replaceAll('৳ ', '') : vatAmount = '0';
          isOtpRequired = vendor?.isOtpRequired;
          break;
        }
      }
      showConfirmation(phone,amount,mobileOperator,simType,double.parse(feeAmount),double.parse(vatAmount),purpose,cvvSecurity,isOtpRequired);
    }
  }

  void _verify() {
    final String phone = _phoneController.text;
    final String amountString = _amountController.text;
    final String cvvString = _cvvController.text;
    final int simType = _selectedSimType?.id; //select operator
    final String remarks = _purposeController.text;
    bool clickable = true;
    bool newEnable = true;
    bool cvvEnabled = true;
    if (phone.isEmpty ) {
      clickable = false;
      if(mounted) {
        setState(() {
          _selectedOperator = _billVendorList?.first;
          _connectionTypeList = <ConnectionTypes>[];
          _connectionTypeList.add(
              ConnectionTypes(id: 0, name: "Connection Type"));
          _selectedSimType = _connectionTypeList?.first;
        });
      }
      _isOperatorChangedByUser = false;
      _contactName = null;
    }
    if (phone.length<3 ) {

     if(mounted){ setState(() {
        _selectedOperator = _billVendorList?.first;
        _connectionTypeList = <ConnectionTypes>[];
        _connectionTypeList.add(ConnectionTypes(id: 0,name: "Connection Type"));
        _selectedSimType = _connectionTypeList?.first;
      });
     }
      _isOperatorChangedByUser = false;
      _contactName = null;
    }

    if(phone.length < 11){
      clickable = false;
    }

    if (_selectedAccount == null) {
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


    if (phone.isNotEmpty &&
        !_isOperatorChangedByUser){
      var _mobileOperator = _billVendorList[HelperUtils.defineOperatorFrom(phone)];
      if(mounted) {
        setState(() {
          if (_mobileOperator != _selectedOperator) {
            _selectedOperator = _mobileOperator;
            onOperatorChange(_mobileOperator);
          }
        });
      }
      if (_mobileOperator.id == 0) {
        clickable = false;
      }
    }
    if(phone.length == 11 && HelperUtils.isInvalidPhoneNumber(phone)){
      clickable = false;
      _selectedOperator = _billVendorList?.first;
      _connectionTypeList = <ConnectionTypes>[];
      _connectionTypeList.add(ConnectionTypes(id: 0,name: "Connection Type"));
      showSnackBar('Please enter a valid mobile number. Thank you.');
    }
    if (simType == 0) {
      clickable = false;
    }
    if (amountString.isEmpty) {
      clickable = false;
      newEnable = false;
    }
    if (amountString.isNotEmpty) {
      var amount = double.parse(amountString);
      if(_selectedSimType.name=='Prepaid') {
        if (amount < 20 || amount > 1000) {
          clickable = false;
          newEnable = false;
        }
      }
      if(_selectedSimType.name=='PostPaid') {
        if (amount < 20 || amount > 2000) {
          clickable = false;
          newEnable = false;
        }
      }
    }

    if(_selectedAccount.id==-100){
      if(remarks.isEmpty) clickable = false;
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
         // _nodeText2.unfocus();
          _nodeText3.unfocus();
          _nodeText4.unfocus();
        });
      }
    }
  }

  Future<bool> showConfirmation(String phone,double amount,int mobileOperator,int simType, double feeAmount,double vatAmount,String purpose,String cvv,bool isOtpRequired) async{
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MobileRechargeConfirmationPage(
          phone,
          amount,
          mobileOperator,
          simType,
          feeAmount,
          vatAmount,
          AccountSelector("From", _selectedAccount, isEnabled: false),
          AccountSelector(
              "To",
              LinkedAccountViewModel(
                  accountNumberMasked: _phoneController.text,
                  accountHolderName: _contactName ?? _selectedOperator.name,
                  instituteName: _selectedOperator.name),
              isEnabled: false), _selectedAccount,purpose,_contactName,_selectedOperator.name,cvv,isOtpRequired);
    }));
    _transaction = result!=null? result : null ;
    if(_transaction.transactionStatus != 'Declined'){
      NavigatorUtils.goBack(context);
    }else{
      _phoneController.text = '';
      _amountController.text = '';
      _purposeController.text = '';
      _cvvController.text = '';
      _selectedOperator.id = 0;
      _selectedSimType.id = 0;
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

  onOperatorChange(BillVendorViewModel operator) {
    if(mounted) {
      setState(() {
        _isOperatorChangedByUser = true;
        _selectedOperator = operator;
        if (_selectedOperator.id != 0) {
          _connectionTypeList = operator.connectionTypes;
          _selectedSimType = _connectionTypeList.first;
        } else {
          _connectionTypeList = <ConnectionTypes>[];
          _connectionTypeList.add(
              ConnectionTypes(id: 0, name: "Connection Type"));
          _selectedSimType = _connectionTypeList.first;
        }
      });
    }
  }

  onSimTypeChange(ConnectionTypes simType) {
    if(mounted) {
      setState(() {
        _selectedSimType = simType;
      });
    }
  }

  @override
  MobileRechargePresenter createPresenter() => MobileRechargePresenter();

  @override
  bool get wantKeepAlive => true;

  Future<bool> _pickContacts() async {
    final result = await NavigatorUtils.pushAwait(context, DashboardRouter.contactSelectPage);
    CustomContact _customContact = result;
    _contactName = _customContact.name;
    _phoneController.text = _customContact != null ? HelperUtils.getPhoneNumberOnly(_customContact.phone):"";
    if(_phoneController.text!=""){
      var _mobileOperator = _billVendorList[HelperUtils.defineOperatorFrom(_phoneController.text)];
      if(mounted) {
        setState(() {
          if (_mobileOperator != _selectedOperator) {
            _selectedOperator = _mobileOperator;
            onOperatorChange(_mobileOperator);
          }
        });
      }
      _nodeText1.requestFocus();
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

  @override
  void setVendorList(List<BillVendorViewModel> vendorList) {
    if(mounted) {
      setState(() {
        _billVendorList.addAll(vendorList);
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

  Future<bool> _showProminantAlert(){
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: 'Agree',
            cancelText: 'Decline',
            title:'Privacy Alert',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Qpay Bangladesh  collects and store your contacts data to enable mobile recharge easy when the app in use.', textAlign: TextAlign.center,),
            ),
            onBackPressed:() {
              NavigatorUtils.goBack(context);
            },
            onPressed: (){
              NavigatorUtils.goBack(context);
              _pickContacts();
            },
          );
        });
  }
}
