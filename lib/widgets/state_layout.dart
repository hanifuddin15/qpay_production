
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/utils/theme_utils.dart';

class StateLayout extends StatefulWidget {
  
  const StateLayout({
    Key key,
    @required this.type,
    this.hintText
  }):super(key: key);
  
  final StateType type;
  final String hintText;
  
  @override
  _StateLayoutState createState() => _StateLayoutState();
}

class _StateLayoutState extends State<StateLayout> {
  
  String _img;
  String _hintText;
  
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case StateType.network:
        _img = '';
        _hintText = '';
        break;
      case StateType.loading:
        _img = '';
        _hintText = '';
        break;
      case StateType.empty:
        _img = '';
        _hintText = '';
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (widget.type == StateType.loading) 
          const CupertinoActivityIndicator(radius: 16.0) 
        else 
          widget.type == StateType.empty ? 
          Gaps.empty : Opacity(
          opacity: ThemeUtils.isDark(context) ? 0.5 : 1,
          child: Container(
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ImageUtils.getAssetImage('state/$_img'),
              ),
            ),
          )),
        const SizedBox(width: double.infinity, height: Dimens.gap_dp16,),
        Text(
          widget.hintText ?? _hintText,
          style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: Dimens.font_sp14),
        ),
        Gaps.vGap50,
      ],
    );
  }
}

enum StateType {
  network,
  loading,
  empty
}