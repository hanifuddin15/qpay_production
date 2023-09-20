import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/providers/nid_parse_information_state_provider.dart';
import 'package:qpay/providers/nid_update_status_provider.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/routers.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/my_step_indicator.dart';
import 'package:qpay/widgets/text_field.dart';
import '../../routers/auth_router.dart';
import 'register_iview.dart';
import 'register_page_presenter.dart';
import '../../providers/user_registration_state_provider.dart';

class RegisterVerificationPage extends StatefulWidget {
  @override
  _RegisterVerificationPageState createState() => _RegisterVerificationPageState();
}

class _RegisterVerificationPageState extends State<RegisterVerificationPage>
    with
        BasePageMixin<RegisterVerificationPage, RegisterPagePresenter>,
        AutomaticKeepAliveClientMixin<RegisterVerificationPage>
    implements RegisterIMvpView {
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _clickable = false;
  UserRegistrationStateProvider registrationDataHolder = UserRegistrationStateProvider();
  NidUpdateDataHolder nidUpdateDataHolder = NidUpdateDataHolder();
  NidParseInformationProvider nidParseInformationProvider = NidParseInformationProvider();

  @override
  void initState() {
    super.initState();
    _confirmPasswordController.addListener(_verify);
    _passwordController.addListener(_verify);
    registrationDataHolder.addListener(_onRegistrationDataChanged);
  }

  @override
  void dispose() {
    _confirmPasswordController.removeListener(_verify);
    _passwordController.removeListener(_verify);
    _passwordController.dispose();
    _nodeText2.dispose();
    _confirmPasswordController.dispose();
    _nodeText1.dispose();
    registrationDataHolder.clearVerificationData();
    super.dispose();
  }

  void _onRegistrationDataChanged() {
    _verify();
  }

  Future<bool> _onBack(){
    return showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: AppLocalizations.of(context).cancel,
            title: 'Are you sure?',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Do you want to exit from this page? All your data will be lost!",
                    style: TextStyles.textSize12,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            onPressed: () {
              NavigatorUtils.push(context, AuthRouter.loginPage,
                  replace: true, clearStack: true);
            },
            onBackPressed: (){
              NavigatorUtils.goBack(context);
            },
          );
        }) ??
        false;
  }

  void _verify() {
    final String confirmPassword = _confirmPasswordController.text;
    final String password = _passwordController.text;
    registrationDataHolder.setPersonalCredentialData(password,confirmPassword);

    bool clickable = true;

    if (confirmPassword.isEmpty || confirmPassword.length < 6) {
      clickable = false;
    }

    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      clickable = false;
    }
    if(!HelperUtils.isPasswordCompliant(password)){
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
    return WillPopScope(
      onWillPop: _onBack,
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(
            centerTitle: AppLocalizations.of(context).registerUser,
          ),
          body: MyScrollView(
            keyboardConfig: Utils.getKeyboardActionsConfig(
                context, <FocusNode>[_nodeText1, _nodeText2]),
            crossAxisAlignment: CrossAxisAlignment.start,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            children: _buildBody(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Gaps.vGap32,
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
        key: const Key('password'),
        iconName: 'password',
        focusNode: _nodeText1,
        controller: _passwordController,
        isInputPwd: true,
        maxLength: 6,
        keyboardType: TextInputType.numberWithOptions(),
        hintText: AppLocalizations.of(context).inputPINHint,
        labelText: AppLocalizations.of(context).inputPINHint,
      ),

      Gaps.vGap8,
      MyTextField(
        key: const Key('confirmPassword'),
        iconName: 'password',
        focusNode: _nodeText2,
        controller: _confirmPasswordController,
        isInputPwd: true,
        maxLength: 6,
        keyboardType: TextInputType.numberWithOptions(),
        hintText: AppLocalizations.of(context).confirmPINHint,
        labelText: AppLocalizations.of(context).confirmPINHint,
      ),

      Gaps.vGap32,
      MyButton(
        key: const Key('register'),
        onPressed: _clickable ? _register : null,
        text: AppLocalizations.of(context).register,
      ),
      Gaps.vGap50,
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

  void _register() async {
    var data = registrationDataHolder.getUserData();
    if (data != null ) {
      if(_passwordController.text == _confirmPasswordController.text) {
        var response = await presenter.registerUser(
            data);
        if (response.isSuccess ) {
          SpUtil.putString(Constant.phone, data.mobileNumber);
          _showSuccessDialog();
        }
      }else{
        Toast.show("Password did not matched");
      }
    }
  }

  @override
  RegisterPagePresenter createPresenter() {
    return RegisterPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;

  void _showSuccessDialog() {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).login,
            cancelText: "",
            title: AppLocalizations.of(context).registrationComplete,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppLocalizations.of(context).welcomeOnBoard,
                  textAlign: TextAlign.center),
            ),
            onPressed: () {
              NavigatorUtils.push(context, AuthRouter.loginPage,
                  replace: true, clearStack: true);
            },
          );
        });
  }
}
