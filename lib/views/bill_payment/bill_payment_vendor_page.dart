import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/bill_vendor_category_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/providers/vendor_id_provider.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/dashboard_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_inquiry_page.dart';
import 'package:qpay/views/bill_payment/vendor_bill_payment/vendor_bill_payment_page.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

import 'bill_payment_iview.dart';
import 'bill_payment_persenter.dart';

class BillPaymentVendorPage extends StatefulWidget {
  @override
  _BillPaymentVendorPageState createState() => _BillPaymentVendorPageState();
}

class _BillPaymentVendorPageState extends State<BillPaymentVendorPage>
    with
        BasePageMixin<BillPaymentVendorPage, BillPaymentPresenter>,
        AutomaticKeepAliveClientMixin<BillPaymentVendorPage>
    implements BillPaymentIMvpView {
  List<BillVendorCategoryViewModel> _billVendorCategoryList =
      [BillVendorCategoryViewModel(id: 0,imageUrl: 'https://media01.qpaybd.com.bd/qpay-san/bill_pay_icon.png',name: 'All',vendors: [])];
  List<BillVendorViewModel> _allBillVendorList = <BillVendorViewModel>[];
  List<BillVendorViewModel> _sortedBillVendorList = <BillVendorViewModel>[];
  List<BillVendorViewModel> _billVendorList = <BillVendorViewModel>[];
  bool isSelected = false;
  int tappedIndex;
  TransactionViewModel _transaction;
  String categotyName = '';
  @override
  void initState() {
    super.initState();
    tappedIndex = 0;
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
        Container(
          // height: MediaQuery.of(context).size.height*.2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Organization Category',
                style: TextStyle(
                  color: Colours.text_gray,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.font_sp16,
                ),
              ),
              Gaps.vGap12,
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(4),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.25,
                ),
                itemCount: _billVendorCategoryList.length,
                itemBuilder: (_, index) {
                  return Card(
                    elevation: 3,
                    child: InkWell(
                      onTap: (){
                        if(mounted) {
                          setState(() {
                            tappedIndex = index;
                            isSelected = tappedIndex == index;
                            if (isSelected && tappedIndex != 0) {
                              _billVendorList =
                                  _billVendorCategoryList[index]?.vendors;
                              categotyName =
                                  _billVendorCategoryList[index]?.name +
                                      ' Service Provider';
                            } else {
                              _billVendorList = _allBillVendorList;
                              categotyName = '';
                            }
                          });
                        }
                      },
                      child: Container(
                        // color:tappedIndex == index && isSelected ? Colours.app_main : Colors.white70,
                        decoration: BoxDecoration(border: Border.all(color:tappedIndex == index && isSelected ? Colours.app_main : Colors.white70,),borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: NetworkImage(_billVendorCategoryList[index]?.imageUrl??'https://media01.qpaybd.com.bd/qpay-san/bill_pay_icon.png'),
                              height: 36,
                              width: 36,
                            ),
                            // LoadAssetImage('dashboard/akash_dth',height: 72,width:72,),
                            Gaps.vGap8,
                            Text(
                              _billVendorCategoryList[index]?.name??AppLocalizations.of(context).notAvailable,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Helvetica'),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
    Gaps.vGap16,
        Container(
          // height: MediaQuery.of(context).size.height*.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                categotyName != ''? categotyName:'All Organizations',
                style: TextStyle(
                  color: Colours.text_gray,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.font_sp12,
                ),
              ),
              Gaps.vGap12,
              Container(
                // height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _billVendorList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        child: InkWell(
                          onTap: (){
                            moveToBillVendor(_billVendorList[index]);
                          },
                          child: ListTile(
                            leading: SizedBox(
                              height: 50,
                              width:  50,
                              child: Image(
                                image: NetworkImage(_billVendorList[index]?.imageUrl ?? 'https://media01.qpaybd.com.bd/qpay-san/bill_pay_icon.png'),
                              ),
                            ),
                            title: Text(_billVendorList[index]?.name??AppLocalizations.of(context).notAvailable),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        )
      ];

  Future<bool> moveToBillVendor(BillVendorViewModel billVendorViewModel) async{
    VendorIdListener().setVendorId(billVendorViewModel);
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorBillInquiryPage(billVendorViewModel);}));
    _transaction = result!=null? result : null ;
    if(_transaction != null) {
      if (_transaction.transactionStatus != 'Declined') {
        NavigatorUtils.goBack(context);
      }
    }
  }

  @override
  BillPaymentPresenter createPresenter() => BillPaymentPresenter();

  @override
  void setVendorCategoryList(List<BillVendorCategoryViewModel> vendorCategoryList) {
    if(mounted) {
      setState(() {
        _billVendorCategoryList.addAll(vendorCategoryList);
        for (var vendor in _billVendorCategoryList) {
          _allBillVendorList.addAll(vendor.vendors);
        }
        _billVendorList = _allBillVendorList;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
