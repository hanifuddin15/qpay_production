import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/dashboard_provider.dart';
import 'package:qpay/widgets/account_group_widget.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

class BeneficiariesAccountContainer extends StatelessWidget {
  final Function(LinkedAccountViewModel) onSelect;
  final provider = DashboardProvider();

  Map<String, List<LinkedAccountViewModel>> _groups;
  List<String> _keys;

  BeneficiariesAccountContainer(this._groups, this._keys, this.onSelect);

  @override
  Widget build(BuildContext context) {
    if (_groups.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MyScrollView(
          children: [
            ListView.builder(
              itemCount: _groups.length,
              shrinkWrap: true,
            physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return AccountGroupWidget(context, _keys[index], _groups[_keys[index]],onSelect);
                },
          ),
    ]
        ),
      );
    }
    return Container();
  }
}
