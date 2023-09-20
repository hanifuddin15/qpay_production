/*
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FaceExpressionUtils {
  final _requiredRightLookingAngle = -45;
  final _requiredLeftLookingAngle = 45;
  final _smilingProbability = 0.5;

  bool _hasSmiled = false;
  bool _hasFaceWithinBounds = false;
  bool _hasLookedLeft = false;
  bool _hasLookedRight = false;
  bool _isVerificationComplete = false;

  FaceVerificationStatus _status = FaceVerificationStatus.NotInitialized;

  Instructions process(Face face) {
    if (face == null && !_isVerificationComplete) {
      return Instructions.ShowFace;
    }

    if (!_isVerificationComplete) {
      _analyzeFaceData(face);
    }

    if (!_isVerificationComplete &&
        _hasLookedLeft &&
        _hasLookedRight &&
        _hasSmiled) {
      _status = FaceVerificationStatus.Complete;
      _isVerificationComplete = true;
    }

    return _returnInstructionBasedOnStatus();
  }

  void _analyzeFaceData(Face face) {
    _hasFaceWithinBounds = _isFaceWithinCircle(face);
    if (!_hasLookedLeft) _hasLookedLeft = _isLookingLeft(face);
    if (!_hasLookedRight) _hasLookedRight = _isLookingRight(face);
    if (_hasLookedLeft && _hasLookedRight && !_hasSmiled) {
      _hasSmiled = _isSmiling(face);
    }

    if (_hasFaceWithinBounds) {
      _status = FaceVerificationStatus.Processing;
    }

    if (_hasLookedLeft) {
      if (_status == FaceVerificationStatus.Processing) {
        _status = FaceVerificationStatus.LookingLeft;
      }
    }
    if (_hasLookedRight) {
      if (_status == FaceVerificationStatus.LookingLeft) {
        _status = FaceVerificationStatus.LookingRight;
      }
    }
    if (_hasSmiled) {
      if (_status == FaceVerificationStatus.LookingRight) {
        _status = FaceVerificationStatus.Smiling;
      }
    }
  }

  bool _isSmiling(Face face) {
    return face.smilingProbability > _smilingProbability;
  }

  bool _isLookingLeft(Face face) {
    return face.headEulerAngleY > _requiredLeftLookingAngle;
  }

  bool _isLookingRight(Face face) {
    return face.headEulerAngleY < _requiredRightLookingAngle;
  }

  Instructions _returnInstructionBasedOnStatus() {
    switch (_status) {
      case FaceVerificationStatus.Processing:
        return Instructions.LookLeft;
      case FaceVerificationStatus.LookingLeft:
        return Instructions.LookRight;
      case FaceVerificationStatus.LookingRight:
        return Instructions.SmilePlease;
      case FaceVerificationStatus.Smiling:
        return Instructions.AnalyzingResults;
      case FaceVerificationStatus.Complete:
        return Instructions.VerificationComplete;
      case FaceVerificationStatus.NotInitialized:
        return Instructions.ShowFace;
    }
    return Instructions.ShowFace;
  }

  bool _isFaceWithinCircle(Face face) {
    return true;
  }
}

enum Instructions {
  ShowFace,
  LookLeft,
  LookRight,
  SmilePlease,
  AnalyzingResults,
  VerificationComplete
}

enum FaceVerificationStatus {
  NotInitialized,
  Processing,
  Smiling,
  LookingLeft,
  LookingRight,
  Complete
}
*/
