import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/bill_inquiry_response_vm.dart';
import 'package:qpay/net/contract/bill_vendor_params_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_inquiry_information_page.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_iview.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';
import 'package:qpay/widgets/cupertino_picker_extended.dart' as CupertinoExtended;

import '../../../net/contract/custom_contact.dart';
import '../../../routers/dashboard_router.dart';
import '../../../widgets/my_dialog.dart';


class VendorBillInquiryPage extends StatefulWidget {
  final BillVendorViewModel _billVendorViewModel;

  VendorBillInquiryPage(this._billVendorViewModel);

  @override
  _VendorBillInquiryPageState createState() =>
      _VendorBillInquiryPageState(_billVendorViewModel);
}

class _VendorBillInquiryPageState extends State<VendorBillInquiryPage>
    with
        BasePageMixin<VendorBillInquiryPage, VendorBillPaymentPresenter>,
        AutomaticKeepAliveClientMixin<VendorBillInquiryPage>
    implements VendorBillPaymentIMvpView {
  final BillVendorViewModel billVendorViewModel;

  _VendorBillInquiryPageState(this.billVendorViewModel);
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _billNoController = TextEditingController();
  final TextEditingController _billDateController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _clickable = false;
  TransactionViewModel _transaction;
  List<TransactionCategoryViewModel> _categoiesList =
  <TransactionCategoryViewModel>[];
  List<DropDownData> _billTypeList = <DropDownData>[] ;
  DropDownData _selectedBillType;
  BillVendorParamsViewModel _billVendorParamsViewModel;
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];
  DateTime _chosenDateTime;
  DateFormat formatter = DateFormat('MMMM, yyyy');
  var _isBillTypeChangedByUser = false;
  String feeAmount = '';
  String vatAmount = '';
  bool isOtpRequired = false;
  String _contactName;

  @override
  void initState() {
    super.initState();
    _accountController.addListener(_verify);
    _billDateController.addListener(_verify);
    _billNoController.addListener(_verify);
    _mobileController.addListener(_verify);
    _amountController.addListener(_verify);
    _billDateController.value =
        TextEditingValue(text: formatter.format(
            DateTime.now()));
    _billTypeList.add(DropDownData(key:'',value: 'Select Bill Type'));
    _selectedBillType = _billTypeList.first;
  }

  @override
  void dispose() {
    _accountController.removeListener(_verify);
    _accountController.dispose();
    _nodeText1.dispose();
    _billDateController.removeListener(_verify);
    _billDateController.dispose();
    _nodeText2.dispose();
    _mobileController.removeListener(_verify);
    _mobileController.dispose();
    _nodeText3.dispose();
    _billNoController.removeListener(_verify);
    _billNoController.dispose();
    _nodeText4.dispose();
    _amountController.removeListener(_verify);
    _amountController.dispose();
    _nodeText5.dispose();
    super.dispose();
  }

  void _verify() {
    final String accountNumber = _accountController.text;
    final String billNo = _billNoController.text;
    final String mobileNumber = _mobileController.text;
    final String amount = _amountController.text;
    bool clickable = true;
    if(_billVendorParamsViewModel != null) {
      if (_billVendorParamsViewModel.accountNumber.isRequired) {
        if(accountNumber.isEmpty) {
          clickable = false;
        }
      }
      if (_billVendorParamsViewModel.billNo.isRequired) {
        if(billNo.isEmpty) {
          clickable = false;
        }
      }
      if (_billVendorParamsViewModel.amount.isRequired) {
        if(amount.isEmpty) {
          clickable = false;
        }
      }
      if (_billVendorParamsViewModel.mobileNumber.isRequired) {
        if(mobileNumber.isEmpty) {
            clickable = false;
        }
      }
      if (_billVendorParamsViewModel.mobileNumber.isRequired) {
        if(mobileNumber.length<11) {
            clickable = false;
        }
        if(mobileNumber.length==11 && HelperUtils.isInvalidPhoneNumber(mobileNumber)){
          clickable = false;
          showSnackBar('Please enter a valid mobile number. Thank you.');
        }
      }
      if (_billVendorParamsViewModel.billingTypes.isRequired) {
        if(_selectedBillType.key == '') {
          clickable = false;
        }
      }
    }
    if(_billVendorParamsViewModel == null){
      clickable = false;
    }
    if (mounted && clickable != _clickable) {
      setState(() {
        _clickable = clickable;
       // _nodeText1.unfocus();
        _nodeText2.unfocus();
        _nodeText3.unfocus();
       // _nodeText4.unfocus();
       // _nodeText5.unfocus();
      });
    }

  }

  List<DropdownMenuItem<DropDownData>> buildDropdownVendorParamsItems(
      List vendorParams) {
    var dataItems = vendorParams ?? List<DropDownData>();
    List<DropdownMenuItem<DropDownData>> items = List();
    for (DropDownData vendor in dataItems) {
      items.add(
        DropdownMenuItem(
          value: vendor,
          child: Text(vendor.value),
        ),
      );
    }
    return items;
  }

  onBillTypeChange(DropDownData billType) {
    if(mounted) {
      setState(() {
        _isBillTypeChangedByUser = true;
        _selectedBillType = billType;
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
          keyboardConfig: Utils.getKeyboardActionsConfig(context,
              <FocusNode>[_nodeText1,_nodeText2,_nodeText3,_nodeText4,_nodeText5]),
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

    Gaps.line,
    Gaps.vGap16,
    GestureDetector(
      onTap: () => _showDatePicker(context),
      child: AbsorbPointer(
        child: MyTextField(
          key: const Key('billDate'),
          iconName: 'date',
          focusNode: _nodeText2,
          controller: _billDateController,
          maxLength: 20,
          showCursor: _nodeText2.hasFocus?true:false,
          keyboardType: TextInputType.text,
          hintText: 'Billing Month & Year'??'',
          labelText:  'Billing Month & Year'??'',
        ),
      ),
    ),
    Gaps.line,
    Visibility(
      visible: _billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.accountNumber.isActive?true:false):false,
      child: Column(
        children: [
          Gaps.vGap16,
          MyTextField(
            key: const Key('account'),
            iconName: 'account',
            focusNode: _nodeText1,
            controller: _accountController,
            maxLength: 20,
            showCursor: _nodeText1.hasFocus?true:false,
            keyboardType: TextInputType.text,
            hintText:_billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.accountNumber.isActive?_billVendorParamsViewModel.accountNumber.displayName:''):'',
            labelText:_billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.accountNumber.isActive?_billVendorParamsViewModel.accountNumber.displayName:''):'',
          ),
        ],
      ),
    ),
    Visibility(
      visible: _billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.billNo.isActive?true:false):false,
      child: Column(
        children: [
          Gaps.vGap16,
          MyTextField(
            key: const Key('bill'),
            iconName: 'account',
            focusNode: _nodeText4,
            controller: _billNoController,
            maxLength: 20,
            showCursor: _nodeText4.hasFocus?true:false,
            keyboardType: TextInputType.text,
            hintText:_billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.billNo.isActive?_billVendorParamsViewModel.billNo.displayName:''):'',
            labelText: _billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.billNo.isActive?_billVendorParamsViewModel.billNo.displayName:''):'',
          ),
        ],
      ),
    ),
    Visibility(
      visible: _billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.amount.isActive?true:false):false,
      child: Column(
        children: [
          Gaps.vGap16,
          MyTextField(
            key: const Key('amount'),
            iconName: 'amount',
            focusNode: _nodeText5,
            controller: _amountController,
            maxLength: 9,
            showCursor: _nodeText5.hasFocus?true:false,
            keyboardType: TextInputType.number,
            hintText:_billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.amount.isActive?_billVendorParamsViewModel.amount.displayName:''):'',
            labelText: _billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.amount.isActive?_billVendorParamsViewModel.amount.displayName:''):'',
          ),
        ],
      ),
    ),
    Visibility(
      visible: _billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.billingTypes.isDropDown&&_billVendorParamsViewModel.billingTypes.isActive?true:false):false,
      child: Column(
        children: [
          Gaps.vGap16,
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  height: 48,
                  width: MediaQuery.of(context).size.width*.92,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(
                      color: Colours.text_gray,
                      width: 1,
                    ),),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _selectedBillType,
                      items: buildDropdownVendorParamsItems(_billTypeList),
                      onChanged: onBillTypeChange,
                      isExpanded: true,
                    ),
                  ),
                ),
              ]
          ),
        ],
      ),
    ),
    Visibility(
      visible: _billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.mobileNumber.isActive?true:false):false,
      child: Column(
        children: [
          Gaps.vGap16,
          MyTextField(
            key: const Key('phone'),
            iconName: 'phone',
            focusNode: _nodeText3,
            controller: _mobileController,
            maxLength: 11,
            showCursor: _nodeText3.hasFocus?true:false,
            keyboardType: TextInputType.phone,
            performAction: _showProminantAlert,
            duration: 1,
            actionName: AppLocalizations.of(context).selectContact,
            hintText: _billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.mobileNumber.isActive?_billVendorParamsViewModel.mobileNumber.displayName:''):'',
            labelText:_billVendorParamsViewModel !=null ?(_billVendorParamsViewModel.mobileNumber.isActive?_billVendorParamsViewModel.mobileNumber.displayName:''):'',
          ),
        ],
      ),
    ),
    Gaps.vGap24,
    MyButton(
      key: const Key('confirm'),
      onPressed: _clickable ? _next : null,
      text: AppLocalizations.of(context).nextStep,
    ),
  ];

  Future<bool> _pickContacts() async {
    final result = await NavigatorUtils.pushAwait(context, DashboardRouter.contactSelectPage);
    CustomContact _customContact = result;
    _contactName = _customContact.name;
    _mobileController.text = _customContact != null ? HelperUtils.getPhoneNumberOnly(_customContact.phone):"";
    // if(_mobileController.text!=""){
    //   var _mobileOperator = _billVendorList[HelperUtils.defineOperatorFrom(_phoneController.text)];
    //   if(mounted) {
    //     setState(() {
    //       if (_mobileOperator != _selectedOperator) {
    //         _selectedOperator = _mobileOperator;
    //         onOperatorChange(_mobileOperator);
    //       }
    //     });
    //   }
    //
    // }
  }

  void _next() async {
    final String dateTime = _billDateController.value.text??'';
    final String billNo = _billNoController.text??'';
    final String accountNumber = _accountController.text??'';
    final String mobileNumber = _mobileController.text??'';
    final String billType = _selectedBillType.key;
    final String billMonth = dateTime.split(',').first;
    final int billYear = int.parse(dateTime.split(',').last);
    final int connectionId = _billVendorParamsViewModel?.connectionId ?? 0;
    final int vendorId = _billVendorParamsViewModel?.vendorId?? 0;
    double amount = 0 ;
    var accountNo = accountNumber!= ''? accountNumber : billNo;
    var _billInquiryResponse = await presenter.billPaymentInquiry(billNo, accountNumber,
        mobileNumber, billType,billMonth,billYear,vendorId,connectionId);
    if (_billInquiryResponse != null) {
      String id = '';
      for(var category in _categoiesList) {
        if (category.type == _billVendorParamsViewModel.transactionType) {
          id = category.id;
          break;
        }
      }
      if(_billVendorParamsViewModel.amount.isRequired && _billVendorParamsViewModel.amount.isActive){
        _billInquiryResponse.totalBillAmount = double.parse(_amountController.text);
      }
      var response = await presenter.transactionFeeCalculate(id, _billInquiryResponse.totalBillAmount);
      if (response != null) {
        txnFees = response;
        for (var vendor in txnFees) {
          if (vendor.vendorName != '') {
            vendor.fee != 'Free'
                ? feeAmount = vendor.fee.replaceAll('৳ ', '')
                : feeAmount = '0';
            vendor.vat != 'N/A'
                ? vatAmount = vendor?.vat.replaceAll('৳ ', '')
                : vatAmount = '0';
            isOtpRequired = vendor?.isOtpRequired;
            break;
          }
        }
        _moveToBillPaymentPage(_billInquiryResponse, accountNo, dateTime,feeAmount,vatAmount,isOtpRequired);
      }
    }
  }

  void _moveToBillPaymentPage(BillInquiryResponseViewModel billInquiryResponseViewModel, String accountNumber,String dateTime,String feeAmount, String vatAmount,bool isOtpRequired) async{
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorBillInquiryInformationPage(billInquiryResponseViewModel,billVendorViewModel,_billVendorParamsViewModel,accountNumber,dateTime,double.parse(feeAmount),double.parse(vatAmount),isOtpRequired);
    }));
    _transaction = result != null ? result : null;
    if (_transaction != null) {
      if (_transaction.transactionStatus != 'Declined') {
        NavigatorUtils.goBackWithParams(context, _transaction);
      }
    }
  }

  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: MediaQuery.of(context).size.height*.3,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*.2,
                child:CupertinoExtended.CupertinoDatePicker(
                  initialDateTime: DateTime.now() ,
                    minimumYear: DateTime.now().year-1,
                    maximumYear: DateTime.now().year,
                    mode: CupertinoExtended.CupertinoDatePickerMode.date,
                    onDateTimeChanged: (val) {
                      if(mounted) {
                        setState(() {
                          _chosenDateTime = val;
                          if (val.isBefore(DateTime.now())) {
                            _billDateController.value =
                                TextEditingValue(text: formatter.format(
                                    _chosenDateTime));
                          } else {
                            _billDateController.value =
                                TextEditingValue(text: formatter.format(
                                    DateTime.now()));
                          }
                        });
                      }
                    },
                ),
              ),
              // Close the modal
              Align(
                alignment: Alignment.bottomCenter,
                child: CupertinoButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  } ,
                ),
              )
            ],
          ),
        ));
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
   if(mounted) {
     setState(() {
       _billVendorParamsViewModel = billVendorParamsViewModel;
       if (_billVendorParamsViewModel.billingTypes.isDropDown) {
         _billTypeList.addAll(
             _billVendorParamsViewModel.billingTypes.dropDownData);
       }
     });
   }
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
