import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/net/contract/notification_count_vm.dart';
import 'package:qpay/net/contract/profile_vm.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/home_router.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/home/dashboard/dashboard_presenter.dart';
import 'package:qpay/providers/dashboard_provider.dart';
import 'package:qpay/static_data/dashboard_data.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/utils/theme_utils.dart';
import 'package:qpay/views/shared/bill_receipt_page.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/pin_input_dialog.dart';
import 'package:qpay/widgets/profile_error_widget.dart';
import 'package:qpay/widgets/load_image.dart';
import 'dashboard_iview.dart';
import '../../../routers/dashboard_router.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with
        BasePageMixin<DashboardPage, DashboardPagePresenter>,
        AutomaticKeepAliveClientMixin<DashboardPage>
    implements DashboardIMvpView {
  final titles = DashboardTitles();
  final images = DashboardImages();
  final provider = DashboardProvider();
  int _notificationCount = 0;
  bool _isInComplete;
  bool scrollVisible = true;
  final List<String> offers = [
    "assets/images/dashboard/stkr_txn_to_bKash.png",
    "assets/images/dashboard/stkr_card_bill.png",
    "assets/images/dashboard/stkr_cash_by_code.png",
  ];
  bool isMainEnable = true;
  bool isOptionEnable = true;
  bool isNotificationEnable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preCacheImage();
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  void _preCacheImage() {
    images.serviceImages.forEach((element) {
      precacheImage(ImageUtils.getAssetImage(element), context);
    });

    images.mainMenuImages.forEach((element) {
      precacheImage(ImageUtils.getAssetImage(element), context);
    });
  }

  void setDialVisible(bool value) {
    setState(() {
      scrollVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Color _iconColor = ThemeUtils.getIconColor(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.dashboard_bg,
        body: MyScrollView(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 135.5,
              decoration: new BoxDecoration(
                color: Colours.dashboard_top_bg,
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width * .5, 85.0)),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                        child: Image.asset(
                          "assets/images/logo_white.png",
                          scale: 12.0,
                        ),
                      ),
                    ],
                  )),
                  Positioned(
                      right: MediaQuery.of(context).size.width*.02 ,
                      child: InkWell(
                        onTap:isNotificationEnable? () {
                          if(mounted) {
                            setState(() {
                              isNotificationEnable = false;
                              NavigatorUtils.push(context, HomeRouter.notifications);
                              _notificationCount = 0;
                              Future.delayed(const Duration(milliseconds: 500), () {
                                setState(() {
                                  isNotificationEnable = true;
                                });
                              });
                            });
                          }
                        }:(){
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Stack(
                            children: [
                              Image.asset(
                              "assets/images/dashboard/notification.png",
                              color: Colours.app_main,
                              scale: 3,
                            ),
                              Visibility(
                                visible: _notificationCount != 0?true :false,
                                child: Positioned(
                                  right: 0,
                                  child: new Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: new Text(
                                      '$_notificationCount',
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                          ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Gaps.vGap8,
            Gaps.line,
            _MenuMainFunctionalModule(
              data: titles.mainMenuTitles,
              image: images.mainMenuImages,
              onItemClick: isMainEnable? (index) {
                if(mounted) {
                  setState(() {
                    isMainEnable = false;
                    _performMenuPressedAction(index, context);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        isMainEnable = true;
                      });
                    });
                  });
                }
              }:(index){
              },
            ),
            Gaps.line,
            Gaps.vGap8,
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 1.0,
                color: Colors.white,
                child: Column(
                  children: [
                    Gaps.vGap12,
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Recharge & Bill Payments",
                        style: TextStyle(
                            fontSize: Dimens.font_sp16,
                            fontWeight: FontWeight.bold,
                            color: Colours.text,
                            /*fontFamily: 'Helvetica'*/),
                      ),
                    ),
                    _MenuOptionsFunctionalModule(
                      data: titles.servicesTitles,
                      image: images.serviceImages,
                      onItemClick: isOptionEnable? (index) {
                        if(mounted) {
                          setState(() {
                            isOptionEnable = false;
                            _performFeaturePressedAction(index, context);
                            Future.delayed(const Duration(milliseconds: 500), () {
                              setState(() {
                                isOptionEnable = true;
                              });
                            });
                          });
                        }
                      }:(index){
                      },
                    ),
                  ],
                ),
              ),
            ),
            Gaps.line,
            Column(
              children: [
                Gaps.vGap8,
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Deals & Offers",
                    style: TextStyle(
                        fontSize: Dimens.font_sp16,
                        fontWeight: FontWeight.bold,
                        color: Colours.text,
                        fontFamily: 'Helvetica'),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.35,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Image.asset(
                            offers[index],
                            fit: BoxFit.fill,
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorsView(List<ProfileErrorViewModel> errors) {
    if (errors.isEmpty) return Container();
    var errorWidgets = <ProfileErrorWidget>[];
    errors.forEach((element) {
      errorWidgets.add(ProfileErrorWidget(element.details, () {
        _handleProfileError(element.code);
      }));
    });
    return Container(
     /* height: MediaQuery.of(context).size.height*.15,*/
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: errorWidgets,
      ),
    );
  }

  void _showSuccessDialog(List<ProfileErrorViewModel> errors) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText:'',
            cancelText: AppLocalizations.of(context).skip.toUpperCase(),
            title: AppLocalizations.of(context).pleaseCompleteYourProfile.toUpperCase(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildErrorsView(errors),
            ),
            onBackPressed:() {
              NavigatorUtils.goBack(context);
            },
            onPressed:() {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }

  void _performMenuPressedAction(int index, BuildContext context) {
    if (_isInComplete) {
      _showSuccessDialog(provider.errors);
      // showSnackBar(AppLocalizations.of(context).pleaseCompleteYourProfile);
      return;
    }

    switch (index) {
      case 0:
        NavigatorUtils.push(context, DashboardRouter.addCardPage);
        break;
      case 1:
        NavigatorUtils.push(context, DashboardRouter.addBeneficiary);
        break;
      case 2:
        NavigatorUtils.push(context, DashboardRouter.cashOutTokenCreatePage);
        break;
    }
  }

  void _performFeaturePressedAction(int index, BuildContext context) {
    if (_isInComplete) {
      _showSuccessDialog(provider.errors);
      return;
    }

    switch (index) {
      case 0:
        NavigatorUtils.push(context, DashboardRouter.mobileRechargePage);
        break;
      case 1:
        NavigatorUtils.push(context, DashboardRouter.sendMoneyPage);
        break;
      case 2:
        NavigatorUtils.push(context, DashboardRouter.cardBillPaymentPage);
        break;
      case 3:
        NavigatorUtils.push(context, DashboardRouter.walletTransfer);
        break;
      case 4:
        NavigatorUtils.push(context, DashboardRouter.billPayment);
        break;
      case 5:
        NavigatorUtils.push(context, DashboardRouter.cvvChange);
        break;
    }
  }

  @override
  DashboardPagePresenter createPresenter() {
    return DashboardPagePresenter();
  }

  @override
  bool get isAccessibilityTest => false;

  String _getAppropriateGreeting() {
    var time = DateTime.now().hour;
    if (time > 3 && time < 12) return AppLocalizations.of(context).goodMorning;
    if (time >= 12 && time < 16)
      return AppLocalizations.of(context).goodAfternoon;
    if (time >= 16 && time < 22)
      return AppLocalizations.of(context).goodEvening;

    return AppLocalizations.of(context).whatsUp;
  }

  @override
  void setUser(ProfileViewModel user) {
    provider.setUser(user);
    provider.setErrors(user.errors);
    setState(() {
      _isInComplete = user.errors.length > 0;
      if(_isInComplete) _showSuccessDialog(provider.errors);
    });
  }

  @override
  bool get wantKeepAlive => true;

  void _handleProfileError(int code) {
    if (code == 102) {
      NavigatorUtils.push(context, AuthRouter.registerEmailVerificationPage);
    } else if (code == 104) {
      NavigatorUtils.push(context, AuthRouter.registerImageVerificationPage);
    }else if (code == 101) {
      NavigatorUtils.push(context, AuthRouter.registerPage);
    }
  }

  void _requestApproval() async {
    var response = await presenter.requestApproval();
    if (response != null) {
      showErrorDialog(AppLocalizations.of(context).approvalRequested);
      presenter.loadProfile();
    }
  }

  void _onPinInserted(String pin) async {
    if (pin == null || pin.isEmpty || pin.length < 6) {
//      Toast.show(AppLocalizations.of(context).invalidVerificationCode);
      return;
    }
  }

  @override
  void setNotificationCount(NotificationCountViewModel notificationCountViewModel) {
    setState(() {
      _notificationCount = notificationCountViewModel.count ;
    });
  }
}

class _MenuOptionsFunctionalModule extends StatelessWidget {
  const _MenuOptionsFunctionalModule({
    Key key,
    this.onItemClick,
    @required this.data,
    @required this.image,
  }) : super(key: key);

  final Function(int index) onItemClick;
  final List<String> data;
  final List<String> image;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(4),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
      ),
      itemCount: data.length,
      itemBuilder: (_, index) {
        return InkWell(
          // behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadAssetImage('${image[index]}', height: 36.0, width: 36.0),
              Gaps.vGap8,
              Text(
                data[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Helvetica'),
              )
            ],
          ),
          onTap: () {
            onItemClick(index);
          },
        );
      },
    );
  }
}

class _MenuMainFunctionalModule extends StatelessWidget {
  const _MenuMainFunctionalModule({
    Key key,
    this.onItemClick,
    @required this.data,
    @required this.image,
  }) : super(key: key);

  final Function(int index) onItemClick;
  final List<String> data;
  final List<String> image;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(4),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.18,
      ),
      itemCount: data.length,
      itemBuilder: (_, index) {
        return InkWell(
          // behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoadAssetImage('${image[index]}',
                    height: 36.0, width: 36.0),
              ),
              Gaps.vGap8,
              Text(
                data[index],
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colours.text,
                    fontFamily: 'Helvetica'),
              )
            ],
          ),
          onTap: () {
            onItemClick(index);
          },
        );
      },
    );
  }
}
