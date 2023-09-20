import 'package:camera/camera.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

bool isDetecting = false;

Future<CameraDescription> getCamera(CameraLensDirection direction) async {
  return await availableCameras().then((cameras) => cameras.firstWhere(
      (lens) => lens.lensDirection == direction ?? CameraLensDirection.front));
}

/*void cameraBytesStreamer({
  @required CameraController camera,
  @required FaceDetector detector,
  @required void updateFace(Face face),
}) {
  camera.startImageStream((image) {
    if (isDetecting) return;
    isDetecting = true;

    detector
        .processImage(FirebaseVisionImage.fromBytes(
            image.planes[0].bytes,
            FirebaseVisionImageMetadata(
                rawFormat: image.format.raw,
                size: camera.value.previewSize,
                planeData: image.planes
                    .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
                        bytesPerRow: currentPlane.bytesPerRow,
                        height: currentPlane.height,
                        width: currentPlane.width))
                    .toList(),
                rotation: ImageRotation.rotation270)))
        .then((faces) {
      updateFace(faces.isEmpty ? null : faces[0]);
      isDetecting = false;
    });
  });
}

void textRecognitionStreamer({
  @required CameraController camera,
  @required TextRecognizer detector,
  @required void updateText(List<TextBlock> texts),
}) {
  camera.startImageStream((image) {
    if (isDetecting) return;
    isDetecting = true;

    detector
        .processImage(FirebaseVisionImage.fromBytes(
            image.planes[0].bytes,
            FirebaseVisionImageMetadata(
                rawFormat: image.format.raw,
                size: camera.value.previewSize,
                planeData: image.planes
                    .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
                        bytesPerRow: currentPlane.bytesPerRow,
                        height: currentPlane.height,
                        width: currentPlane.width))
                    .toList(),
                rotation: ImageRotation.rotation270)))
        .then((text) {
      updateText(text.blocks.isEmpty ? null : text.blocks);
      isDetecting = false;
    });
  });
}*/
