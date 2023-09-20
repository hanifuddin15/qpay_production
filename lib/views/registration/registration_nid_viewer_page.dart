import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/gender_vm.dart';
import 'package:qpay/providers/nid_parse_information_state_provider.dart';
import 'package:qpay/providers/nid_update_status_provider.dart';
import 'package:qpay/providers/user_registration_state_provider.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/routers.dart';
import 'package:qpay/static_data/dashboard_data.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/nid/nid_iview.dart';
import 'package:qpay/views/registration/register_iview.dart';
import 'package:qpay/views/registration/register_page_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

import '../../routers/home_router.dart';
import '../nid/nid_upload_presenter.dart';

class RegistrationNIDViewPage extends StatefulWidget{
  @override
  _RegistrationNIDViewPageState createState() => _RegistrationNIDViewPageState();
}

class _RegistrationNIDViewPageState extends State<RegistrationNIDViewPage>
    with BasePageMixin<RegistrationNIDViewPage,NidUploadPresenter>,
        AutomaticKeepAliveClientMixin<RegistrationNIDViewPage>
    implements NidIMvpView{
  final provider = NidParseInformationProvider();
  var dataHolder = new NidUpdateDataHolder();

  bool _clickable = false;
  final images = DashboardImages();


  File nidFrontImageFile;
  File nidBackImageFile;

  @override
  void initState() {
    super.initState();
    nidFrontImageFile = File(dataHolder.getData().nidFrontPath);
    nidBackImageFile = File(dataHolder.getData().nidBackPath);
  }

  @override
  void dispose() {
    super.dispose();
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
              NavigatorUtils.push(context, Routes.home,
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
    bool clickable = true;
    if(nidBackImageFile == null){
      clickable = false;
    }
    if(nidFrontImageFile== null){
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
            centerTitle: "Verify Information",
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildBottomNavigationBar(),
            ),
          ),
          body: MyScrollView(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildBody()],
          ),
        ),
      ),
    );
  }
  Widget _buildBottomNavigationBar() {
    return MyButton(
      key: const Key('next'),
      onPressed:_upload ,
      text: AppLocalizations.of(context).submit,
    );
  }
  Widget _buildBody() {
    final width = MediaQuery.of(context).size.width;
    var aspectRatio = 3 / 1.8;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.file(nidFrontImageFile,height: width/aspectRatio,width: width,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Captured NID card front image',style: TextStyle(fontSize: Dimens.font_sp22),),
          ],
        ),
        Image.file(nidBackImageFile,height: width/aspectRatio,width: width,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Captured NID card back image',style: TextStyle(fontSize: Dimens.font_sp22),),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _upload() async {
    var nidData = dataHolder.getData();
    var response = await presenter.uploadNid(nidData);
    if (response != null) {
      provider.setInformation(response);
      NavigatorUtils.push(context,AuthRouter.userInformationUpdatePage);
    }else{
      _showDialog();
    }
  }


  void _showDialog(){
    showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: "",
            title: "Error!",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Something went wrong while trying to process your NID information. Kindly recapture your NID images.",
                    style: TextStyles.textSize12,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            onPressed: () {
              dataHolder.setFrontImage(null);
              dataHolder.setBackImage(null);
              NavigatorUtils.push(context, HomeRouter.nidFrontUpdatePage,replace: true);
            },
          );
        });
  }

  @override
  NidUploadPresenter createPresenter() => NidUploadPresenter();
}