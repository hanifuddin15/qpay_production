import 'package:flutter/cupertino.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';

class TransactionDetailDialogRowLayout extends StatelessWidget {

  const TransactionDetailDialogRowLayout({
    Key key,
    @required this.header,
    @required this.description
  }):super(key: key);

  final String header;
  final String description;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimens.font_sp12,
                color: Colours.text_gray
            ),
          ),
          Gaps.vGap4,
          Text(
            description,
            textAlign: TextAlign.center,
            maxLines: 3,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimens.font_sp14,
              color: Colours.text,
            ),
          ),
        ],
      ),
    );
  }
}
