import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/transaction_limit_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';

class TransactionRangeContainer extends StatelessWidget{
  final List<TransactionLimitViewModel> _range;
  final BuildContext _context;

  TransactionRangeContainer(this._context,this._range);

  @override
  Widget build(BuildContext context) {
    if(_range != null){
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
                          child: Text(
                            "Service Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colours.app_main),
                          )),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Minimum",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colours.app_main),
                          )),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Maximum",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colours.app_main),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _range.length,
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
                              _buildRangeCard(context: _context,value: _range[index].name,min: _range[index].amountRange.min.toString()
                                  ,max: _range[index].amountRange.max.toString()),
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

  Widget _buildRangeCard({
    @required BuildContext context,
    @required String value,
    @required String min,
    @required String max,
  }){
    return Container(
      width: MediaQuery.of(context).size.width*.85,
      height: MediaQuery.of(context).size.height*.085,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(value,softWrap: true,textAlign: TextAlign.center,
                    maxLines: 2,style: TextStyle(fontSize:Dimens.font_sp14,/*fontWeight:FontWeight.bold,color: Colours.app_main*/),),
              ),
            ],
          ),
        ),
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Align(
          alignment: Alignment.center,
          child:Text(min,style: TextStyle(fontSize:Dimens.font_sp14,/*fontWeight:FontWeight.bold*/),),),
          ],
        ),
      ),
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Align(
          alignment: Alignment.center,
          child:Text(max,style: TextStyle(fontSize:Dimens.font_sp14,/*fontWeight:FontWeight.bold*/)),),
          ],
        ),
      ),
        ],
      ),
    );
  }
}