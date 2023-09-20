import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/notification_vm.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/views/notifications/notification_iview.dart';
import 'package:qpay/views/notifications/notification_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';

class NotificationPage extends StatefulWidget{
  @override
  _NotificationPageState createState() => _NotificationPageState();

}

class _NotificationPageState extends State<NotificationPage>
    with
        BasePageMixin<NotificationPage, NotificationPresenter>,
        AutomaticKeepAliveClientMixin<NotificationPage>
    implements NotificationIMvpView{

  int _page = 1;
  int _limit = 10;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List<NotificationViewModel> _notifications = <NotificationViewModel>[];

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  Future<void> _loadMore() async {
    /*if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1

      var response = await presenter.loadNotifications(_page, true, _limit);
      if(response != null){
        _notifications.addAll(response);
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }*/

    if(_controller.position.pixels == _controller.position.maxScrollExtent){
      _page += 1; // Increase _page by 1
      await presenter.loadNotifications(_page, true, _limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(
            centerTitle: AppLocalizations.of(context).notifications,
          ),
          body: Column(
            children: [
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: _notifications.length,
                    itemBuilder: (_, index) => Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: ListTile(
                        horizontalTitleGap: 0.0,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: Dimens.gap_dp4),
                          child: Text(_notifications[index].title,textAlign: TextAlign.justify,style: TextStyle(color: Colours.app_main,fontWeight: FontWeight.bold),),
                        ),
                        subtitle: Text(_notifications[index].message,textAlign: TextAlign.justify,),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
    );
  }

  @override
  NotificationPresenter createPresenter() {
   return NotificationPresenter(_page, true, _limit);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void setNotifications(List<NotificationViewModel> notifications) {
    setState(() {
      _isFirstLoadRunning = true;
      _notifications.addAll(notifications) ;
      _isFirstLoadRunning = false;
    });
  }
}