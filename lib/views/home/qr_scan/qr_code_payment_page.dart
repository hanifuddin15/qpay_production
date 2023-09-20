import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/scanned_qr_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/static_data/transaction_type.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/views/home/accounts/card_selector_page.dart';
import 'package:qpay/views/home/qr_scan/qr_code_payment_confirmation_page.dart';
import 'package:qpay/views/home/qr_scan/qr_code_payment_otp_page.dart';
import 'package:qpay/views/home/qr_scan/scan_qr_code_iview.dart';
import 'package:qpay/views/home/qr_scan/scan_qr_code_page_presenter.dart';
import 'package:qpay/views/shared/transaction_complete_page.dart';
import 'package:qpay/widgets/account_selector.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/number_formatter_two_decimal.dart';
import 'package:qpay/widgets/text_field.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';
import 'package:qpay/widgets/pin_input_dialog.dart';
import 'package:screenshot/screenshot.dart';

class QrCodePaymentPage extends StatefulWidget {
  @override
  _QrCodePaymentPageState createState() => _QrCodePaymentPageState();
}

class _QrCodePaymentPageState extends State<QrCodePaymentPage>
    with
        WidgetsBindingObserver,
        BasePageMixin<QrCodePaymentPage, ScanQrCodePagePresenter>,
        AutomaticKeepAliveClientMixin<QrCodePaymentPage>
    implements ScanQrCodeIMvpView {
  CachedQrCode code = CachedQrCode();
  String qrData;
  var accountSelectionListener = TransactionAccountSelectionListener();
  LinkedAccountViewModel _debitAccount;
  String _selectIntent;
  bool _clickable = false;
  bool _newEnable = false;
  bool _cvvEnabled = false;
  var _isIssuerChangedByUser = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  TransactionViewModel _transaction;
  ScannedQrViewModel _scannedQrViewModel = ScannedQrViewModel();
  MerchantPansViewModel _merchantViewModel = MerchantPansViewModel();
  List<MerchantPansViewModel> merchants = <MerchantPansViewModel>[];
  List<TransactionCategoryViewModel> _categoiesList =
      <TransactionCategoryViewModel>[];
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];
  String feeAmount = '';
  String vatAmount = '';
  bool isOtpRequired = false;
  bool isAmountActive = false;
  bool isTipsEnable = false;
  bool isTipsFixed = false;
  bool tipsVisibility = false;
  String indicator = '';

  @override
  void initState() {
    super.initState();
    var storedQr = code.qrData;
    if (storedQr != null) {
      qrData = storedQr;
    }
    _amountController.addListener(_verify);
    _tipController.addListener(_verify);
    _purposeController.addListener(_verify);
    _cvvController.addListener(_verify);
    accountSelectionListener.addListener(_onAccountSelected);
  }

  @override
  void dispose() {
    code.clear();
    accountSelectionListener.removeListener(_onAccountSelected);
    _amountController.removeListener(_verify);
    _amountController.dispose();
    _tipController.removeListener(_verify);
    _tipController.dispose();
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
          isBack: true,
          centerTitle: AppLocalizations.of(context).qrPayment,
        ),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1, _nodeText2, _nodeText3]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() => [
        GestureDetector(
          child: AccountSelector(
            "Pay from",
            _debitAccount,
            isSource: true,
          ),
          onTap: () {
            _selectIntent = "debit";
            _selectSender();
          },
        ),
        Gaps.line,
        Visibility(
          visible:
              _debitAccount != null && _debitAccount.productType != 'DebitCard',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.vGap16,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => {availableBalace(_debitAccount.id)},
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
        ),
        Visibility(
          visible:
              _debitAccount != null && _debitAccount.productType == 'DebitCard',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.vGap16,
              MyTextField(
                key: const Key('cvv'),
                iconName: 'cvv',
                focusNode: _nodeText3,
                controller: _cvvController,
                maxLength: 3,
                isInputPwd: true,
                showCursor: _nodeText3.hasFocus?true:false,
                keyboardType: TextInputType.number,
                hintText: AppLocalizations.of(context).inputCVV,
                labelText: AppLocalizations.of(context).inputCVV,
                enabled: _debitAccount != null,
              ),
            ],
          ),
        ),
        Gaps.vGap16,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Text("Merchant:",style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp16,fontWeight: FontWeight.bold),),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(width: 1.3, color: Colours.text_gray),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/supermarket.png'),
                      fit: BoxFit.cover,
                    ),

                    // shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Gaps.hGap24,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _scannedQrViewModel?.retailerName ?? "",
                  style: TextStyle(
                      color: Colours.text,
                      fontSize: Dimens.font_sp18,
                      fontWeight: FontWeight.normal),
                ),
                Gaps.vGap4,
                Text(
                  _scannedQrViewModel?.terminalCity ?? "",
                  style: TextStyle(
                      color: Colours.text,
                      fontSize: Dimens.font_sp12,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        Gaps.vGap16,
        Visibility(
          visible: _merchantViewModel.pan != null,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 40,
                          child: CardUtils.getCardIcon(
                              CardUtils.getCardTypeFrmNumber(
                                  _merchantViewModel.pan ?? ''))),
                      Gaps.hGap16,
                      Text(_merchantViewModel.pan ?? '')
                    ],
                  ),
                ),
              )),
        ),
        Gaps.vGap16,
        MyTextField(
          key: const Key('amount'),
          iconName: 'amount',
          focusNode: _nodeText1,
          controller: _amountController,
          maxLength: 9,
          showCursor: _nodeText1.hasFocus?true:false,
          keyboardType: TextInputType.number,
          inputFormatterList: <TextInputFormatter>[
            NumberRemoveExtraDotFormatter(),
          ],
          hintText: 'Amount',
          labelText: 'Amount',
          enabled: _debitAccount != null
              ? (_debitAccount.productType == 'DebitCard'
                  ? (_cvvEnabled ? isAmountActive : false)
                  : isAmountActive)
              : false,
        ),
        Gaps.vGap16,
        Visibility(
          visible: tipsVisibility,
          child: MyTextField(
            key: const Key('tips'),
            iconName: 'amount',
            focusNode: _nodeText4,
            controller: _tipController,
            maxLength: 6,
            showCursor: _nodeText4.hasFocus?true:false,
            keyboardType: TextInputType.number,
            inputFormatterList: <TextInputFormatter>[
              NumberRemoveExtraDotFormatter(),
            ],
            hintText: isTipsEnable
                ? AppLocalizations.of(context).inputTips
                : AppLocalizations.of(context).inputConvenience,
            labelText: isTipsEnable
                ? AppLocalizations.of(context).inputTips
                : AppLocalizations.of(context).inputConvenience,
            enabled: isTipsEnable,
          ),
        ),
        Gaps.vGap16,
        MyTextField(
          key: const Key('total_amount'),
          iconName: 'amount',
          focusNode: _nodeText5,
          controller: _totalAmountController,
          maxLength: 9,
          showCursor: _nodeText5.hasFocus?true:false,
          keyboardType: TextInputType.number,
          inputFormatterList: <TextInputFormatter>[
            NumberRemoveExtraDotFormatter(),
          ],
          hintText: 'Total Amount',
          labelText: 'Total Amount',
          enabled: false,
        ),
        Gaps.vGap4,
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            AppLocalizations.of(context).qrCodePaymentAmountLimit,
            style:
                TextStyle(fontSize: Dimens.font_sp10, color: Colours.text_gray),
          ),
        ),
        Gaps.vGap8,
        MyTextField(
          key: const Key('purpose'),
          iconName: 'purpose',
          focusNode: _nodeText2,
          controller: _purposeController,
          maxLength: 50,
          showCursor: _nodeText2.hasFocus?true:false,
          keyboardType: TextInputType.text,
          hintText: AppLocalizations.of(context).inputPurpose,
          labelText: AppLocalizations.of(context).inputPurpose,
          enabled: _newEnable,
        ),
        Gaps.vGap24,
        MyButton(
          key: const Key('confirm'),
          onPressed: _clickable ? _next : null,
          text: AppLocalizations.of(context).submit,
        ),
      ];

  void availableBalace(int accountId) async {
    var balanceResponse = await presenter.accountBalance(accountId);
    if (balanceResponse != null) {
      showBalanceDialoge(balanceResponse);
    }
  }

  void _next() async {
    final double amount = double.parse(_amountController.text);
    final String purpose = _purposeController.text;
    final String cvv = _cvvController.text;
    final double tips = _tipController.text.contains('%')
        ? double.parse(_tipController.text.split(' ').first)
        : double.parse(_tipController.text);
    double tipsOrConveninece = 0.0;
    if(isTipsFixed && amount<tips){
      showSnackBar(
        'Tips or Convenience amount must be less than transaction amount.',
      );
    } else {
      if (isTipsEnable) {
        tipsOrConveninece = tips;
      } else if (isTipsFixed) {
        tipsOrConveninece = tips;
      } else {
        tipsOrConveninece = ((amount * tips) / 100).toPrecision(2);
      }
      String id = '';
      for (var category in _categoiesList) {
        if (category.type ==
            TransactionType.QrCodePayment
                .toString()
                .split('.')
                .last) {
          id = category.id;
          break;
        }
      }
      var response = await presenter.transactionFeeCalculate(id, amount);
      if (response != null) {
        txnFees = response;
        for (var vendor in txnFees) {
          if (vendor.vendorName == 'QCash') {
            vendor.fee != 'Free'
                ? feeAmount = vendor.fee.replaceAll('৳ ', '')
                : feeAmount = '0';
            vendor.vat != 'N/A'
                ? vatAmount = vendor.vat.replaceAll('৳ ', '')
                : vatAmount = '0';
            isOtpRequired = vendor?.isOtpRequired;
            break;
          }
        }
        showConfirmation(
            amount,
            double.parse(feeAmount),
            double.parse(vatAmount),
            purpose,
            cvv,
            isOtpRequired,
            tipsOrConveninece,
            isTipsEnable
                ? AppLocalizations
                .of(context)
                .inputTips
                : AppLocalizations
                .of(context)
                .inputConvenience);
      }
    }
  }

  void getMerchant(String debitSource) async {
    var response =
        await presenter.getMerchantWithQrAndSource(qrData, debitSource);
    if (response != null) {
      _scannedQrViewModel = response;
      _merchantViewModel = _scannedQrViewModel?.merchantPans?.first;
    }
  }

  Future<bool> showConfirmation(
      double totalAmount,
      double feeAmount,
      double vatAmount,
      String purpose,
      String cvv,
      bool isOtpRequired,
      double transactionTipOrConvenience,
      String tipsOrConvenience) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QrCodePaymentConfirmationPage(
          totalAmount,
          feeAmount,
          vatAmount,
          AccountSelector("From", _debitAccount, isEnabled: false),
          AccountSelector(
              "To",
              LinkedAccountViewModel(
                  accountNumberMasked: _merchantViewModel?.pan,
                  accountHolderName: _scannedQrViewModel?.retailerName,
                  instituteName: _scannedQrViewModel?.retailerName),
              isEnabled: false),
          _debitAccount,
          _merchantViewModel?.identifier,
          qrData,
          purpose,
          _scannedQrViewModel,
          _merchantViewModel,
          cvv,
          isOtpRequired,
          transactionTipOrConvenience,
          tipsOrConvenience);
    }));
    _transaction = result != null ? result : null;
    if (_transaction.transactionStatus != 'Declined') {
      NavigatorUtils.goBack(context);
    } else {
      _amountController.text = '';
      _purposeController.text = '';
      _cvvController.text = '';
      _debitAccount = null;
    }
  }

  void _selectSender() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: false,
        builder: (_) => CardsSelectorPage(Constant.transactionAccountSelector));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  ScanQrCodePagePresenter createPresenter() {
    return ScanQrCodePagePresenter();
  }

  void _onAccountSelected() {
    var account = accountSelectionListener.selectedAccount;
    if (mounted && account != null) {
      setState(() {
        if (_selectIntent == "debit") {
          _debitAccount = accountSelectionListener.selectedAccount;
          getMerchant(_debitAccount.brand);
        }
        _verify();
      });
    }
  }

  void _verify() {
    bool clickable = true;
    bool newEnable = true;
    bool cvvEnabled = true;
    final String amountString = _amountController.text;
    final String cvvString = _cvvController.text;
    final String tipsAmountSting = _tipController.text;
    if (_debitAccount == null) {
      clickable = false;
    }
    if (_debitAccount != null && _debitAccount.productType == 'DebitCard') {
      if (cvvString.isEmpty) {
        clickable = false;
        cvvEnabled = false;
      }
      if (cvvString.length < 3) {
        clickable = false;
        cvvEnabled = false;
      }
    }
    if (amountString.isEmpty) {
      clickable = false;
      newEnable = false;
    }
    if(_amountController.text.isNotEmpty){
      if(_nodeText1.canRequestFocus && double.parse(_amountController.text)==0){
        _amountController.text = '';
      }
    }

    if (amountString.isNotEmpty) {
      if (tipsVisibility && !isTipsEnable) {
        if (isTipsFixed) {
          _tipController.text =
              _scannedQrViewModel.transactionTipOrConvenience.amount.toString();
          _totalAmountController.text = (double.parse(_amountController.text) +
                  double.parse(_tipController.text))
              .toStringAsFixed(2);
        } else {
          _tipController.text = _scannedQrViewModel
                  .transactionTipOrConvenience.amount
                  .toString() +
              " %";
          _totalAmountController.text = (double.parse(_amountController.text) +
                  ((double.parse(_amountController.text) *
                              _scannedQrViewModel
                                  .transactionTipOrConvenience.amount) /
                          100)
                      .toPrecision(2))
              .toStringAsFixed(2);
        }
      } else {
        _totalAmountController.text =
            (double.parse(_amountController.text)).toStringAsFixed(2);
      }
    }
    if (amountString.isEmpty) {
      setState(() {
        _totalAmountController.text = _tipController.text;
      });
    }
    if (isTipsEnable) {
      if (tipsAmountSting.isEmpty) {
        clickable = false;
        _totalAmountController.text =
            (double.parse(_amountController.text)).toStringAsFixed(2);
      }
      if (tipsAmountSting.isNotEmpty) {
        _totalAmountController.text = (double.parse(_amountController.text) +
                double.parse(_tipController.text))
            .toStringAsFixed(2);
      }
      if (_tipController.text.isNotEmpty) {
        if (double.parse(_amountController.text) <
            double.parse(_tipController.text)) {
          clickable = false;
          showSnackBar(
            'Tips or Convenience amount must be less than transaction amount.',
          );
        }
      }
    }

    if (mounted) {
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
         // _nodeText1.unfocus();
          _nodeText2.unfocus();
          _nodeText3.unfocus();
          //_nodeText4.unfocus();
          _nodeText5.unfocus();
        });
      }
    }
  }

  @override
  void setData(ScannedQrViewModel model) {
    if (mounted) {
      setState(() {
        _scannedQrViewModel = model;
        isAmountActive = _scannedQrViewModel.transactionAmount.isActive;
        _amountController.text =
            _scannedQrViewModel.transactionAmount.amount.toString();

        indicator = _scannedQrViewModel.transactionTipOrConvenience.indicator;
        switch (indicator) {
          case '00':
            isTipsEnable = false;
            tipsVisibility = false;
            _tipController.text = '0';
            break;
          case '01':
            isTipsEnable = true;
            tipsVisibility = true;
            break;
          case '02':
            isTipsEnable = false;
            isTipsFixed = true;
            tipsVisibility = true;
            if (!isAmountActive) {
              _tipController.text = _scannedQrViewModel
                  .transactionTipOrConvenience.amount
                  .toString();
              _totalAmountController.text =
                  (double.parse(_amountController.text) +
                          double.parse(_tipController.text))
                      .toStringAsFixed(2);
            }
            break;
          case '03':
            isTipsEnable = false;
            isTipsFixed = false;
            tipsVisibility = true;
            if (!isAmountActive) {
              _tipController.text = _scannedQrViewModel
                      .transactionTipOrConvenience.amount
                      .toString() +
                  " %";
              _totalAmountController.text =
                  (double.parse(_amountController.text) +
                          ((double.parse(_amountController.text) *
                                      _scannedQrViewModel
                                          .transactionTipOrConvenience.amount) /
                                  100)
                              .toPrecision(2))
                      .toStringAsFixed(2);
            }
            break;
          default:
            break;
        }
      });
    }
  }

  @override
  void setTransactionsCategory(
      List<TransactionCategoryViewModel> transactionCategoryViewModel) {
    if (mounted) {
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
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gaps.vGap8,
                          Text(
                            "Hold Amount:",
                            style: TextStyle(
                                color: Colours.text_gray,
                                fontSize: 12.0,
                                fontFamily: 'SF'),
                          ),
                          Gaps.vGap8,
                          Text(
                            balanceResponse[index].currency +
                                " " +
                                balanceResponse[index].holdAmount,
                            style: TextStyle(
                                color: Colours.textBlueColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF'),
                          ),
                          Gaps.line,
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
