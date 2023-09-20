
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';

import '../../providers/account_selection_listener.dart';
import '../../widgets/bank_selector_widget.dart';
import '../../widgets/my_dialog.dart';
import '../add_account/bank_list_selector_page.dart';
import 'link_beneficiary_account_iview.dart';
import 'link_beneficiary_account_presenter.dart';

class AddBeneficiaryAccountPage extends StatefulWidget {
  @override
  _AddBeneficiaryAccountPageState createState() => _AddBeneficiaryAccountPageState();
}

class _AddBeneficiaryAccountPageState extends State<AddBeneficiaryAccountPage>
    with
        BasePageMixin<AddBeneficiaryAccountPage, LinkBeneficiaryAccountPresenter>,
        AutomaticKeepAliveClientMixin<AddBeneficiaryAccountPage>
    implements LinkBeneficiaryAccountIMvpView {
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _shortNameController = TextEditingController();
  bool _clickable = false;
  bool _beneficiaryEnabled = false;
  bool _shortNameEnabled = false;
  List<BankViewModel> _bankList = <BankViewModel>[];
  String _value = "select";
  String lastLoadedBeneficiaryNumber='';
  String _proofToken;
  BankViewModel _selectedBank;
  var bankSelectionListener = BankListSelectionListener();
  var _dropdownTypeItems = <DropdownMenuItem<String>>[
  new DropdownMenuItem(
    child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
            ),
            Text('Select Beneficiary Type',style: TextStyles.textSize16,),
          ],)),
    value: "select",
  ),
    DropdownMenuItem(
  child: Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 10.0,
              backgroundColor: Colors.transparent,
              child: LoadAssetImage(
                'dashboard/add_account'
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
            ),
            Text('Account',style: TextStyles.textSize16,),
          ],)),
  value: "account",
  ), DropdownMenuItem(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 10.0,
                backgroundColor: Colors.transparent,
                child: LoadAssetImage(
                    'dashboard/card_bill_payment'
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Text('Card',style: TextStyles.textSize16,),
            ],)),
      value: "card",
    ),
     DropdownMenuItem(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 10.0,
                backgroundColor: Colors.transparent,
                child: LoadAssetImage(
                    'dashboard/mobile_recharge'
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Text('MFS',style: TextStyles.textSize16,),
            ],)),
      value: "wallet",
    ),
  ];


  @override
  void initState() {
    super.initState();
    _nameController.addListener(_verify);
    _accountController.addListener(_verify);
    _shortNameController.addListener(_verify);
    bankSelectionListener.addListener(_onBankSelected);
  }

  List<DropdownMenuItem<BankViewModel>> buildDropdownMenuItems(List banks) {
    List<DropdownMenuItem<BankViewModel>> items = [];
    for (BankViewModel bank in banks) {
      items.add(
        DropdownMenuItem(
          value: bank,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: ImageUtils.getImageProvider(
                    bank.imageUrl,
                  ),
                  onBackgroundImageError: (dynamic, stacktrace) {},
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Text(
                  bank.name,
                  style: TextStyles.textSize16,
                )
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  @override
  void dispose() {
    _accountController.removeListener(_verify);
    _accountController.dispose();
    _nodeText1.dispose();
    _nameController.removeListener(_verify);
    _nameController.dispose();
    _nodeText2.dispose();
    _shortNameController.removeListener(_verify);
    _shortNameController.dispose();
    _nodeText3.dispose();
    bankSelectionListener.removeListener(_onBankSelected);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).addBeneficiary,
        ),
        body: MyScrollView(
          keyboardConfig:
              Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1,_nodeText2,_nodeText3]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        height: 48.0,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
              color: Colours.text_gray,
              width: 1,
            ),
            color: Colors.white),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            items: _dropdownTypeItems,
            value: _value,
            onChanged: (String value) {
              if(mounted) {
                setState(() {
                  _value = value;
                  presenter.getProvider(
                      _value == 'account' ? 'bank' : _value == 'card'
                          ? 'bank'
                          : 'wallet');
                  _nameController.text = '';
                  _shortNameController.text = '';
                  _accountController.text = '';
                  _selectedBank = null;
                });
              }
            },
          ),
        ),
      ),

      Gaps.vGap4,
      Gaps.line,
      /*Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        height: 48.0,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
              color: Colours.text_gray,
              width: 1,
            ),
            color: Colors.white),
        child: DropdownButtonHideUnderline(
          child: AbsorbPointer(
            absorbing: _value!='select'?false:true,
            child: DropdownButton(
              isExpanded: true,
              items: buildDropdownMenuItems(_dropdownMenuItems),
              value: _currentSelectedItem,
              onChanged: (value) {
                setState(() {
                  _currentSelectedItem = value;
                });
              },
            ),
          ),
        ),
      ),*/
      AbsorbPointer(
        absorbing: _value!='select'?false:true,
        child: GestureDetector(
            child: BankSelector(_selectedBank),
            onTap: () {
              _selectBank();
            }),
      ),
      Gaps.line,
      Gaps.vGap8,
      MyTextField(
        iconName: _value=='account'?'bank': _value=='card'?'card':_value=='wallet'?'phone':'bank',
        focusNode: _nodeText1,
        controller: _accountController,
        keyboardType: TextInputType.number,
        inputFormatterList:_value=='account'?[
          FilteringTextInputFormatter.digitsOnly,
          new LengthLimitingTextInputFormatter(19),
          AccountNumberInputFormatter(),
        ] : _value=='card'? [
          FilteringTextInputFormatter.digitsOnly,
          new LengthLimitingTextInputFormatter(19),
          CardNumberInputFormatter(),
        ]:_value=='wallet'?[
          FilteringTextInputFormatter.digitsOnly,
          new LengthLimitingTextInputFormatter(11),
        ]:[
          FilteringTextInputFormatter.digitsOnly,
          new LengthLimitingTextInputFormatter(19),
          AccountNumberInputFormatter(),
        ],
        showCursor: _nodeText1.hasFocus?true:false,
        hintText:_value=='account'? AppLocalizations.of(context).inputBankAccountNumberHint :_value=='card'?AppLocalizations.of(context).inputCardNumberHint:_value=='wallet'?AppLocalizations.of(context).inputWalletAccountHint:AppLocalizations.of(context).inputBankAccountNumberHint,
        labelText: _value=='account'? AppLocalizations.of(context).inputBankAccountNumberLabel :_value=='card'?AppLocalizations.of(context).inputCardNumberLabel:_value=='wallet'?AppLocalizations.of(context).inputWalletAccountLabel:AppLocalizations.of(context).inputBankAccountNumberLabel,
        enabled: _selectedBank != null,
        textInputAction: TextInputAction.next,
      ),
      Gaps.line,
      Gaps.vGap8,
      Visibility(
        visible: _value=='wallet'?false:true,
        child: Column(
          children: [
            MyTextField(
              iconName: 'name',
              focusNode: _nodeText2,
              controller: _nameController,
              maxLength: 50,
              keyboardType: TextInputType.text,
              showCursor: _nodeText2.hasFocus?true:false,
              hintText: AppLocalizations.of(context).inputBeneficiaryName,
              labelText: AppLocalizations.of(context).inputBeneficiaryName,
              enabled: _beneficiaryEnabled,
              textInputAction: TextInputAction.done,
            ),
            Gaps.line,
            Gaps.vGap8,
          ],
        ),
      ),

      Visibility(
        visible: _value=='wallet'?true:false,
        child: MyTextField(
          iconName: 'name',
          focusNode: _nodeText3,
          controller: _shortNameController,
          maxLength: 50,
          keyboardType: TextInputType.text,
          showCursor: _nodeText3.hasFocus?true:false,
          hintText: AppLocalizations.of(context).inputShortName,
          labelText: AppLocalizations.of(context).inputShortName,
          enabled: _shortNameEnabled,
          textInputAction: TextInputAction.done,
        ),
      ),
      Gaps.vGap24,
      MyButton(
        onPressed: _clickable ? _addBeneficiaryAccount : null,
        text: AppLocalizations.of(context).confirm,
      )
    ];
  }

  bool _isEnabled(){
    if(_value!='wallet'){
      return _accountController.text.isNotEmpty;
    }else {return false;}
  }

  void _getBkashBeneficiary(String phoneNumber) async{
    if(lastLoadedBeneficiaryNumber == phoneNumber){
      return;
    }
    lastLoadedBeneficiaryNumber = phoneNumber;
    var response = await presenter.getBkashBeneficiary(phoneNumber);
    if (response != null){
      _nameController.text = response.name??AppLocalizations.of(context).notAvailable;
      _proofToken = response.proofToken??'';
      _nameController.removeListener(_verify);
      _shortNameController.addListener(_verify);
    }
  }

  void _addBeneficiaryAccount() async {
    var accountNumber = CardUtils.getCleanedNumber(_accountController.text);
    var beneficiaryName = _value=='wallet'?_shortNameController.text:_nameController.text;
    var bankId = _selectedBank.id;
    var type = _value;
    var proofToken = _proofToken??null;
    var response = await presenter.beneficiaryAccountOrCard(accountNumber,bankId, beneficiaryName,type,proofToken);
    if (response != null) {
      response.isSuccess? _showAlert('Congratulation',"Beneficiary added successfully",response):_showAlert('Sorry','Beneficiary add failed!',response);
    }
  }

  Future<bool> _showAlert(String title,String message,ApiBasicViewModel basicViewModel){
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: 'Okay',
            cancelText: '',
            title:title,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(message, textAlign: TextAlign.center,),
            ),
            onPressed: (){
              NavigatorUtils.goBack(context);
              NavigatorUtils.goBackWithParams(context,basicViewModel);

            },
          );});
  }
  void _selectBank() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height*.9,
            child: BankListSelectorPage(_bankList)));
  }

  @override
  LinkBeneficiaryAccountPresenter createPresenter() {
    return LinkBeneficiaryAccountPresenter();
  }

  @override
  void setBankAccounts(List<BankViewModel> bankList) {
    if(mounted){
      setState(() {
        if(_value == 'account'){
          _bankList = bankList.where((element) => element.allowAccount.addBeneficiaryAllow).toList();
        }
        if(_value == 'card'){
          _bankList = bankList.where((element) => element.allowCard.addBeneficiaryAllow).toList();
        }
        if(_value == 'wallet'){
          _bankList = bankList;
        }
      });
    }
  }

  void _verify() {
    var accountNumber = CardUtils.getCleanedNumber(_accountController.text);
    var beneficiaryName = _nameController.text;
    var shortName = _shortNameController.text;
    var clickable = true;
    var beneficiaryEnabled = false;
    var shortNameEnable = false;

    if(beneficiaryName.isEmpty || beneficiaryName == null){
      clickable = false;
    }
    if (accountNumber.isEmpty ||
        accountNumber == null) {
      clickable = false;
    }
    if(_value != 'wallet' && accountNumber.isNotEmpty){
      beneficiaryEnabled = true;
    }


    if(_value == 'wallet' && beneficiaryName.isNotEmpty){
      shortNameEnable = true;
    }

    if(_value == 'cards'){
      if(_accountController.text.length>15){
        clickable = false;
      }
    }
    if(_value == 'wallet' && _selectedBank.code == 'BKSH' && accountNumber.length == 11){
      _getBkashBeneficiary(accountNumber);
    }
    if(_value == 'wallet' && _selectedBank.code == 'BKSH'){
      if(shortName.isEmpty || shortName == null){
        clickable = false;
      }
    }
    if (mounted && clickable != _clickable) {
      setState(() {
        _clickable = clickable;
        // _nodeText1.unfocus();
        // _nodeText2.unfocus();
        // _nodeText3.unfocus();
      });
    }
    if (mounted && beneficiaryEnabled != _beneficiaryEnabled) {
      setState(() {
        _beneficiaryEnabled = beneficiaryEnabled;
      });
    }

    if (mounted && shortNameEnable != _shortNameEnabled) {
      setState(() {
        _shortNameEnabled = shortNameEnable;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  String getAccountBeneficiaryType() {
    return _value=='account'?'bank':_value=='card'?'card':'wallet';
  }

  void _onBankSelected() {
    var bank = bankSelectionListener.selectedBank;
    if (mounted && bank != null) {
      setState(() {
        _selectedBank = bank;
        _verify();
      });
    }
  }
}
