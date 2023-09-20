import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/widgets/taka_icon_icons.dart';

import 'load_image.dart';

class MyTextField extends StatefulWidget {
  const MyTextField(
      {Key key,
      @required this.controller,
      this.maxLength = 100,
      this.iconName,
      this.errorText,
      this.autoFocus = false,
      this.inputFormatterList,
      this.keyboardType = TextInputType.text,
      this.hintText = '',
      this.labelText = '',
      this.focusNode,
      this.isInputPwd = false,
      this.performAction,
      this.actionName,
      this.duration = 60,
      this.enabled = true,
        this.showCursor = true,
      this.keyName,
      this.textInputAction = TextInputAction.done})
      : super(key: key);

  final TextEditingController controller;
  final int maxLength;
  final int duration;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText;
  final String labelText;
  final String actionName;
  final FocusNode focusNode;
  final bool isInputPwd;
  final Future<bool> Function() performAction;
  final List<TextInputFormatter> inputFormatterList;
  final String keyName;
  final String iconName;
  final String errorText;
  final bool enabled;
  final bool showCursor;
  final TextInputAction textInputAction;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isShowPwd = false;
  bool _isShowDelete = false;
  bool _clickable = true;
  int _currentSecond;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _isShowDelete = widget.controller.text.isEmpty;
    widget.controller.addListener(isEmpty);
  }

  void isEmpty() {
    bool isEmpty = widget.controller.text.isEmpty;
    if(mounted && isEmpty != _isShowDelete) {
      setState(() {
        _isShowDelete = isEmpty;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    widget.controller?.removeListener(isEmpty);
  }

  Future _getVCode() async {
    bool isSuccess = await widget.performAction();
    if(mounted && isSuccess != null && isSuccess) {
      setState(() {
        _currentSecond = widget.duration;
        _clickable = false;
      });
      _subscription = Stream.periodic(const Duration(seconds: 1), (int i) => i)
          .take(widget.duration)
          .listen((int i) {
        if(mounted) {
          setState(() {
            _currentSecond = widget.duration - i - 1;
            _clickable = _currentSecond < 1;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    final ThemeData themeData = Theme.of(context);
    final TextField textField = TextField(
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      obscureText: widget.isInputPwd ? !_isShowPwd : false,
      autofocus: widget.autoFocus,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      showCursor: widget.showCursor,

      inputFormatters: widget.inputFormatterList == null
          ? defaultInputFormatters()
          : widget.inputFormatterList,
      decoration: InputDecoration(
        prefixIcon: getIconByType(widget.iconName),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorStyle: TextStyle(color: Colours.red),
        errorText: widget.errorText,
        labelStyle: TextStyle(color: _getActivationColor()),
        hintStyle: TextStyle(color: _getActivationColor()),
        counterText: '',
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(3.0),
          ),
          borderSide: BorderSide(
            color: Colours.app_main,
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(3.0),
          ),
          borderSide: BorderSide(
            color: Colours.unselected_item_color,
            width: 1.2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(3.0),
          ),
          borderSide: BorderSide(
            color: Colours.unselected_item_color,
            width: 1.2,
          ),
        ),
      ),
    );

    Widget clear = Semantics(
      label: 'Clear',
      hint: 'Clear the input box',
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: LoadAssetImage(
            'login/qyg_shop_icon_delete',
            key: Key('${widget.keyName}_delete'),
            width: 18.0,
            height: 40.0,
          ),
        ),
        onTap: () => {
          widget.controller.text = '',
          widget.focusNode.unfocus()
          },
      ),
    );

    Widget pwdVisible = Semantics(
      label: 'Show password',
      hint: 'Show password',
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: LoadAssetImage(
            _isShowPwd
                ? 'login/qyg_shop_icon_display'
                : 'login/qyg_shop_icon_hide',
            key: Key('${widget.keyName}_showPwd'),
            width: 18.0,
            height: 40.0,
          ),
        ),
        onTap: () {
          setState(() {
            _isShowPwd = !_isShowPwd;
          });
        },
      ),
    );

    Widget getVCodeButton = Theme(
      data: Theme.of(context).copyWith(
        buttonTheme: const ButtonThemeData(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          height: 26.0,
          minWidth: 76.0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      child: TextButton(
        key: const Key('getVerificationCode'),
        onPressed: _clickable ? _getVCode : null,
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
            foreground: Paint()..color= themeData.primaryColor,
          )),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) =>
            states.contains(MaterialState.disabled)? Colours.text_gray_c :Colors.transparent,
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.0),
            side: BorderSide(
              color: _clickable ? themeData.primaryColor : Colors.transparent,
              width: 0.8,
            ),
          ),)
        ),
        child: Text(
          _clickable
              ? widget.actionName?.toUpperCase() ??
                  AppLocalizations.of(context).getDateTime.toUpperCase()
              : '（$_currentSecond s）',
          style: TextStyle(fontSize: 10,color: Colors.white),
        ),
      ),
    );
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colours.app_main),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          textField,
          widget.enabled
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (_isShowDelete) Gaps.empty else clear,
                    if (!widget.isInputPwd) Gaps.empty else Gaps.hGap15,
                    if (!widget.isInputPwd) Gaps.empty else pwdVisible,
                    if (widget.performAction == null) Gaps.empty else Gaps.hGap15,
                    if (widget.performAction == null)
                      Gaps.empty
                    else
                      getVCodeButton,
                    if (widget.performAction == null) Gaps.empty else Gaps.hGap8,
                  ],
                )
              : Gaps.empty
        ],
      ),
    );
  }

  List<TextInputFormatter> defaultInputFormatters() {
    return (widget.keyboardType == TextInputType.number ||
            widget.keyboardType == TextInputType.phone)
        ? [ FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
        : [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))];
  }

  Icon getIconByType(String type) {
    switch (type) {
      case 'amount':
        return Icon(
          TakaIcon.taka_icon,
          size: Dimens.font_sp18,
            color: _getActivationColor()
        );
        break;
      case 'password':
        return Icon(Icons.lock,color: _getActivationColor());
        break;
      case 'phone':
        return Icon(Icons.phone_android,color: _getActivationColor());
        break;
      case 'name':
        return Icon(Icons.person,color: _getActivationColor());
        break;
      case 'date':
        return Icon(Icons.calendar_today,color: _getActivationColor());
        break;
      case 'bank':
        return Icon(Icons.account_balance,color: _getActivationColor());
        break;
      case 'card':
        return Icon(Icons.credit_card,color: _getActivationColor());
        break;
      case 'address':
        return Icon(Icons.home,color: _getActivationColor());
        break;
      case 'otp':
        return Icon(Icons.phonelink_lock,color: _getActivationColor());
        break;
      case 'email':
        return Icon(Icons.email,color: _getActivationColor());
        break;
      case 'id':
        return Icon(Icons.card_membership,color: _getActivationColor());
        break;
        case 'purpose':
        return Icon(Icons.analytics,color: _getActivationColor());
        break;
        case 'cvv':
        return Icon(Icons.security, color: _getActivationColor());
        break;
      default:
        return Icon(Icons.description,color: _getActivationColor(),);
    }
  }

  Color _getActivationColor() {
    return widget.focusNode.hasFocus ? Colours.app_main: Colours.text_gray;
  }
}
