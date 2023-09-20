import 'package:flutter/material.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/widgets/line_widget.dart';

class TransactionAmountDescriptionWidget extends StatelessWidget {
  final TransactionViewModel transaction;

  TransactionAmountDescriptionWidget(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gaps.line,
        Gaps.vGap8,
        AmountBoxWidget(transaction),
        Gaps.vGap10,
        Gaps.line,
      ],
    );
  }
}

class AmountBoxWidget extends StatelessWidget {
  final TransactionViewModel transaction;

  AmountBoxWidget(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Gaps.hGap16,
        SimpleAmountBox("Amount", HelperUtils.amountWithSymbol(transaction.amountFormatted)),
        Gaps.hGap16,
        Gaps.vLine,
        Gaps.hGap16,
        SimpleAmountBox("Total Fees", HelperUtils.amountWithSymbol(transaction.feeFormatted)),
        Gaps.hGap16,
        Gaps.vLine,
        Gaps.hGap16,
        SimpleAmountBox("Total", HelperUtils.amountWithSymbol(transaction.total)),
        Gaps.hGap16,
      ],
    );
  }
}

class SimpleAmountBox extends StatelessWidget {
  final String title;
  final String amount;

  SimpleAmountBox(this.title, this.amount);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyles.textSize12,
        ),
        Gaps.vGap10,
        Text(
          amount,
          style: TextStyles.textBold14,
        ),
      ],
    );
  }
}
