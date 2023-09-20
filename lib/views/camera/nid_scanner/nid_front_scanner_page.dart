import 'dart:io';
import 'package:camera/camera.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/providers/nid_update_status_provider.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/home_router.dart';
import 'package:qpay/routers/routers.dart';
import 'package:qpay/utils/smart_card_parser.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/progress_dialog.dart';

class NationalIdFrontScannerPage extends StatefulWidget {
  const NationalIdFrontScannerPage({Key key}) : super(key: key);

  @override
  NationalIdFrontScannerPageState createState() =>
      NationalIdFrontScannerPageState();
}

class NationalIdFrontScannerPageState extends State<NationalIdFrontScannerPage>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
/*  TextRecognizer _textRecognizer;
  FaceDetector _detector;*/
  bool _isNidNumberFound = false;
  bool _isFaceFound = true;
  var dataHolder = new NidUpdateDataHolder();
  String filePath='';

  @override
  void initState() {
    _initCamera();
    super.initState();
    /*_textRecognizer = FirebaseVision.instance.textRecognizer();
    _detector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        enableClassification: true, mode: FaceDetectorMode.accurate));*/
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
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
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var aspectRatio = 3 / 1.8;
    super.build(context);
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(child: ProgressDialog());
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }
    return WillPopScope(
      onWillPop: _onBack,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.3),
          key: _scaffoldKey,
          extendBody: true,
          appBar: MyAppBar(
            backgroundColor: Colors.white.withOpacity(0.5),
            isBack: false,
          ),
          body: MyScrollView(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).takeClearNidPic+' (FRONT SIDE)'.toUpperCase(),
                style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp18),textAlign: TextAlign.center,
              ),
              Gaps.vGap16,
                _buildCameraPreview(),
                Gaps.vGap16,
                Text(
                  AppLocalizations.of(context).placementClearNidPic,
                  style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp18),textAlign: TextAlign.center,
                ),
                Gaps.vGap16,
                LoadAssetImage('nid_front',width: width*.5,height: (width/aspectRatio)*.5,),
              ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black.withOpacity(0.5),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildBottomNavigationBar(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    final width = MediaQuery.of(context).size.width;
    var aspectRatio = 3 / 1.8;
    return Container(
      decoration: new BoxDecoration(
        border: Border.all(color: Colours.app_main, width: 3),
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: width / 5),
      width: width,
      height: width / aspectRatio,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              width: width,
              height: width * _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return MyButton(
        key: const Key('register'),
        onPressed: _captureImage,
        text: 'Capture',
      );
  }

  void _captureImage() async {
    print('_captureImage');
    if (_controller.value.isInitialized) {
      _controller.takePicture().then((XFile file) {
        if (mounted) {
          setState(() {
            getCroppedImage(file.path);
          });
        }
      });
    }
  }
  getCroppedImage(String imagePath) async {
    final width = MediaQuery.of(context).size.width;
    var aspectRatio = 3 / 1.8;
    File croppedImage = await ImageCropper().cropImage(sourcePath: imagePath,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 1.8),
        compressQuality: 100,
        maxHeight: 768,
        maxWidth: 1024,
        compressFormat: ImageCompressFormat.png,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.white,
            toolbarTitle: "Crop NID Image",
            statusBarColor: Colours.app_main,
            backgroundColor: Colors.white
        )
    );
    this.setState(() {
      filePath = croppedImage.path;
    });
    dataHolder.setFrontImage(filePath);
    if (filePath !=null) {
      NavigatorUtils.push(context, HomeRouter.nidBackUpdatePage);
    }
  }
  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /*void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }*/

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;

  Future _analyzeImage(String filePath) async {
    setState(() {});

  }

  /*void checkTexts(List<TextBlock> list) {
    if (list == null || list.isEmpty) {
      return;
    }
    var parser = SmartCardParser();
    var results = parser.parse(list);

    if (results.containsKey(Constant.nidKey)
//        && results.containsKey(Constant.nameKey)
    ) {

      _isNidNumberFound = true;
    }
  }

  void checkFace(Face face) {
    if (face == null) {
      return;
    }
    _isFaceFound = true;
  }*/
}
