/*
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/utils/camera_utils.dart';

class FaceExpressionProvider extends ValueNotifier<int> {
  FaceExpressionProvider() : super(0) {
    init();
  }

  CameraController _camera;
  FaceDetector _detector;

  Face _face;

  Face get face => _face ?? null;

  CameraController get cameraController => _camera ?? null;

  void init() async {
    _camera =
        new CameraController(await getCamera(CameraLensDirection.front), ResolutionPreset.low);
    await _camera.initialize();

    _detector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        enableClassification: true, mode: FaceDetectorMode.accurate));

    cameraBytesStreamer(
        camera: _camera,
        detector: _detector,
        updateFace: (face) {
          _face = face;
          notifyListeners();
        });
  }

  @override
  void dispose() {
    super.dispose();
    _detector.close();
    _camera.dispose();
  }
}
*/
