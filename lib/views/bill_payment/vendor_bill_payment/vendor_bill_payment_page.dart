import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/bill_inquiry_response_vm.dart';
import 'package:qpay/net/contract/bill_vendor_params_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_confirmation_page.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_iview.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_otp_page.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_presenter.dart';
import 'package:qpay/views/home/accounts/card_selector_page.dart';
import 'package:qpay/widgets/account_selector.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';
import 'package:qpay/widgets/transaction_account_selector.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';
import 'package:qpay/views/shared/bill_receipt_page.dart';

import '../../shared/webview_gateway_page.dart';

class VendorBillPaymentPage extends StatefulWidget {
  final BillInquiryResponseViewModel _billInquiryResponseViewModel;
  final BillVendorViewModel _billVendorViewModel;
  final BillVendorParamsViewModel _billVendorParamsViewModel;
  final String _accountNo;
  final String _dateTime;
  final bool _isOtpRequired;
  VendorBillPaymentPage(
      this._billInquiryResponseViewModel,
      this._billVendorViewModel,
      this._billVendorParamsViewModel,
      this._accountNo,
      this._dateTime,
      this._isOtpRequired);

  @override
  _VendorBillPaymentPageState createState() => _VendorBillPaymentPageState(
      _billInquiryResponseViewModel,
      _billVendorViewModel,
      _billVendorParamsViewModel,
      _accountNo,
      _dateTime,
      _isOtpRequired);
}

