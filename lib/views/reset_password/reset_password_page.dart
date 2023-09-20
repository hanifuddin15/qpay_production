
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/reset_password/reset_password_iview.dart';
import 'package:qpay/views/reset_password/reset_password_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with
        BasePageMixin<ResetPasswordPage, ResetPasswordPresenter>,
        AutomaticKeepAliveClientMixin<ResetPasswordPage>
    implements ResetPasswordIMvpView{
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _oldPasswordController =
  TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  bool _clickable = false;

  @override
  void initState() {
    super.initState();
    _confirmPasswordController.addListener(_verify);
    _newPasswordController.addListener(_verify);
    _oldPasswordController.addListener(_verify);

  }

  @override
  void dispose() {
    _confirmPasswordController.removeListener(_verify);
    _newPasswordController.removeListener(_verify);
    _oldPasswordController.removeListener(_verify);
    _confirmPasswordController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    _nodeText3.dispose();
    super.dispose();
  }

  void _verify() {
    final String confirmPassword = _confirmPasswordController.text;
    final String newPassword = _newPasswordController.text;
    final String oldPassword = _oldPasswordController.text;
    bool clickable = true;
    if (oldPassword.isEmpty || oldPassword.length < 6) {
      clickable = false;
    }
    if (newPassword.isEmpty || newPassword.length < 6) {
       clickable = false;
    }
    if (confirmPassword.isEmpty || confirmPassword != newPassword) {
      clickable = false;
    }
    if(!HelperUtils.isPasswordCompliant(newPassword)){
      clickable = false;
    }

    if(mounted && clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: "",
        ),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1, _nodeText2,_nodeText3]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Text(
        AppLocalizations.of(context).setAppPIN,
        style: TextStyles.textBold26,
      ),
      Gaps.vGap12,
      Text(
        AppLocalizations.of(context).setAppPINDescription,
        style: TextStyles.textSize12,
      ),
      Gaps.vGap32,
      MyTextField(
        iconName: 'password',
        focusNode: _nodeText3,
        isInputPwd: true,
        controller: _oldPasswordController,
        maxLength: 6,
        keyboardType: TextInputType.numberWithOptions(),
        hintText: AppLocalizations.of(context).inputOldPINHint,
        labelText: AppLocalizations.of(context).inputOldPINHint,
      ),
      Gaps.vGap8,
      InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                AppLocalizations.of(context).hint,
                style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.app_main,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        onTap: () =>_showHint(),
      ),
      Gaps.vGap4,
      MyTextField(
        iconName: 'password',
        focusNode: _nodeText1,
        isInputPwd: true,
        controller: _newPasswordController,
        maxLength: 6,
        keyboardType: TextInputType.numberWithOptions(),
        hintText: AppLocalizations.of(context).inputNewPINHint,
        labelText: AppLocalizations.of(context).inputNewPINHint,

      ),
      Gaps.vGap8,
      MyTextField(
        iconName: 'password',
        focusNode: _nodeText2,
        isInputPwd: true,
        controller: _confirmPasswordController,
        maxLength: 6,
        keyboardType: TextInputType.numberWithOptions(),
        hintText: AppLocalizations.of(context).inputConfirmPINHint,
        labelText: AppLocalizations.of(context).inputConfirmPINHint,

      ),
      Gaps.vGap24,
      MyButton(
        onPressed: _clickable ? _initiate : null,
        text: AppLocalizations.of(context).confirm,
      )
    ];
  }

  void _showHint(){
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: "",
            title: AppLocalizations.of(context).hint.toUpperCase(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppLocalizations.of(context).pinMustContain,
                  textAlign: TextAlign.justify),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }

  void _initiate() async {
    var newPassword = _newPasswordController.text;
    var oldPassword = _oldPasswordController.text;

    var response = await presenter.resetPassword(oldPassword, newPassword);
    if (response.isSuccess && response != null){
      Toast.show(AppLocalizations.of(context).pinChangedSuccessfully);
      _logOut();
    }
  }
  void _logOut() async {
    String phone = SpUtil.getString(Constant.phone);
    String fcmId = SpUtil.getString(Constant.fcmDeviceId);
    await SpUtil.clear();
    CachedAllLinkedAccounts().clear();
    SpUtil.putString(Constant.phone, phone);
    SpUtil.putString(Constant.fcmDeviceId, fcmId);
    Navigator.pushNamedAndRemoveUntil(context, AuthRouter.loginPage,(Route<dynamic> route) => false);
  }
  @override
  ResetPasswordPresenter createPresenter() => ResetPasswordPresenter();

  @override  bool get wantKeepAlive => true;
}
