import 'package:flutter/material.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/state_layout.dart';

class WidgetNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: MyAppBar(
        centerTitle: 'Work in progress',
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadAssetImage("fellasleep"),
              Gaps.vGap8,
              Text("Coming soon...")
            ],
          ),
        ),
      ),
    );
  }
}
