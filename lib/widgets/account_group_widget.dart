import 'package:flutter/material.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/widgets/account_element_widget.dart';

Widget AccountGroupWidget(BuildContext context,
  String groupName,
  List<LinkedAccountViewModel> accounts,
 Function(LinkedAccountViewModel) onSelect){
  if(accounts.isNotEmpty){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          groupName.toLowerCase()=='bankaccount'?Text('Bank Account'):Text('$groupName'),
          Gaps.vGap8,
          ListView.builder(
            shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: accounts.length,
              itemBuilder: (context, i) {
              return InkWell(
                onTap: () => onSelect(accounts[i]),
                child: AccountElementWidget(
                    context: context,
                    cardIssuedBankImage: accounts[i].imageUrl??"",
                    cardNumber: accounts[i].accountNumberMasked??"",
                    cardHolder: accounts[i].accountHolderName??"",
                  cardType: accounts[i].productType != null
                        ? (accounts[i].productType == 'PrepaidCard'
                            ? "Prepaid Card"
                            : accounts[i].productType == 'CreditCard'
                                ? "Credit Card"
                                : accounts[i].productType == 'DebitCard'
                                    ? "Debit Card"
                                    : "")
                        : "",
                  ),
                );
            }),
        ],
      ),
    );
  }
}