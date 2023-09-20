import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_linked_vm.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/net/contract/cardType_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/providers/dashboard_provider.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/dashboard_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/add_account/link_account_presenter.dart';
import 'package:qpay/views/home/accounts/bank_account_selector_page.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/bank_selector_widget.dart';
import 'package:qpay/widgets/card_background_widget.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/pin_input_dialog.dart';
import 'package:qpay/widgets/text_field.dart';

import '../../widgets/my_dialog.dart';
import 'add_card_otp_page.dart';
import 'bank_list_selector_page.dart';
import 'link_account_iview.dart';

class AddCardPage extends StatefulWidget {
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage>
    with
        BasePageMixin<AddCardPage, LinkAccountPresenter>,
        AutomaticKeepAliveClientMixin<AddCardPage>
    implements LinkAccountIMvpView {
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expireMonthAndYearController = TextEditingController();
  final provider = DashboardProvider();
  bool _clickable = false;
  Widget _cardIcon = CardUtils.getCardIcon(CardType.Others);
  List<BankViewModel> _bankList = <BankViewModel>[];
  AccountLinkedViewModel _accountLinkResponse;
  ApiBasicViewModel apiBasicResponse;
  BankViewModel _selectedBank;
  var bankSelectionListener = BankListSelectionListener();

  @override
  void initState() {
    super.initState();
    _cardController.addListener(_verify);
    _cardController.addListener(_cardInputListener);
    _expireMonthAndYearController.addListener(_verify);
    bankSelectionListener.addListener(_onBankSelected);
  }


  @override
  void dispose() {
    _cardController.removeListener(_verify);
    _expireMonthAndYearController.removeListener(_verify);
    _cardController.dispose();
    _expireMonthAndYearController.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    bankSelectionListener.removeListener(_onBankSelected);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).addCard,
        ),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1, _nodeText2]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 20.0),
          children: _buildBody(),
        ),
        ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Gaps.line,
      Transform.scale(
        scale: .95,
        child: CardBackgroudView(
            context: context,
            cardType: CardUtils.getCardTypeFrmNumber(
                _cardController.text??""),
            cardIssuedBankImage: "",
            cardIssuedBank:_selectedBank!= null?_selectedBank.name:"",
            cardNumber: _cardController.text ??"",
            cardHolder: provider.user.name ??"",
            cardExpiration: _expireMonthAndYearController.text.split('/').first+"/"+_expireMonthAndYearController.text.split('/').last ??""),
      ),
      Gaps.vGap4,
      Gaps.line,
      Gaps.vGap8,
      GestureDetector(
          child: BankSelector(_selectedBank),
          onTap: () {
            _selectBank();
          }),
      Gaps.line,
      Gaps.vGap8,
      MyTextField(
        iconName:'card',
        focusNode: _nodeText1,
        controller: _cardController,
        inputFormatterList: [
          FilteringTextInputFormatter.digitsOnly,
          new LengthLimitingTextInputFormatter(19),
          CardNumberInputFormatter(),
        ],
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        showCursor: _nodeText1.hasFocus?true:false,
        hintText: AppLocalizations.of(context).inputCardNumberHint,
        labelText: AppLocalizations.of(context).inputCardNumberLabel,
        enabled: _selectedBank != null,
      ),
      Gaps.vGap8,
      MyTextField(
        iconName: 'date',
        focusNode: _nodeText2,
        controller: _expireMonthAndYearController,
        maxLength: 5,
        showCursor: _nodeText2.hasFocus?true:false,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        hintText: AppLocalizations.of(context).inputExpireFormatDate,
        labelText: AppLocalizations.of(context).inputExpireDateHint,
        inputFormatterList: [
          ExpiryDateInputFormatter()
        ],
        enabled: _cardController.text.isNotEmpty,
      ),
      Gaps.vGap24,
      MyButton(
        onPressed: _clickable ? _linkCard : null,
        text: AppLocalizations.of(context).confirm,
      )
    ];
  }

  void _linkCard() async {
    var cardNumber = CardUtils.getCleanedNumber(_cardController.text);
    final expireMonth = int.parse(_expireMonthAndYearController.text.split('/').first);
    final expireYear = int.parse(_expireMonthAndYearController.text.split('/').last);
    var response =
        await presenter.linkCard(cardNumber, expireMonth, expireYear);
    if (response != null) {
      _accountLinkResponse = response;
      _showPinDialog(response);
    }
  }

  void _cardInputListener(){
    final cardNumber = CardUtils.getCleanedNumber(_cardController.text);
    final expireMonth = _expireMonthAndYearController.text.split('/').first;
    final expireYear = _expireMonthAndYearController.text.split('/').last;
  }
  void _verify() {
    final cardNumber = CardUtils.getCleanedNumber(_cardController.text);
    final expireMonth = _expireMonthAndYearController.text.split('/').first;
    final expireYear = _expireMonthAndYearController.text.split('/').last;
    var clickable = true;
    if(_selectedBank.id == null) clickable = false;
    if (cardNumber.isEmpty ||
        cardNumber == null) {
      clickable = false;
    } /*else {
      if (!CardUtils.isValidCardNumber(cardNumber)) {
        clickable = false;
      }
    }*/
    if(cardNumber.length<15){
       clickable = false;
    }

    if (expireMonth.isEmpty || expireMonth.length > 2) {
      clickable = false;
    } else {
      var month = int.parse(_expireMonthAndYearController.text.split('/').first);
      if (month < 1 || month > 12) {
        clickable = false;
      }
    }

    if (expireYear.isEmpty || expireYear.length > 2) {
      clickable = false;
    }

    if (expireMonth.isNotEmpty && expireYear.isNotEmpty) {
      var month = int.parse(_expireMonthAndYearController.text.split('/').first);
      final century = "20";
      var year = int.parse(century + _expireMonthAndYearController.text.split('/').last);
      if (!CardUtils.isValidDate(month, year)) {
        clickable = false;
      }
    }

    var cardType = CardUtils.getCardTypeFrmNumber(cardNumber);

      var cardIcon = CardUtils.getCardIcon(cardType);
      if(mounted){
        setState(() {
          _cardIcon = cardIcon;
        });

        if (clickable != _clickable) {
          setState(() {
            _clickable = clickable;

          });
        }
      }
  }


  Future<bool> _showPinDialog(AccountLinkedViewModel linkResponse) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCardOTPPage(linkResponse);
    }));
    apiBasicResponse = result!= null?result:null;
    if(apiBasicResponse != null){
      apiBasicResponse.isSuccess? _showAlert('Congratulations','Card linked Successfully.'):_showAlert('Sorry','Card linked failed!');

    }
  }

  Future<bool> _showAlert(String title,String message){
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
              NavigatorUtils.goBack(context);
            },
          );
        });
  }

  void _onSuccess(String message) {
    showSuccessDialog(message);
    NavigatorUtils.goBack(context);
  }
  @override
  LinkAccountPresenter createPresenter() {
    return LinkAccountPresenter();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  String getAccountLinkType() => "bank";

  @override
  void setBankList(List<BankViewModel> bankList) {
    if(mounted) {
      setState(() {
        _bankList = bankList.where((element) => element.allowCard.addLinkAllow).toList();
      });
    }
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
