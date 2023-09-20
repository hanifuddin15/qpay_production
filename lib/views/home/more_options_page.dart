import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/profile_vm.dart';
import 'package:qpay/providers/dashboard_provider.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/home_router.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/static_data/dashboard_data.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/home/profile/profile_veiw_iview.dart';
import 'package:qpay/views/home/profile/profile_view_presenter.dart';
import 'package:qpay/widgets/line_widget.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dashboard/dashboard_iview.dart';
import 'dashboard/dashboard_presenter.dart';

class MoreOptionsPage extends StatefulWidget {
  @override
  _MoreOptionsPageState createState() => _MoreOptionsPageState();
}

class _MoreOptionsPageState extends State<MoreOptionsPage>
    with
        BasePageMixin<MoreOptionsPage, ProfileViewPresenter>,
        AutomaticKeepAliveClientMixin<MoreOptionsPage>
    implements ProfileViewIMvpView {
  final line = LineWidget();
  final images = DashboardImages();
  final provider = DashboardProvider();
  bool _isInComplete;
  String _imageUrl = '';
  final ImagePicker _picker = ImagePicker();
  NewVersion newVersion;
  PackageInfo packageInfo;
  String appName;
  String packageName;
  String version;
  String buildNumber ;
  bool isChangePinEnable = true;
  bool isLimitEnable = true;
  bool isFeeCalEnable = true;
  bool isFaqEnable = true;
  bool isSupportEnable = true;
  bool isPrivacyEnable = true;
  @override
  void initState() {
    super.initState();
    _imageUrl = provider.user?.imageUrl ?? '';
    _getPackageInfo();

  }

  @override
  void dispose(){
    super.dispose();
  }

  _getPackageInfo() async{
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: MyScrollView(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildBody,
      ),
    ));
  }

  List<Widget> get _buildBody => [
        Container(
          // height: MediaQuery.of(context).size.height*.35,
          width: MediaQuery.of(context).size.width,
          color: Colours.text_gray,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 100.0,
                    backgroundImage: _imageUrl != ''
                        ? NetworkImage(_imageUrl)
                        : ImageUtils.getAssetImage(images.placeHolderImages[1]),
                    onBackgroundImageError: (dynamic, stacktrace) {},
                  ),
                  Positioned(
                      bottom: 0,
                      right: -5,
                      child: RawMaterialButton(
                        onPressed: () {
                          _showProminantAlert();
                        },
                        elevation: 2.0,
                        fillColor: Color(0xFFF5F6F9),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colours.app_main,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.gap_dp12, vertical: Dimens.gap_dp12),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: Colors.black54, style: BorderStyle.none),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(10.0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colours.app_main)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "View profile".toUpperCase(),
                        style: TextStyle(
                            fontSize: Dimens.font_sp14, color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _viewProfile();
                  },
                ),
              ),
            ],
          ),
        ),
        Gaps.line,
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.lock,
                color: Colours.app_main,
              ),
              Gaps.hGap12,
              Text(
                AppLocalizations.of(context).setAppPIN,
                style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16),
              ),
            ],
          ),
          onPressed: isChangePinEnable?() {
            if(mounted) {
              setState(() {
                isChangePinEnable = false;
                _resetPassword();
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    isChangePinEnable = true;
                  });
                });
              });
            }
          }:(){
          },
        ),
        Gaps.vGap8,
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.analytics,
                color: Colours.app_main,
              ),
              Gaps.hGap12,
              Text(
                "Limit",
                style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16),
              ),
            ],
          ),
          onPressed: isLimitEnable? () {
            if(mounted) {
              setState(() {
                isLimitEnable = false;
                _txnLimit();
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    isLimitEnable = true;
                  });
                });
              });
            }
          }:(){
          },
        ),
        Gaps.vGap8,
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.calculate,
                color: Colours.app_main,
              ),
              Gaps.hGap12,
              Text(
                "Fee Calculator",
                style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16),
              ),
            ],
          ),
          onPressed: isFeeCalEnable? () {
            if(mounted){
              setState(() {
                isFeeCalEnable = false;
                _txnFees();
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    isFeeCalEnable = true;
                  });
                });
              });
            }
          }:(){
          },
        ),
        Gaps.vGap8,
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.question_answer,
                color: Colours.app_main,
              ),
              Gaps.hGap12,
              Text(
                AppLocalizations.of(context).faqs,
                style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16),
              ),
            ],
          ),
          onPressed: isFaqEnable?() {
            if(mounted){
              setState(() {
                isFaqEnable=false;
                _faqs();
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    isFaqEnable = true;
                  });
                });
              });
            }
          }:(){
          },
        ),
        Gaps.vGap8,
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colours.app_main,
              ),
              Gaps.hGap12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "About",
                    style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16),
                  ),
                ],
              ),
            ],
          ),
          onPressed: () {
            showAbout();
          },
        ),
        Gaps.vGap8,
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.live_help,
                color: Colours.app_main,
              ),
              Gaps.hGap12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Support",
                    style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16),
                  ),
                ],
              ),
            ],
          ),
          onPressed: isSupportEnable? () {
            if(mounted) {
              setState(() {
                isSupportEnable = false;
                _support();
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    isSupportEnable = true;
                  });
                });
              });
            }
          }:(){
          },
        ),
        Gaps.vGap8,
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.privacy_tip,
                color: Colours.app_main,
              ),
              Gaps.hGap12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    AppLocalizations.of(context).privacyPolicy,
                    style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16),
                  ),
                ],
              ),
            ],
          ),
          onPressed: isPrivacyEnable? () {
            if(mounted) {
              setState(() {
                isPrivacyEnable = false;
                _privacy();
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    isPrivacyEnable = true;
                  });
                });
              });
            }
          }:(){
          },
        ),
        Gaps.vGap8,
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.exit_to_app,
                color: Colours.app_main,
              ),
              Gaps.hGap12,
              Text(
                "Log out",
                style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16),
              ),
            ],
          ),
          onPressed: () {
            _logOut();
          },
        ),
      ];

  void showAbout(){
    showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: "",
            title: "",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Image.asset(
                      "assets/images/logo.png",
                      scale: 15.0,
                    ),
                  ),
                  Gaps.vGap16,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "App Name",
                          style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp12),
                        ),Text(
                          appName,
                          style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Gaps.vGap8,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Version",
                          style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp12),
                        ),Text(
                          version,
                          style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Gaps.vGap8,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Build Number",
                          style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp12),
                        ),Text(
                          buildNumber,
                          style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Gaps.vGap8,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Website",
                          style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp12),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'www.qpaybd.com.bd',
                            style: TextStyle(color: Colors.blueAccent,fontSize: Dimens.font_sp12,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () async{
                              var url = "https://qpaybd.com.bd";
                              if (!await launch(
                                url,
                                forceSafariVC: false,
                                forceWebView: false,
                                headers: <String, String>{'my_header_key': 'my_header_value'},
                              )) {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.vGap8,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Follow Us",
                          style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp12),
                        ),
                        InkWell(
                          onTap: () async{
                            var url = "https://www.facebook.com/Qpaysolutions";
                            if (!await launch(
                              url,
                              forceSafariVC: false,
                              forceWebView: false,
                              headers: <String, String>{
                                'my_header_key': 'my_header_value'
                              },
                            )) {
                              throw 'Could not launch $url';
                            }
                          },
                          child: LoadAssetImage('facebook',height: 24,),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }

  void _logOut() async {
    String phone = SpUtil.getString(Constant.phone);
    String fcmId = SpUtil.getString(Constant.fcmDeviceId);
    String refreshToken = SpUtil.getString(Constant.refreshToken);
    await SpUtil.clear();
    CachedAllLinkedAccounts().clear();
    CachedBanks().clear();
    /*CachedTransactionsLimit().clear();*/
    CachedTransactionsCategory().clear();
    CachedContact().clear();
    SpUtil.putString(Constant.phone, phone);
    SpUtil.putString(Constant.fcmDeviceId, fcmId);
    SpUtil.putString(Constant.refreshToken, refreshToken);
    Navigator.pushNamedAndRemoveUntil(
        context, AuthRouter.loginPage, (Route<dynamic> route) => false);
    /* NavigatorUtils.push(context, AuthRouter.loginPage,
        replace: true, clearStack: true);*/
  }

  void _dummyAction() {
    Toast.show("Not implemented yet!");
  }

  void _viewProfile() async {
    final result =
        await NavigatorUtils.pushAwait(context, HomeRouter.profileView);
  }

  void _resetPassword() {
    NavigatorUtils.push(context, HomeRouter.resetPasswordPage);
  }

  void _txnLimit() {
    NavigatorUtils.push(context, HomeRouter.txnLimit);
  }

  void _txnFees() {
    NavigatorUtils.push(context, HomeRouter.txnFees);
  }

  void _faqs() {
    NavigatorUtils.push(context, HomeRouter.faqs);
  }
  void _support() {
    NavigatorUtils.push(context, HomeRouter.support);
  }
  void _privacy() {
    NavigatorUtils.push(context, HomeRouter.privacy);
  }

  @override
  bool get isAccessibilityTest => false;

  @override
  void setUser(ProfileViewModel user) {
    provider.setUser(user);
    /* setState(() {
      _isInComplete = user.errors.length > 0;
    });*/
  }

  @override
  bool get wantKeepAlive => false;

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        var permission = Platform.isAndroid ? await Permission.storage.status : await Permission.photos.status;
                        if(permission == PermissionStatus.granted ) {
                          _imgFromGallery();
                        }
                        if(permission == PermissionStatus.denied){
                          var requested = Platform.isAndroid ? await Permission.storage.request() : await Permission.photos.request();
                          if(requested == PermissionStatus.granted){
                            _imgFromGallery();
                          }
                          if(requested == PermissionStatus.permanentlyDenied){
                            permission = requested;
                          }
                        }
                        if(permission == PermissionStatus.permanentlyDenied){
                          AppSettings.openAppSettings();
                        }
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                      }),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    XFile image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      _imageUpload(image.path);
    }
  }

  _imgFromCamera() async {
    var result =
        await NavigatorUtils.pushAwait(context, AuthRouter.faceVerification);
    if (result != null) {
      _imageUpload(result);
    }
    Navigator.of(context).pop();
  }

  _imageUpload(String imagePath) async {
    var response = await presenter.uploadProfileImage(imagePath);
    if (mounted && response != null) {
      setState(() {
        _imageUrl = response;
        provider.user?.imageUrl = _imageUrl;
      });
    }
  }

  @override
  ProfileViewPresenter createPresenter() => ProfileViewPresenter();

  Future<bool> _showProminantAlert(){
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: 'Agree',
            cancelText: 'Decline',
            title:'Privacy Alert',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Qpay Bangladesh collects and upload image data to enable feature to change your profile picture when the app in use.', textAlign: TextAlign.center,),
            ),
            onBackPressed:() {
              NavigatorUtils.goBack(context);
            },
            onPressed: (){
              NavigatorUtils.goBack(context);
              _showPicker(context);
            },
          );
        });
  }
}
