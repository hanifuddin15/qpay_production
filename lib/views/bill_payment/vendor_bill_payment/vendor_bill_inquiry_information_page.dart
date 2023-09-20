import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/bill_inquiry_response_vm.dart';
import 'package:qpay/net/contract/bill_vendor_params_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_iview.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_page.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_presenter.dart';
import 'package:qpay/views/home/accounts/card_selector_page.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/confirmation_screen_column_box.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

class VendorBillInquiryInformationPage extends StatefulWidget {
  final BillInquiryResponseViewModel _billInquiryResponseViewModel;
  final BillVendorViewModel _billVendorViewModel;
  final BillVendorParamsViewModel _billVendorParamsViewModel;
  final String _accountNo;
  final String _dateTime;
  final double _feeAmount;
  final double _vatAmount;
  final bool _isOtpRequired;

  VendorBillInquiryInformationPage(this._billInquiryResponseViewModel,
      this._billVendorViewModel, this._billVendorParamsViewModel, this._accountNo, this._dateTime, this._feeAmount, this._vatAmount, this._isOtpRequired);

  @override
  _VendorBillInquiryInformationPageState createState() => _VendorBillInquiryInformationPageState(
      _billInquiryResponseViewModel,
      _billVendorViewModel,
      _billVendorParamsViewModel,
      _accountNo,
      _dateTime,
      _feeAmount,
      _vatAmount,
      _isOtpRequired);
}

class _VendorBillInquiryInformationPageState extends State<VendorBillInquiryInformationPage>
    with
        BasePageMixin<VendorBillInquiryInformationPage, VendorBillPaymentPresenter>,
        AutomaticKeepAliveClientMixin<VendorBillInquiryInformationPage>
    implements VendorBillPaymentIMvpView {
  final BillInquiryResponseViewModel billInquiryResponseViewModel;
  final BillVendorViewModel billVendorViewModel;
  final BillVendorParamsViewModel billVendorParamsViewModel;
  final String accountNo;
  final String dateTime;
  final double feeAmount;
  final double vatAmount;
  final bool isOtpRequired;
  _VendorBillInquiryInformationPageState(this.billInquiryResponseViewModel,
      this.billVendorViewModel, this.billVendorParamsViewModel, this.accountNo, this.dateTime,this.feeAmount,this.vatAmount, this.isOtpRequired);

  TransactionViewModel _transaction;
  List<TransactionCategoryViewModel> _categoiesList =
  <TransactionCategoryViewModel>[];
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];
  double totalAmount = 0;
  bool _clickable = false;

  @override
  void initState() {
    totalTransactionAmount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _verify() {
    bool clickable = true;
    if(billInquiryResponseViewModel == null){
      clickable = false;
    }
    if(mounted && clickable != _clickable)
    setState(() {
      _clickable = clickable;
    });
  }

  void totalTransactionAmount(){
    if(feeAmount.toString() != null && billInquiryResponseViewModel.totalBillAmount.toString() != null && vatAmount.toString() != null){
      totalAmount = feeAmount+billInquiryResponseViewModel.totalBillAmount+vatAmount;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() => [
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: NetworkImage(
                      billVendorViewModel?.imageUrl ??
                          'https://img.icons8.com/ios-filled/50/000000/electricity.png',
                      scale: 10),
                ),
                Gaps.vGap16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Gaps.hGap16,
                    ConfirmScreenLargeAmountColumnBox('Total Amount',HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(totalAmount))),
                    Gaps.hGap16,
                  ],
                ),
                Gaps.vGap8,
                Gaps.line,
                Gaps.vGap8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Gaps.hGap16,
                    ConfirmScreenAmountColumnBox('Amount',HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(billInquiryResponseViewModel.totalBillAmount??0))),
                    Gaps.hGap16,
                    Gaps.vLine,
                    Gaps.hGap16,
                    ConfirmScreenAmountColumnBox('Fee',HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(feeAmount))),
                    Gaps.hGap16,
                    Gaps.vLine,
                    Gaps.hGap16,
                    ConfirmScreenAmountColumnBox('VAT', HelperUtils.amountWithSymbol(HelperUtils.amountFormatter(vatAmount))),
                    Gaps.hGap16,
                  ],
                ),
                Gaps.vGap8,
                Gaps.line,
                Gaps.vGap16,
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bill Information'.toUpperCase(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colours.app_main),),
                    Gaps.vGap8,
                    Gaps.line,
                    Gaps.vGap8,
                    GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(4),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.25,
                        ),
                        itemCount:  billInquiryResponseViewModel.value.length, itemBuilder: (context, i){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(billInquiryResponseViewModel.value[i].key,style: TextStyle(color: Colours.text,fontSize: 10),textAlign: TextAlign.center,),
                          Gaps.vGap4,
                          Text(billInquiryResponseViewModel.value[i].value,style: TextStyle(color: Colours.text,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    Gaps.vGap24,
    MyButton(
      key: const Key('confirm'),
      onPressed:  billInquiryResponseViewModel != null? _next :null,
      text:'Pay Now'.toUpperCase(),
    ),
  ];

  void _next() async {
    final result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorBillPaymentPage(billInquiryResponseViewModel,billVendorViewModel,billVendorParamsViewModel,accountNo,dateTime,isOtpRequired);
    }));
    _transaction = result != null ? result : null;
    if (_transaction != null) {
      if (_transaction.transactionStatus != 'Declined') {
        NavigatorUtils.goBackWithParams(context, _transaction);
      }
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
}
