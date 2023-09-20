import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/profile_vm.dart';
import 'package:qpay/providers/dashboard_provider.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/dashboard_data.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/views/home/dashboard/dashboard_iview.dart';
import 'package:qpay/views/home/dashboard/dashboard_presenter.dart';
import 'package:qpay/views/home/profile/profile_veiw_iview.dart';
import 'package:qpay/views/home/profile/profile_view_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

class ProfileViewPage extends StatefulWidget{
  @override
  _ProfileViewPageState createState() => _ProfileViewPageState();

}

class _ProfileViewPageState extends State<ProfileViewPage>
    with
        BasePageMixin<ProfileViewPage, ProfileViewPresenter>,
        AutomaticKeepAliveClientMixin<ProfileViewPage>
    implements ProfileViewIMvpView{
  File _image;
  final images = DashboardImages();
  final provider = DashboardProvider();
  bool _isInComplete;
  String _imageUrl = '';

  @override
  void initState() {
    _imageUrl = provider.user?.imageUrl??'';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardProvider>(
      create: (_) => provider,
    child: SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).profile,
        ),
        body: MyScrollView(children: [_bodyBuilding()]),
      ),
    ),);
  }

  Widget _bodyBuilding(){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*.35,
            width: MediaQuery.of(context).size.width,
            color: Colours.text_gray,
            child: Stack(
              children: [
                Positioned(
                  // top:MediaQuery.of(context).size.height*.24,
                  //left: MediaQuery.of(context).size.width/2,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          // _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: 100.0,
                          backgroundImage: _imageUrl != '' ? NetworkImage(_imageUrl): ImageUtils.getAssetImage(images.placeHolderImages[1]),
                          onBackgroundImageError: (dynamic, stacktrace) {},
                        ),
                      ),
                    ),
                ),
                  ),
              ),
      ],
            ),
          ),
          Positioned(
            top:MediaQuery.of(context).size.height*.3 ,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                ),
                  elevation: 5.0,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gaps.vGap15,
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text("Name",style: TextStyle(color: Colours.app_main,fontSize: Dimens.font_sp10,fontWeight: FontWeight.bold),),
                                  Gaps.vGap4,
                                  Text(provider.user?.name??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp16,fontWeight: FontWeight.bold),),
                                ],
                            ),
                            Gaps.vGap10,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text("Mobile Number",style: TextStyle(color: Colours.app_main,fontSize: Dimens.font_sp10,fontWeight: FontWeight.bold),),
                                Gaps.vGap4,
                                Text(provider.user?.phoneNumber??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp16,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Gaps.vGap10,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text("Date of Birth",style: TextStyle(color: Colours.app_main,fontSize: Dimens.font_sp10,fontWeight: FontWeight.bold),),
                                Gaps.vGap4,
                                Text(provider.user?.dateOfBirth??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp16,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Gaps.vGap10,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text("National ID",style: TextStyle(color: Colours.app_main,fontSize: Dimens.font_sp10,fontWeight: FontWeight.bold),),
                                Gaps.vGap4,
                                Text(provider.user?.nationalIdNumber??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.text,fontSize: Dimens.font_sp16,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }





  @override
  ProfileViewPresenter createPresenter() => ProfileViewPresenter();

  @override
  bool get wantKeepAlive => false;

}