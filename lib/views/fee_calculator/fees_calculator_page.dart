import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/fee_calculator/fees_calculator_iview.dart';
import 'package:qpay/views/fee_calculator/fees_calculator_page_presenter.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/number_formatter_two_decimal.dart';
import 'package:qpay/widgets/text_field.dart';

class FeesCalculatorPage extends StatefulWidget {
  _FeesCalculatorPageState createState() => _FeesCalculatorPageState();
}

class _FeesCalculatorPageState extends State<FeesCalculatorPage>
    with
        BasePageMixin<FeesCalculatorPage,
            FeesCalculatorPagePresenter>,
        AutomaticKeepAliveClientMixin<FeesCalculatorPage>
    implements
        FeesCalculatorIMvpView {
  final FocusNode _nodeText1 = FocusNode();
  final TextEditingController _amountController = TextEditingController();
  bool _clickable = false;
  var _isCategoryChangedByUser = false;
  bool isEnabled =true;
  List<TransactionFeeViewModel> txnFees = <TransactionFeeViewModel>[];
  TransactionCategoryViewModel _selectedCategory;
  List<TransactionCategoryViewModel> _categoiesList =
      <TransactionCategoryViewModel>[];

  List<DropdownMenuItem<TransactionCategoryViewModel>>
      buildDropdownCategoryItems(List categories) {
    var dataItems = categories ?? <TransactionCategoryViewModel>[];
    List<DropdownMenuItem<TransactionCategoryViewModel>> items = [];
    for (TransactionCategoryViewModel category in dataItems) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.name,style: TextStyle(fontSize: Dimens.font_sp16,fontWeight: category.id == '0' ?FontWeight.bold:FontWeight.normal,color: category.id == '0'?Colours.app_main:Colours.text),),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    _amountController.addListener(_verify);
    _categoiesList
        .add(TransactionCategoryViewModel(name: 'Select Category', id: '0'));
    _selectedCategory = _categoiesList.first;
    super.initState();
  }

  @override
  void dispose() {
    _amountController.removeListener(_verify);
    _amountController.dispose();
    _nodeText1.dispose();
    super.dispose();
  }

  void _verify() {
    final String amountString = _amountController.text;
    bool clickable = true;
    if (amountString.isEmpty) {
      clickable = false;
    }
    if (mounted && clickable != _clickable) {
      setState(() {
        _clickable = clickable;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(
            centerTitle: AppLocalizations.of(context).txnFees,
          ),
        body: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                  value: _selectedCategory,
                  items: buildDropdownCategoryItems(_categoiesList),
                  onChanged: onCategoryChange,
                  isExpanded: true,
                ),
              ),
            ),
            Gaps.line,
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
              hintText: AppLocalizations.of(context).inputAmount,
              labelText: AppLocalizations.of(context).inputAmount,
            ),
            Gaps.vGap24,
            MyButton(
              key: const Key('confirm'),
              onPressed: _clickable ? _initiate : null,
              text: AppLocalizations.of(context).submit,
            ),
          ],
        ),
      ),
    );
  }

  void _initiate() async {
    final double amount = double.parse(_amountController.text);
    String id;
    if (_selectedCategory.id != '0') {
      id = _selectedCategory.id;
    }
    var response = await presenter.transactionFeeCalculate(id, amount);
    if (response != null) {
      txnFees = response;
      _showFees(txnFees);
    }
  }

  _showFees(List<TransactionFeeViewModel> fees) {
    showElasticDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: '',
            hiddenTitle: false,
            title: AppLocalizations.of(context).txnFees.toUpperCase(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 4.0),
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: fees.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            fees[index].vendorName,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize:Dimens.font_sp16,fontWeight:FontWeight.bold,),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                        Text(
                          fees[index].fee,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize:Dimens.font_sp16,fontWeight:FontWeight.bold,fontFamily: 'Inter',color: Colours.app_main),
                        ),
                      ],
                    );
                  }),
              ),
            ),
            onPressed: () async {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }

  onCategoryChange(TransactionCategoryViewModel category) {
    if(mounted){
      setState(() {
        _isCategoryChangedByUser = true;
        _selectedCategory = category;
        _amountController.text = '';

      });
    }
  }

  @override
  FeesCalculatorPagePresenter createPresenter() {
    return FeesCalculatorPagePresenter();
  }

  @override
  void setTransactionsCategory(
      List<TransactionCategoryViewModel> transactionCategoryViewModel) {
    if(mounted){
      setState(() {
        _categoiesList.addAll(transactionCategoryViewModel);
      });
    }
  }

  @override
  bool get wantKeepAlive => false;
}
