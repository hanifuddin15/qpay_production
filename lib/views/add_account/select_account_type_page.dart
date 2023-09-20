import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/routers/dashboard_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/theme_utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';

class SelectAccountTypePage extends StatelessWidget {
  final List<String> data = ["Credit/ Debit/ Prepaid Card", "Bank account"];
  final List<String> image = [
    'dashboard/card_bill_payment',
    'dashboard/add_account',
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).selectAccountType,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.vGap32,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                // behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height:MediaQuery.of(context).size.height*.20 ,
                  width: MediaQuery.of(context).size.width*.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoadAssetImage(
                          '${image[0]}',
                          height: 64.0,
                          width: 64.0),
                      Gaps.vGap16,
                      Text(
                        data[0],
                        textAlign: TextAlign.center,
                        style: TextStyles.textSize12,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  NavigatorUtils.push(context, DashboardRouter.addCardPage);
                },
              ),
              InkWell(
                // behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height:MediaQuery.of(context).size.height*.20 ,
                  width: MediaQuery.of(context).size.width*.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoadAssetImage(
                          '${image[1]}',
                          height: 64.0,
                          width: 64.0),
                      Gaps.vGap16,
                      Text(
                        data[1],
                        style: TextStyles.textSize12,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  NavigatorUtils.push(context, DashboardRouter.addBankPage);
                },
              ),
            ],
          )
        ],
          ),
        ),
      ),
    );
  }
}
