import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/transaction_limit_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';

class MonthlyLimitContainer extends StatelessWidget{
  final List<TransactionLimitViewModel> _monthlyLimit;
  final BuildContext _context;

  MonthlyLimitContainer(this._context,this._monthlyLimit);

  @override
  Widget build(BuildContext context) {
    if(_monthlyLimit != null){
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text("Service Name",style: TextStyle(fontWeight:FontWeight.bold,color: Colours.app_main),)),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Txn. No",style: TextStyle(fontWeight:FontWeight.bold,color: Colours.app_main),)),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Txn. Amount",style: TextStyle(fontWeight:FontWeight.bold,color: Colours.app_main),)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: _monthlyLimit.length,
                    itemBuilder: (context, index){
                      return Card(
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLimitCard(context: _context,value: _monthlyLimit[index].name,limit: _monthlyLimit[index].monthly.count.current.toString()
                                  ,limitCount: _monthlyLimit[index].monthly.count.max.toString(), amountLimit: _monthlyLimit[index].monthly.amount.current.toString(),
                                  amountLimitCount: _monthlyLimit[index].monthly.amount.max.toString()),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
    );
  }

  Widget _buildLimitCard({
    @required BuildContext context,
    @required String value,
    @required String limit,
    @required String limitCount,
    @required String amountLimit,
    @required String amountLimitCount,
  }){
    return Container(
      width:MediaQuery.of(context).size.width*.85,
      height: MediaQuery.of(context).size.height*.085,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(value,softWrap: true,textAlign: TextAlign.center,
                        maxLines: 2,),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(limit,style: TextStyle(fontSize:Dimens.font_sp14,)),
                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: Colours.app_main,
                    margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                  ),
                  Gaps.vGap2,
                  Text(limitCount,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize:Dimens.font_sp14),),
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(amountLimit,style: TextStyle(fontSize:Dimens.font_sp14)),
                  Gaps.vGap2,
                  SizedBox(
                    height: 1.0,
                    width: 80.0,
                    child: Divider(
                      color: Colours.app_main,
                    ) ,
                  ),
                  Gaps.vGap2,
                  Text(amountLimitCount,overflow:TextOverflow.ellipsis ,style: TextStyle(fontSize:Dimens.font_sp14),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}