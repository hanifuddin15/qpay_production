import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:otp_count_down/otp_count_down.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/views/login/login_page_presenter.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/routers.dart';
import 'package:qpay/utils/device_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';
import 'login_iview.dart';

class DeviceChangePage extends StatefulWidget {
  @override
  _DeviceChangeViewState createState() => _DeviceChangeViewState();
}

class _DeviceChangeViewState extends State<DeviceChangePage>
    with
        BasePageMixin<DeviceChangePage, LoginPagePresenter>,
        AutomaticKeepAliveClientMixin<DeviceChangePage>
    implements LoginIMvpView {
  final TextEditingController _pinPutController =
      TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _clickable = false;
  final _deviceInfoProvider = DeviceInfoProvider();
  Map<String, dynamic> _deviceData;
  String _countDown;
  OTPCountDown _otpCountDown;
  int _otpTimeInMS = 3*60*1000;
  bool _resendButtonEnable = false;
  @override
  void initState() {
    _startCountDown();
    super.initState();
    _deviceInfoProvider.addListener(() {
      _deviceData = _deviceInfoProvider.deviceData;
    });
  }

  @override
  void dispose() {
    _otpCountDown.cancelTimer();
    _deviceInfoProvider.dispose();
    super.dispose();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colours.text),
      borderRadius: BorderRadius.circular(15.0),
    );
  }
  void _startCountDown() {
    _otpCountDown = OTPCountDown.startOTPTimer(
      timeInMS: _otpTimeInMS,
      currentCountDown: (String countDown) {
        _countDown = countDown;
        setState(() {});
      },
      onFinish: () {
        showSnackBar("OTP validation time end!");
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).insertOtp.toUpperCase(),
        ),
        body: MyScrollView(
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
                            height:MediaQuery.of(context).size.height*.15,
                            width: MediaQuery.of(context).size.width*.2,
                          ),
                        ),
                        Gaps.vGap8,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Enter your OTP code",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0,fontFamily: 'Inter'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gaps.vGap8,
              Container(
                color: Colors.white,
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(20.0),
                child: PinPut(
                  fieldsCount: 6,
                  autofocus: true,
                  onSubmit: (String pin) => _changeDevice(pin),
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colours.app_main.withOpacity(.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:'Your OTP validation will end in ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:15,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: _countDown??'',
                          style: TextStyle(
                            color: Colours.app_main,
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:' minutes',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ];
  }

  void _changeDevice(String pin) async {
    //change device here
    var phoneNumber = SpUtil.getString(Constant.phone);
    var password = SpUtil.getString(Constant.password);
    var deviceId = (SpUtil.getString(Constant.fcmDeviceId)!=''||SpUtil.getString(Constant.fcmDeviceId)!=null)?SpUtil.getString(Constant.fcmDeviceId):_deviceData[DeviceInfoProvider.deviceId];
    var deviceChangeResponse = await presenter.changeDevice(
        phoneNumber,
        pin,
        deviceId,
        _deviceData[DeviceInfoProvider.deviceName]);

    if (deviceChangeResponse != null) {
      var loginResponse = await presenter.userLogin(
        phoneNumber,
        password,
        deviceId,
        _deviceData[DeviceInfoProvider.deviceName],
        _deviceData[DeviceInfoProvider.deviceVersion],
        (code, msg) {},
      );

      if (loginResponse != null) {
        SpUtil.putString(Constant.accessToken, loginResponse.token);
        SpUtil.putString(Constant.refreshToken, loginResponse.refreshToken);
        NavigatorUtils.push(context, Routes.home,
            replace: true, clearStack: true);
      }
    }
  }

  @override
  LoginPagePresenter createPresenter() {
    return LoginPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;
}
