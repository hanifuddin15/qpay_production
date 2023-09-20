import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/utils/screen_utils.dart';
import 'package:qpay/utils/theme_utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';

class PinInputDialog extends StatefulWidget {
  final onPinInserted;
  final TransactionAmountDescriptionWidget header;

  PinInputDialog(this.onPinInserted, {this.header});

  @override
  _PinInputDialogState createState() => _PinInputDialogState();
}

class _PinInputDialogState extends State<PinInputDialog> {
  int _index = 0;
  final _list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0];
  List<String> _codeList = ['', '', '', '', '', ''];
  String _pincode;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).insertOtp.toUpperCase(),
        ),
        body: _buildBody,
      ),
    );
  }

  Widget get _buildBody => Container(
        color: ThemeUtils.getDialogBackgroundColor(context),
        height: Screen.height(context),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: AssetImage('assets/images/otp_icon.png'),
                          height: 100.0,
                          width: 100.0,
                        ),
                      ),
                      Gaps.vGap8,
                      /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Enter your OTP code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0,fontFamily: 'Inter'),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
            Gaps.vGap8,
            widget.header ?? Container(),
            Gaps.vGap32,
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 50.0,
                        margin: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: Row(
                            children: List.generate(
                                _codeList.length, (i) => _buildInputWidget(i))),
                      ),
                    ],
                  ),
                ),
            Gaps.vGap32,
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).dividerTheme.color,
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.65,
                          mainAxisSpacing: 0.8,
                          crossAxisSpacing: 0.8,
                        ),
                        itemCount: 12,
                        itemBuilder: (_, index) => _buildButton(index)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildButton(int index) {
    final color = ThemeUtils.isDark(context)
        ? Colours.dark_bg_gray
        : Colours.dark_button_text;
    return Material(
      color: (index == 9 || index == 11) ? color : null,
      child: InkWell(
        child: Center(
          child: index == 11
              ? Semantics(
                  label: AppLocalizations.of(context).cancel,
                  child: const LoadAssetImage('del', width: 32.0))
              : index == 9
                  ? Semantics(
                      label: AppLocalizations.of(context).invalid,
                      child: Gaps.empty)
                  : Text(_list[index].toString(),
                      style: TextStyle(fontSize: 22.0)),
        ),
        onTap: () {
          if (index == 9) {
            return;
          }
          if (index == 11) {
            if (_index == 0) {
              return;
            }
            _codeList[_index - 1] = '';
            _index--;
            if(mounted) setState(() {});
            return;
          }
          _codeList[_index] = _list[index].toString();
          _index++;
          if (_index == _codeList.length) {
            var code = '';
            for (var i = 0; i < _codeList.length; i++) {
              code = code + _codeList[i];
            }
            _matchPin(code);
            _index = 0;
            for (var i = 0; i < _codeList.length; i++) {
              _codeList[i] = '';
            }
          }
          if(mounted)setState(() {});
        },
      ),
    );
  }

  Widget _buildInputWidget(int p) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                border: p != 5
                    ? Border(
                  right: Divider.createBorderSide(context,
                      color: Color.fromRGBO(0, 0, 0, 0.1), width: 1.0),
                )
                    : null),
            child: Text(
              _codeList[p].isEmpty ? '' : '●',
              style: TextStyle(fontSize: Dimens.font_sp22),
            )),
      ),
    );
  }

  void _matchPin(String code) {
    this._pincode = code;
    widget.onPinInserted(code);
  }

  @override
  void dispose() {
    if (_pincode == null || _pincode.isEmpty) widget.onPinInserted(null);
    super.dispose();
  }

}