class _VendorBillPaymentPageState extends State<VendorBillPaymentPage>
    with
        BasePageMixin<VendorBillPaymentPage, VendorBillPaymentPresenter>,
        AutomaticKeepAliveClientMixin<VendorBillPaymentPage>
    implements VendorBillPaymentIMvpView {
  final BillInquiryResponseViewModel billInquiryResponseViewModel;
  final BillVendorViewModel billVendorViewModel;
  final BillVendorParamsViewModel billVendorParamsViewModel;
  final String accountNo;
  final String dateTime;
  final bool isOtpRequired;
  _VendorBillPaymentPageState(
      this.billInquiryResponseViewModel,
      this.billVendorViewModel,
      this.billVendorParamsViewModel,
      this.accountNo,
      this.dateTime,
      this.isOtpRequired);

  var accountSelectionListener = TransactionAccountSelectionListener();
  LinkedAccountViewModel _selectedAccount;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _clickable = false;
  TransactionViewModel _transaction;
  TransactionViewModel _pgTransaction;
  List<TransactionCategoryViewModel> _categoiesList =
      <TransactionCategoryViewModel>[];
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];

  @override
  void initState() {
    super.initState();
    _purposeController.addListener(_verify);
    _cvvController.addListener(_verify);
    accountSelectionListener.addListener(_onAccountSelected);
  }

  @override
  void dispose() {
    accountSelectionListener.removeListener(_onAccountSelected);
    _purposeController.removeListener(_verify);
    _purposeController.dispose();
    _cvvController.removeListener(_verify);
    _cvvController.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    accountSelectionListener.clear();
    super.dispose();
  }

  void _verify() {
    bool clickable = true;
    final String cvvString = _cvvController.text;

    if(_selectedAccount != null && _selectedAccount.productType == 'DebitCard') {
      if (cvvString.isEmpty) {
        clickable = false;
      }
      if (cvvString.length<3) {
        clickable = false;
      }
    }
    if (mounted && clickable != _clickable) {
      setState(() {
        _clickable = clickable;
        _nodeText1.unfocus();
        _nodeText2.unfocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).billPayment,
        ),
        body: MyScrollView(
          keyboardConfig:
              Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1,_nodeText2]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() => [
        Center(
            child: Image(
          image: NetworkImage(
              billVendorViewModel?.imageUrl ??
                  'https://img.icons8.com/ios-filled/50/000000/electricity.png',
              scale: 5),
        )),
        GestureDetector(
          child: AccountSelector(
            "Pay from",
            _selectedAccount,
            isSource: true,
          ),
          onTap: _selectAccount,
        ),
        Gaps.line,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gaps.vGap8,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => {availableBalace(_selectedAccount.id)},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      AppLocalizations.of(context).availBalance,
                      style: TextStyle(
                        fontSize: Dimens.font_sp14,
                        color: Colours.app_main,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Visibility(
          visible:
          _selectedAccount != null && _selectedAccount.productType == 'DebitCard',
          child: Column(
            children: [
              Gaps.vGap8,
              MyTextField(
                key: const Key('cvv'),
                iconName: 'cvv',
                focusNode: _nodeText2,
                controller: _cvvController,
                maxLength: 3,
                isInputPwd: true,
                showCursor: _nodeText2.hasFocus?true:false,
                keyboardType: TextInputType.number,
                hintText: AppLocalizations.of(context).inputCVV,
                labelText: AppLocalizations.of(context).inputCVV,
                enabled: _selectedAccount != null,
              ),
            ],
          ),
        ),
        Gaps.vGap16,
        MyTextField(
          key: const Key('purpose'),
          iconName: 'purpose',
          focusNode: _nodeText1,
          controller: _purposeController,
          maxLength: 50,
          keyboardType: TextInputType.text,
          showCursor: _nodeText1.hasFocus?true:false,
          hintText: AppLocalizations.of(context).inputPurpose,
          labelText: AppLocalizations.of(context).inputPurpose,
          enabled:  _selectedAccount != null,
        ),
        Gaps.vGap24,
        MyButton(
          key: const Key('confirm'),
          onPressed: _clickable ? _next : null,
          text:_selectedAccount!=null && _selectedAccount.id ==-100?AppLocalizations.of(context).submit:isOtpRequired? AppLocalizations.of(context).getVCode:AppLocalizations.of(context).submit,
        ),
      ];

  void availableBalace(int accountId) async {
    var balanceResponse = await presenter.accountBalance(accountId);
    if (balanceResponse != null) {
      showBalanceDialoge(balanceResponse);
    }
  }

  void _next() async {
    final double amount = billInquiryResponseViewModel.totalBillAmount;
    final int billedId = billVendorViewModel?.id ?? 0;
    final int connectionId = billVendorParamsViewModel.connectionId;
    final int debitAccountId = _selectedAccount.id;
    final String purpose = _purposeController.text;
    final String cvv = _cvvController.text;
    final String referenceId = billInquiryResponseViewModel.referenceId;
    final String subscriberAccountNumber = accountNo;
    var billResponse = await presenter.billPayment(
        amount,
        billedId,
        connectionId,
        debitAccountId,
        referenceId,
        subscriberAccountNumber,
        purpose,cvv);
    if (billResponse != null) {
      _transaction = billResponse;
      if (_transaction != null) {
        if (_transaction.isRedirectAllow) {
          var result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) {
            return WebViewGatewayPage(AppLocalizations
                .of(context)
                .billPayment, _transaction.redirectUrl);
          }));
          _pgTransaction = result;
          if (_pgTransaction != null) {
            if (_pgTransaction.transactionStatus != 'Declined') {
              _onSuccess(_pgTransaction);
            } else {
              _onFailed(_pgTransaction);
            }
          }
        }
        else {
          if (isOtpRequired) {
            _showPinDialog(_transaction);
          } else {
            if (_transaction.transactionStatus != 'Declined') {
              _onSuccess(_transaction);
            } else {
              _onFailed(_transaction);
            }
          }
        }
      }
    }
  }

  Future<bool> _showPinDialog(TransactionViewModel transaction) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorBillPaymentOtpPage(
          transaction, TransactionAmountDescriptionWidget(transaction));
    }));
    _transaction = result != null ? result : null;
    if (_transaction != null) {
      if (_transaction.transactionStatus != 'Declined') {
        _onSuccess(_transaction);
      } else {
        NavigatorUtils.goBackWithParams(context,_transaction);
      }
    }
  }

  void _showSuccessDialog(TransactionViewModel transaction) {
    var future = showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (_) => BillReceiptPage(
        _transaction,
        billVendorViewModel,
        accountNo,
        dateTime,
        TransactionAccountSelector('From', _selectedAccount, isEnabled: false),
      ),
    );
    future
        .then((value) => NavigatorUtils.goBackWithParams(context, transaction));
  }

  void _onSuccess(TransactionViewModel transaction) {
    _showSuccessDialog(transaction);
  }

  void _onFailed(TransactionViewModel transaction) {
    _showFailedDialog(transaction);
  }

  void _showFailedDialog(TransactionViewModel transaction) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: "",
            title: transaction.transactionStatus,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(transaction.transactionDetails,
                  textAlign: TextAlign.center),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
              NavigatorUtils.goBackWithParams(context,_transaction);
            },
          );
        });
  }

  void _selectAccount() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: false,
        builder: (_) => CardsSelectorPage(Constant.transactionAccountSelector));
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
  VendorBillPaymentPresenter createPresenter() => VendorBillPaymentPresenter();

  @override
  bool get wantKeepAlive => true;

  @override
  void setTransactionsCategory(
      List<TransactionCategoryViewModel> transactionCategoryViewModel) {
    if(mounted) {
      setState(() {
        _categoiesList = transactionCategoryViewModel;
      });
    }
  }

  @override
  void setVendorParams(BillVendorParamsViewModel billVendorParamsViewModel) {
    // TODO: implement setVendorParams
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
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gaps.vGap8,
                          Text(
                            "Available Balance:",
                            style: TextStyle(
                                color: Colours.text_gray,
                                fontSize: 12.0,
                                fontFamily: 'SF'),
                          ),
                          Gaps.vGap8,
                          Text(
                            balanceResponse[index].currency +
                                " " +
                                balanceResponse[index].balance,
                            style: TextStyle(
                                color: Colours.textBlueColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF'),
                          ),
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
