import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/providers/dashboard_provider.dart';
import 'package:qpay/providers/user_registration_state_provider.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/providers/face_expression_provider.dart';
import 'package:qpay/utils/face_expression_utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/instruction_container.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/progress_dialog.dart';
import 'package:qpay/utils/camera_utils.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show TargetPlatform;



class FaceVerificationPage extends StatefulWidget {
  @override
  _FaceVerificationPageState createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage>
    with TickerProviderStateMixin {
  /* final FaceExpressionProvider _expressionProvider = FaceExpressionProvider();
  final FaceExpressionUtils _expressionVerifier = FaceExpressionUtils();*/
  var registrationDataHolder = UserRegistrationStateProvider();
  final provider = DashboardProvider();
  CameraController _controller;
  FaceMovementInstruction _instruction;
  String filePath='';
  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
      return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBody: true,
          appBar: MyAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: MyButton(onPressed: _captureImage,text: "Capture",)
            ),
          ),
          body: Column(
            children: <Widget>[
              Gaps.vGap24,
              _buildCameraPreview(),
              Container(child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Place your face inside the circle"),
                  Gaps.vGap16,
                ],
              )),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: ProgressDialog(
          hintText: "Loading",
        ),
      );
    }
  }

  Widget _buildCameraPreview() {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colours.app_main, width: 3),
      ),
      margin: EdgeInsets.all(56),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(360.0),
          child: Transform.scale(
            scale: _controller.value.aspectRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1/_controller.value.aspectRatio,
                child: CameraPreview(_controller),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState()  {
    super.initState();
   _initCamera();
   /* _expressionProvider.addListener(_expressionListener);*/
  }

  /*void _expressionListener() {
    final Face face = _expressionProvider.face;
    if (_controller == null) _controller = _expressionProvider.cameraController;
    var state = _expressionVerifier.process(face);
    _instruction = _instructionMapper(state);
    if (state == Instructions.VerificationComplete) {
      _captureImage();
    }

    setState(() {});
  }*/

  void _captureImage() async {
    print('_captureImage');
    if (_controller.value.isInitialized) {
      try {
        await _controller.stopImageStream();
        await takePictureAndExit();
      }on CameraException catch (e) {
        print(e);
        await takePictureAndExit();
        return null;
      }
    }
  }

  Future takePictureAndExit() async {
    if(provider.user?.imageUrl != '' && provider.user?.imageUrl !=null){
      await _controller.takePicture().then((XFile file) {
        if (mounted) {
          setState(() {
            filePath = file.path;
          });
        }
      });
      NavigatorUtils.goBackWithParams(context, filePath);
    }else {
      await _controller.takePicture().then((XFile file) {
        if (mounted) {
          setState(() {
            filePath = file.path;
          });
        }
      });
      registrationDataHolder.setProfileImagePath(filePath);
      NavigatorUtils.push(context, AuthRouter.registerNIDVerificationPage);
    }
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void dispose() {
  /*  _expressionProvider.removeListener(_expressionListener);*/
    print('on dispose call');
    _controller.dispose();
    super.dispose();
  }

  /*FaceMovementInstruction _instructionMapper(Instructions instruction) {
    final instructions = [
      FaceMovementInstruction(
          AppLocalizations.of(context).faceNotFound.toUpperCase(),
          "facenotfound"),
      FaceMovementInstruction(
          AppLocalizations.of(context).lookLeft.toUpperCase(), "lookleft"),
      FaceMovementInstruction(
          AppLocalizations.of(context).lookRight.toUpperCase(), "lookright"),
      FaceMovementInstruction(
          AppLocalizations.of(context).smilePlease.toUpperCase(), "smile"),
      FaceMovementInstruction(
          AppLocalizations.of(context).verified.toUpperCase(), "verified"),
      FaceMovementInstruction(
          AppLocalizations.of(context).error.toUpperCase(), "error"),
    ];
    switch (instruction) {
      case Instructions.ShowFace:
        return instructions[0];
      case Instructions.LookLeft:
        return instructions[1];
        break;
      case Instructions.LookRight:
        return instructions[2];
        break;
      case Instructions.SmilePlease:
        return instructions[3];
        break;
      case Instructions.AnalyzingResults:
        break;
      case Instructions.VerificationComplete:
        return instructions[4];
        break;
    }
    return instructions[5];
  }*/

  void _initCamera() async{
    _controller =
    new CameraController(await getCamera(CameraLensDirection.front), ResolutionPreset.medium);
    await _controller.initialize();
    if(mounted) setState(() {});
  }
}
