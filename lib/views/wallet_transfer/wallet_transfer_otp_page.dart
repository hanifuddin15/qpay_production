import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_linked_vm.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/fund_transfer/fund_transfer_iview.dart';
import 'package:qpay/views/shared/transaction_complete_page.dart';
import 'package:qpay/views/wallet_transfer/wallet_transfer_iview.dart';
import 'package:qpay/views/wallet_transfer/wallet_transfer_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';


class WalletTransferOtpPage extends StatefulWidget{
  final TransactionViewModel _transaction;
  final TransactionAmountDescriptionWidget header;
  WalletTransferOtpPage(this._transaction,this.header);

  @override
  _WalletTransferOtpPageState createState() => _WalletTransferOtpPageState(_transaction,header);
}

class _WalletTransferOtpPageState extends State<WalletTransferOtpPage>
    with
        BasePageMixin<WalletTransferOtpPage, WalletTransferPresenter>,
        AutomaticKeepAliveClientMixin<WalletTransferOtpPage>
    implements WalletTransferIMvpView{
  TransactionViewModel _transaction;
  TransactionAmountDescriptionWidget header;
  _WalletTransferOtpPageState(this._transaction,this.header);
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
          centerTitle: AppLocalizations.of(context).walletTransfer,
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
                          AppLocalizations.of(context).insertOtp,
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
            widget.header ?? Container(),
            Gaps.vGap16,
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
    await presenter.confirmTransaction(_transaction.transactionId, pin);

    _transaction = response;
    if (_transaction != null) {
      if (_transaction.transactionStatus == 'Declined') {
        _pinPutController.text = '';
        _pinPutFocusNode.requestFocus();
        _showErrorDialog(_transaction);
      } else {
        _onSuccess(_transaction);
      }
    } else{
      _pinPutController.text = '';
      _pinPutFocusNode.requestFocus();
    }
  }
  void _onSuccess(TransactionViewModel transaction) {
    NavigatorUtils.goBackWithParams(context,transaction);
  }

  void _showErrorDialog(TransactionViewModel transaction) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: "",
            cancelText: AppLocalizations.of(context).tryAgain,
            title:transaction.transactionStatus,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(transaction.transactionDetails??AppLocalizations.of(context).notAvailable, textAlign: TextAlign.center,),
            ),
            onBackPressed:() {
              NavigatorUtils.goBack(context);
              NavigatorUtils.goBackWithParams(context,transaction);
            },
          );
        });
  }

  @override
  WalletTransferPresenter createPresenter() => WalletTransferPresenter();

  @override
  bool get wantKeepAlive => true;

  @override
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel) {
  }

}