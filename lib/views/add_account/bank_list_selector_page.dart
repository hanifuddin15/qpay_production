import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/widgets/accounts_container.dart';
import 'package:qpay/widgets/bank_list_containter.dart';

import 'link_account_iview.dart';
import 'link_account_presenter.dart';
class BankListSelectorPage extends StatefulWidget {
  final List<BankViewModel> _banks;
  BankListSelectorPage(this._banks);

  @override
  _BankListSelectorPageState createState() => _BankListSelectorPageState(_banks);


}

class _BankListSelectorPageState extends State<BankListSelectorPage> {
  final List<BankViewModel> _banksList;

  _BankListSelectorPageState(this._banksList);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 1,
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colours.app_main, //change your color here
                ),
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                    /*  labelColor: Colours.app_main,
                      unselectedLabelColor: Colours.text_gray,*/
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context).bankAndFI,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                BankListContainer(_banksList,_selectBank),
              ])),
        ),
      ),
    );
  }
  _selectBank(BankViewModel bank) {
    if(bank!=null){
      BankListSelectionListener().setBank(bank);
    }
    NavigatorUtils.goBack(context);
  }
}