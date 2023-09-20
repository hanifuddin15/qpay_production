import 'dart:async';

import 'package:cron/cron.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:qpay/Events/token_expire_event.dart';
import 'package:qpay/Events/token_refresh_event.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/net/contract/token_vm.dart';
import 'package:qpay/net/push_notification_service.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/home_router.dart';
import 'package:qpay/static_data/app_event_bus.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/utils/device_utils.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/views/home/accounts/accounts_page.dart';
import 'package:qpay/static_data/home_data.dart';
import 'package:qpay/views/home/more_options_page.dart';
import 'package:qpay/providers/home_provider.dart';
import 'package:qpay/views/home/transaction_statement/transactions_page.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/views/login/login_page_presenter.dart';
import 'package:qpay/widgets/double_tap_back_exit_app.dart';
import '../../locator.dart';
import 'dashboard/dashboard_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Widget> _pageList;
  final PageController _pageController = PageController();
  final _presenter = new LoginPagePresenter();
  final provider = HomeProvider();
  final homeTitles = HomeTitles();
  final homeIcons = HomeImages();
  List<BottomNavigationBarItem> _list;
  int _selectedIndex = 0;
  final _deviceInfoProvider = DeviceInfoProvider();
  Map<String, dynamic> _deviceData;
  StreamSubscription<TokenRefreshEvent> _tokenEvent;
  StreamSubscription<TokenExpireEvent> _expiryEvent;
  Timer _timer = Timer(const Duration(seconds: 60), null);
  bool isScanEnable = true;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initData();
   /* _scheduleJob();*/
    _deviceInfoProvider.addListener(() {
      _deviceData = _deviceInfoProvider.deviceData;
    });

    _expiryEvent = AppEventManager().eventBus.on<TokenExpireEvent>().listen((event) {
      _onTokenExpired();
    });
    _tokenEvent = AppEventManager().eventBus.on<TokenRefreshEvent>().listen((event) async {
      await _onTokenRefresh(event);
    });

  }

  void _initializeTimer() {
    if (_timer != null)_timer.cancel();
    _timer = Timer(const Duration(seconds: 60), _logOut);
  }
    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _initializeTimer();
    }
    if (state == AppLifecycleState.resumed) {
      if(_timer != null) _timer.cancel();
    }


  }

  _onTokenRefresh(TokenRefreshEvent event) async {
    await _refreshSession();
  }

  _onTokenExpired(){
    Toast.show('Please sign in again');
    _logOut();
  }

  Future _refreshSession() async {
    var refreshToken = SpUtil.getString(Constant.refreshToken);//StaticKeyValueStore().get(Constant.refreshToken);
    var deviceId = SpUtil.getString(Constant.fcmDeviceId)!=''?SpUtil.getString(Constant.fcmDeviceId):_deviceData[DeviceInfoProvider.deviceId];
    var refreshSessionResult = await _presenter.refreshSession(refreshToken,deviceId);
    if (refreshSessionResult  != null) {
      _saveTokens(refreshSessionResult);
    }else{
      _logOut();
    }
  }

  void _saveTokens(TokenViewModel result) {
    SpUtil.putString(Constant.accessToken, result.token);
    SpUtil.putString(Constant.refreshToken, result.refreshToken);
    SpUtil.putString(Constant.accessTokenExpiry, result.expiryTime.toString());
  }

  void _logOut() async {
    try {
    NavigatorUtils.popUntil(context, AuthRouter.loginPage);

    }catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    if(_timer != null) _timer.cancel();
    if (_expiryEvent != null) {
      _expiryEvent.cancel();
    }
    if (_tokenEvent != null) {
      _tokenEvent.cancel();
    }
    _deviceInfoProvider.dispose();
    WidgetsBinding.instance.removeObserver(this);
    AppEventManager().dispose();
    super.dispose();
  }

  void initData() {
    _pageList = [
      DashboardPage(),
      TransactionsPage(),
      AccountsPage(),
      MoreOptionsPage(),
    ];
  }

  List<BottomNavigationBarItem> _buildBottomAppBarItem() {
    if (_list == null) {
      var _tabIcons = [
        new Icon(Icons.home),
        new Icon(Icons.swap_horiz),
        new Icon(Icons.account_balance_wallet),
        new Icon(Icons.menu),
      ];

      _list = List.generate(4, (i) {
        return BottomNavigationBarItem(
            icon: _tabIcons[i],
            label: homeTitles.navigationTitles[i]);
      });
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => provider,
      child: DoubleTapBackExitApp(
        child: SafeArea(
          child: Scaffold(
              key: _scaffoldKey,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.white,
                child: ImageIcon(
                  AssetImage(
                    "assets/images/dashboard/qrcode.png",
                  ),
                  color: Colours.app_main,
                  size: 36.0,
                ),
                onPressed: isScanEnable? () {
                  if(mounted) {
                    setState(() {
                      isScanEnable = false;
                      NavigatorUtils.push(context, HomeRouter.scanQrCode);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        setState(() {
                          isScanEnable = true;
                        });
                      });
                    });
                  }
                }:(){
                },
              ),
              bottomNavigationBar: Consumer<HomeProvider>(
                builder: (_, providers, __) {
                  return BottomAppBar(
                    shape: CircularNotchedRectangle(),
                    notchMargin: 4.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          hoverColor: Colors.white30,
                          child: Padding(
                            padding: EdgeInsets.only(left: 28.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                      "assets/images/home.png",
                                    ),
                                    color: _selectedIndex == 0 ? Theme.of(context).primaryColor : Colours.unselected_item_color,
                                    size: 28.0,
                                  ),
                                  Text(
                                    homeTitles.navigationTitles[0],
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: _selectedIndex == 0
                                            ? Theme.of(context).primaryColor
                                            : Colours.unselected_item_color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            _pageController.jumpToPage(0);
                            onTabTapped(0);
                          },
                        ),
                        InkWell(
                          hoverColor: Colors.white30,
                          child: Padding(
                            padding: EdgeInsets.only(right: 28.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                      "assets/images/transactions.png",
                                    ),
                                    color: _selectedIndex == 1 ? Theme.of(context).primaryColor : Colours.unselected_item_color,
                                    size: 28.0,
                                  ),
                                  Text(
                                    homeTitles.navigationTitles[1],
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: _selectedIndex == 1
                                            ? Theme.of(context).primaryColor
                                            : Colours.unselected_item_color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            _pageController.jumpToPage(1);
                            onTabTapped(1);
                          },
                        ),
                        InkWell(
                          hoverColor: Colors.white30,
                          child: Padding(
                            padding: EdgeInsets.only(left: 28.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                      "assets/images/account.png",
                                    ),
                                    color: _selectedIndex == 2 ? Theme.of(context).primaryColor : Colours.unselected_item_color,
                                    size: 28.0,
                                  ),
                                  Text(
                                    homeTitles.navigationTitles[2],
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: _selectedIndex == 2
                                            ? Theme.of(context).primaryColor
                                            : Colours.unselected_item_color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            _pageController.jumpToPage(2);
                            onTabTapped(2);
                          },
                        ),
                        InkWell(
                          hoverColor: Colors.white30,
                          child: Padding(
                            padding: EdgeInsets.only(right: 28.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                      "assets/images/more.png",
                                    ),
                                    color: _selectedIndex == 3 ? Theme.of(context).primaryColor : Colours.unselected_item_color,
                                    size: 28.0,
                                  ),
                                  Text(
                                    homeTitles.navigationTitles[3],
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: _selectedIndex == 3
                                            ? Theme.of(context).primaryColor
                                            : Colours.unselected_item_color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            _pageController.jumpToPage(3);
                            onTabTapped(3);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: _pageList,
                physics: const NeverScrollableScrollPhysics(),
              )),
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    provider.value = index;
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;

      ///call your PageController.jumpToPage(index) here too, if needed
    });
  }
/*  void _scheduleJob() {
    final cron = Cron();
    cron.schedule(Schedule.parse(Constant.tokenRefreshInterval), () async {
      await _refreshSession();
    });
  }*/
}
