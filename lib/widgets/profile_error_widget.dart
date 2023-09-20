import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/widgets/line_widget.dart';

class ProfileErrorWidget extends StatelessWidget {
  final String _error;
  final Function _action;

  ProfileErrorWidget(this._error, this._action);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.blueGrey,
                ),
                Gaps.hGap8,
                Container(
                  width: MediaQuery.of(context).size.width*.35,
                  child: Text(
                    _error??"Profile error",
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.0),),
                ),
                Gaps.hGap16,
              ],
            ),
            ButtonTheme(
              minWidth: 60,
              height: 30,
              child: MaterialButton(
                color: Colours.app_main,
                child: Text(
                  AppLocalizations.of(context).fixThis,
                  style: TextStyles.textBold12,
                ),
                onPressed: _action,
              ),
            )
          ],
        ),
      ),
    );
  }
}
