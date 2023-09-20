import 'package:flutter/material.dart';
import 'package:qpay/res/resources.dart';
import 'load_image.dart';

class InstructionContainer extends StatelessWidget {
  final FaceMovementInstruction _movement;

  InstructionContainer(this._movement);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LoadAssetImage(_movement.imagePath,height: 48,width: 48,),
          Gaps.vGap16,
          Text(
            _movement.instruction,
            style: TextStyles.textBold18,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class FaceMovementInstruction {
  String imagePath;
  String instruction;

  FaceMovementInstruction(this.instruction,this.imagePath);

}