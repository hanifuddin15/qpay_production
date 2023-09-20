import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/providers/nid_parse_information_state_provider.dart';
import 'package:qpay/providers/nid_update_status_provider.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/home_router.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/nid/nid_iview.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_icon_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';
import 'nid_upload_presenter.dart';

class NidUploadPage extends StatefulWidget {
  @override
  _NidUploadPageState createState() => _NidUploadPageState();
}

class _NidUploadPageState extends State<NidUploadPage>
    with
        BasePageMixin<NidUploadPage, NidUploadPresenter>,
        AutomaticKeepAliveClientMixin<NidUploadPage>
    implements NidIMvpView {
  final FocusNode _nodeText1 = FocusNode();
  final TextEditingController _nidInputController = TextEditingController();
  bool _clickable = false;
  bool _isNidFrontUploaded = false;
  bool _isNidBackUploaded = false;
  var dataHolder = new NidUpdateDataHolder();
  final nidProvider = NidParseInformationProvider();


  @override
  void initState() {
    super.initState();
    _nidInputController.addListener(_verify);
    dataHolder.addListener(_onNidDataUpdate);
  }

  @override
  void dispose() {
    dataHolder.removeListener(_onNidDataUpdate);
    _nidInputController.removeListener(_verify);
    dataHolder.clear();
    super.dispose();
  }

  void _verify() {
    var clickable = true;

    if (!dataHolder.isNidBackProvided()) {
      clickable = false;
    }
    if (!dataHolder.isNidFrontProvided()) {
      clickable = false;
    }

    if (mounted && clickable != _clickable) {
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
          centerTitle: AppLocalizations.of(context).verifyIdentity,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 10,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: MyButton(
                key: const Key('register'),
                onPressed: _clickable ? _upload : null,
                text: AppLocalizations.of(context).upload,
              ),
          ),
        ),
        body: MyScrollView(
          keyboardConfig:
              Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Gaps.vGap32,
      Row(
        children: [
          CircleAvatar(
            child: Text("1"),
            radius: Dimens.gap_dp16,
          ),
          Gaps.hGap8,
          MyIconButton(
            key: const Key('nidFront'),
            onPressed: _launchNidFrontScanner,
            text: AppLocalizations.of(context).nidFrontUpload,
            icon: Icon(Icons.card_membership),
          ),
          Gaps.hGap8,
          _isNidFrontUploaded
              ? Icon(
                  Icons.done_all,
                  color: Colors.green,
                )
              : Icon(
                  Icons.not_interested,
                  color: Colors.red,
                )
        ],
      ),
      Gaps.vGap16,
      Row(
        children: [
          CircleAvatar(
            child: Text("2"),
            radius: Dimens.gap_dp16,
          ),
          Gaps.hGap8,
          MyIconButton(
            key: const Key('nidBack'),
            onPressed: _launchNidBackScanner,
            text: AppLocalizations.of(context).nidBackUpload,
            icon: Icon(Icons.card_membership),
          ),
          Gaps.hGap8,
          _isNidBackUploaded
              ? Icon(
                  Icons.done_all,
                  color: Colors.green,
                )
              : Icon(
                  Icons.not_interested,
                  color: Colors.red,
                )
        ],
      ),
      Gaps.vGap32,
    ];
  }

  void _upload() async {
    var nidData = dataHolder.getData();
    var response = await presenter.uploadNid(nidData);
    if (response != null) {
      nidProvider.setInformation(response);
      NavigatorUtils.push(context,AuthRouter.userInformationUpdatePage);
    }
  }

  void _launchNidFrontScanner() {
    NavigatorUtils.push(context, HomeRouter.nidFrontUpdatePage);
  }

  void _launchNidBackScanner() {
    NavigatorUtils.push(context, HomeRouter.nidBackUpdatePage);
  }

  void _onNidDataUpdate() {
    var nidFront = dataHolder.isNidFrontProvided();
    var nidBack = dataHolder.isNidBackProvided();
    _verify();
    setState(() {
      _isNidFrontUploaded = nidFront;
      _isNidBackUploaded = nidBack;
    });
  }

  @override
  NidUploadPresenter createPresenter() {
    return NidUploadPresenter();
  }

  @override
  bool get wantKeepAlive => true;
}
