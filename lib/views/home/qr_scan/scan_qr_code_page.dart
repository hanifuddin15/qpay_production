import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/home_router.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodePage extends StatefulWidget {
  @override
  _ScanQrCodePageState createState() => _ScanQrCodePageState();
}

class _ScanQrCodePageState extends State<ScanQrCodePage>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController _captureController;

  String _captureText = '';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _captureController.pauseCamera();
    }
    _captureController.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getPermissions();
  }

  void _onQRViewCreated(QRViewController controller) {
    _captureController = controller;
    _captureController.resumeCamera();
    _captureController.scannedDataStream.listen((scanData) {
      setState(() {
        _captureText = scanData.code;
      });
      _captureController.pauseCamera();
      _captureController.resumeCamera();
      _getDataFromQr(_captureText);
    });
  }
  getPermissions() async {
    var status = await Permission.camera.request();
    if (status==PermissionStatus.granted) {
      _captureController.resumeCamera();
    }
    if(status==PermissionStatus.denied){
      await Permission.camera.request();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _captureController.dispose();
    super.dispose();
  }


  void _getDataFromQr(String qrData) {
    if(qrData!=null){
      CachedQrCode().set(qrData);
      NavigatorUtils.push(context, HomeRouter.qrCodePayment,replace: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,color: Colors.black54,),
              onPressed: () {
                _goBack(context);
              },
            ),
            elevation: 0.0,
            titleSpacing: 10.0,
            title: Text("Qr Payment".toUpperCase(),style: TextStyle(color: Colours.text),),
            shadowColor: Colors.transparent,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 300,
                  width: 300,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_goBack(BuildContext context) {
  Navigator.pop(context);
}
