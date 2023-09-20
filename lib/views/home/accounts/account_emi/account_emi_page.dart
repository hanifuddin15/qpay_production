import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:group_button/group_button.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/emi_and_tq_response_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/providers/emi_request_state_provider.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/routers.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/home/accounts/account_emi/account_emi_iview.dart';
import 'package:qpay/views/home/accounts/account_emi/account_emi_page_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/small_button.dart';

class AccountEmiPage extends StatefulWidget{
  @override
  _AccountEmiPageState createState() => _AccountEmiPageState();

}

class _AccountEmiPageState extends State<AccountEmiPage>
  with BasePageMixin<AccountEmiPage,AccountEMIPagePresenter>,
        AutomaticKeepAliveClientMixin<AccountEmiPage> implements
        AccountEMIIMvpView{
  LinkedAccountViewModel account = StatementAccountSelectionListener().selectedAccount;
  final emiRequestData = EmiRequestStateProvider();
  List<String> tenor = ["3", "6", "9", "12"];
  String numOfInstallment;
  bool _clickable = false;
  bool _isChecked = false;
  EmiAndTqResponseViewModel emiAndTqResponseViewModel;
  @override
  void initState() {
    super.initState();

    emiRequestData.addListener(_onDataGet);
  }

  @override
  void dispose() {
    emiRequestData.removeListener(_onDataGet);
    emiRequestData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          isBack: true,
          centerTitle: "Emi",
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: MyButton(
              key: const Key('submit'),
              onPressed: _isChecked ? _submit : null,
              text: AppLocalizations.of(context).submit,
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  void _submit() async{
    final String transId = emiRequestData.transactionId;
    final int cardId = account.id;
    final String amount = emiRequestData.amount;
    final String transCode = emiRequestData.transactionCode;
    final String approveCode = emiRequestData.approvalCode;
    final int numOfIns = int.parse(numOfInstallment!=null?numOfInstallment:tenor[0]);

    var response = await presenter.emiRequest(transId, cardId, amount, transCode, approveCode, numOfIns);
    if (response != null){
      emiAndTqResponseViewModel = response;
      if(emiAndTqResponseViewModel != null){
        _showSuccessDialog(emiAndTqResponseViewModel.responseMessage);
      }
    }

  }
  void _onDataGet(){
    _verify();
  }

  void _verify() {
    bool clickable = true;
   var numOfIns = numOfInstallment;
    if(_isChecked == false){
      clickable = false;
    }
    if(numOfIns == null){
      clickable = false;
    }
    if(clickable != _clickable){
      if(mounted) {
        setState(() {
          _clickable = clickable;
        });
      }
    }
  }
  Widget _buildBody(){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.accountHolderName,
                          style: TextStyle(
                              color: Colours.text,
                              fontSize: Dimens.font_sp16,
                              fontFamily: 'SF'),
                        ),
                        Gaps.vGap4,
                        Text(
                          account.accountNumberMasked,
                          style: TextStyle(
                              color: Colours.text_gray,
                              fontSize: Dimens.font_sp12,
                              fontFamily: 'SF'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                              height: 30.0,
                                width: 30.0,
                                child: CardUtils.getCardIcon(CardUtils.getCardTypeFrmNumber(account.accountNumberMasked.trim()))),
                    ),
                  ],
                ),
            ),
          ),
          Gaps.vGap8,
        Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.vGap8,
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Column(
                            children: [
                              Text(
                                emiRequestData.description,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colours.text,
                                    fontSize: Dimens.font_sp14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF'),
                              ),
                            ],
                          )),
                      Flexible(
                          child: Column(
                            children: [
                              Text(
                                    emiRequestData.amount,
                                softWrap: true,
                                style: TextStyle(
                                    color: (Colours.textBlueColor),
                                    fontSize: Dimens.font_sp14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF'),
                              ),
                            ],
                          )),
                    ]),
                Gaps.vGap8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      emiRequestData.transactionTime,
                      style:
                      TextStyle(color: Colours.text_gray, fontSize: Dimens.font_sp12,fontFamily: 'SF'),
                    ),
                    Text(
                      "Tnx ID: " + emiRequestData.transactionId,
                      style:
                      TextStyle(color: Colours.text_gray, fontSize: Dimens.font_sp12,fontFamily: 'SF'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
          Gaps.vGap8,
          Gaps.line,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You can avail EMI for 3,6,9 & 12 Months",
                  style: TextStyle(
                      color: Colours.text_gray,
                      fontSize: Dimens.font_sp12,fontFamily: 'SF'),
                ),
                Gaps.vGap8,
                GroupButton(
                  isRadio: true,
                  spacing: 10,
                  selectedButtons: [0],
                  onSelected: (index, isSelect) =>
                      numOfInstallment = tenor[index],
                  buttons: tenor,
                  borderRadius: BorderRadius.circular(5.0),
                  selectedColor: Colours.app_main,
                  selectedBorderColor: Colours.dark_red,
                ),
              ],
            ),
          ),
          Gaps.vGap8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Checkbox(value: _isChecked, onChanged: (bool value){
                if(mounted) {
                  setState(() {
                    _isChecked = value;
                  });
                }
              }),
              Flexible(child: Text("I/We acknowledge and accept the Terms and Conditions applicable and available.",style: TextStyle(fontFamily: 'SF'),))
            ],
          ),
        ],
      )
    );
  }

  @override
  AccountEMIPagePresenter createPresenter() {
    return AccountEMIPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;

  void _showSuccessDialog(String status) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).submit,
            cancelText: AppLocalizations.of(context).cancel,
            title: AppLocalizations.of(context).emiTxn,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("EMI REQUEST SUBMIT "+status,
                  textAlign: TextAlign.center),
            ),
            onPressed: () {
              NavigatorUtils.push(context, Routes.home,
                  replace: true, clearStack: true);
            },
            onBackPressed: (){
              NavigatorUtils.goBack(context);
            },
          );
        });
  }
}
