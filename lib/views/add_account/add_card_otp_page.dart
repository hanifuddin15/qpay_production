import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_linked_vm.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

import 'link_account_iview.dart';
import 'link_account_presenter.dart';

class AddCardOTPPage extends StatefulWidget{
  final AccountLinkedViewModel _accountLinkResponse;
   AddCardOTPPage(this._accountLinkResponse);

  @override
  _AddCardOTPPageState createState() => _AddCardOTPPageState(_accountLinkResponse);
}

class _AddCardOTPPageState extends State<AddCardOTPPage>
    with
        BasePageMixin<AddCardOTPPage, LinkAccountPresenter>,
        AutomaticKeepAliveClientMixin<AddCardOTPPage>
    implements LinkAccountIMvpView{
  AccountLinkedViewModel _accountLinkResponse;
  _AddCardOTPPageState(this._accountLinkResponse);
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colours.text),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(
            centerTitle: AppLocalizations.of(context).addCard,
          ),
          body:MyScrollView(
            children: _buildBody(),
      ),
      ),
    );
  }

  List<Widget> _buildBody() => <Widget>[
       Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage('assets/images/otp_icon.png'),
                            height:MediaQuery.of(context).size.height*.15,
                            width: MediaQuery.of(context).size.width*.2,
                          ),
                        ),
                        Gaps.vGap8,
                        Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Enter your OTP code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0,fontFamily: 'Inter'),
                        ),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
              Gaps.vGap8,
              Container(
                color: Colors.white,
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(20.0),
                child: PinPut(
                  fieldsCount: 6,
                  autofocus: true,
                  onSubmit: (String pin) => _onPinInserted(pin),
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colours.app_main.withOpacity(.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      )
    ];
  void _onPinInserted(String pin) async {
    if (pin == null || pin.isEmpty || pin.length < 6) {
      return;
    }
    var response =
    await presenter.confirmCardLink(_accountLinkResponse.trackingId, pin);

    if (response != null) {
      NavigatorUtils.goBackWithParams(context,response);
    }else{
      _pinPutController.text = '';
      _pinPutFocusNode.requestFocus();
    }
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
    if (mounted) {
      setState(() {});
    }
  }

}