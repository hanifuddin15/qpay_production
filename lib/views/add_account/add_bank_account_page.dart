
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/add_account/link_account_iview.dart';
import 'package:qpay/views/add_account/link_account_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';

class AddBankCardPage extends StatefulWidget {
  @override
  _AddBankCardPageState createState() => _AddBankCardPageState();
}

class _AddBankCardPageState extends State<AddBankCardPage>
    with
        BasePageMixin<AddBankCardPage, LinkAccountPresenter>,
        AutomaticKeepAliveClientMixin<AddBankCardPage>
    implements LinkAccountIMvpView {
  final FocusNode _nodeText1 = FocusNode();
  final TextEditingController _accountController = TextEditingController();
  bool _clickable = false;
  List<DropdownMenuItem<BankViewModel>> _dropdownMenuItems;
  BankViewModel _currentSelectedItem;

  @override
  void initState() {
    super.initState();
    _accountController.addListener(_verify);
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
                  radius: 12.0,
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
                  bank.name??AppLocalizations.of(context).notAvailable,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).addBankAccount,
        ),
        body: MyScrollView(
          keyboardConfig:
              Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Gaps.line,
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
            items: _dropdownMenuItems,
            value: _currentSelectedItem,
            onChanged: (value) {
              if(mounted) {
                setState(() {
                  _currentSelectedItem = value;
                });
              }
            },
          ),
        ),
      ),
      Gaps.vGap4,
      Gaps.line,
      Gaps.vGap8,
      MyTextField(
        iconName: 'bank',
        focusNode: _nodeText1,
        controller: _accountController,
        keyboardType: TextInputType.number,
        inputFormatterList: [
          FilteringTextInputFormatter.digitsOnly,
          new LengthLimitingTextInputFormatter(16),
          AccountNumberInputFormatter(),
        ],
        hintText: AppLocalizations.of(context).inputBankAccountNumberHint,
        labelText: AppLocalizations.of(context).inputBankAccountNumberLabel,
      ),
      Gaps.vGap24,
      MyButton(
        onPressed: _clickable ? _linkBank : null,
        text: AppLocalizations.of(context).confirm,
      )
    ];
  }

  void _linkBank() async {
   /* var accountNumber = CardUtils.getCleanedNumber(_accountController.text);
    var bankId = _currentSelectedItem.id;
    var response = await presenter.linkBankAccount(bankId, accountNumber);
    if (response != null) {
     showToast(response.message);
      NavigatorUtils.goBack(context);
    }*/
    showSnackBar("Not Implemented!");
  }

  @override
  LinkAccountPresenter createPresenter() {
    return LinkAccountPresenter();
  }

  @override
  String getAccountLinkType() {
    return "Bank";
  }

  @override
  void setBankList(List<BankViewModel> bankList) {
    if(mounted){
      setState(() {
        _currentSelectedItem = bankList[0];
        _dropdownMenuItems = buildDropdownMenuItems(bankList);
      });
    }
  }

  void _verify() {
    var accountNumber = CardUtils.getCleanedNumber(_accountController.text);
    var clickable = true;
    if (accountNumber.isEmpty ||
        accountNumber.length < 5 ||
        accountNumber.length > 16) {
      clickable = false;
    }
    if (mounted && clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
