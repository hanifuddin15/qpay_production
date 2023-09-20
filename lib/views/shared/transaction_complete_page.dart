import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qpay/Events/transaction_success_event.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/app_event_bus.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/transaction_account_selector.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:share_plus/share_plus.dart';


class TransactionCompletedPage extends StatelessWidget {
  final TransactionAccountSelector from;
  final TransactionAccountSelector to;
  final TransactionViewModel transaction;
  TransactionCompletedPage(this.from, this.to, this.transaction);
  Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  List<String> imagePaths = [];
  final shareButtonGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed:() async{ _share(context,transaction.transactionName);},
                    child: Icon(Icons.share,color: transaction.getTranSactionColor(),),),
                ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: ()async{
                    if(transaction.isSuccessful()){
                      AppEventManager().eventBus.fire(TransactionSuccessEvent("transaction successful and call the event"));
                    }
                    _exit(context);
                  },
                  child: Icon(Icons.home,color: transaction.getTranSactionColor(),),),
              ),
            ),
              ],
            ),
          ),
          body: MyScrollView(
            children: [
              Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: Container(
                      color: Colors.white,
                      height: size.height*1.15,
                      child: Stack(
                        children: [
                          Container(
                            height: size.height *.4,
                            width: size.width,
                            color: transaction.getTranSactionColor(),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/logo_white.png',scale: 12,),
                                  transaction.getTransactionIcon(),
                                  Text(
                                    transaction.transactionDetails??AppLocalizations.of(context).notAvailable,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: Dimens.font_sp20),
                                  ),
                                  Text(
                                    transaction.dateTime??AppLocalizations.of(context).notAvailable,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: Dimens.font_sp14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top:MediaQuery.of(context).size.height*.4 ,
                            child: Container(
                              width: size.width,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  Text(transaction.transactionName,style: TextStyle(color: Colors.black,fontSize: Dimens.font_sp16,fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              Gaps.vGap24,
                                              _viewParams('TRANSACTION ID', transaction.transactionId??AppLocalizations.of(context).notAvailable),
                                              Gaps.vGap10,
                                              _viewParams('AMOUNT', '৳ '+transaction.amountFormatted??AppLocalizations.of(context).notAvailable),
                                              Gaps.vGap10,
                                              _viewParams('TOTAL FEES', '৳ '+transaction.feeFormatted??AppLocalizations.of(context).notAvailable),
                                              Gaps.vGap10,
                                              _viewParams('TOTAL', '৳ '+transaction.total??AppLocalizations.of(context).notAvailable),
                                              Gaps.vGap10,
                                              _viewParams('PURPOSE', transaction.remarks??AppLocalizations.of(context).notAvailable),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
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
                                              Card(
                                                  elevation: 2.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: from,
                                                  )),
                                              Gaps.vGap10,
                                              to!=null?Card(
                                                  elevation: 2.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: to,
                                                  )):SizedBox(),
                                              Gaps.vGap8,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
          ),
        ),
      ),
    );
  }

  void _exit(BuildContext context) {
    NavigatorUtils.goBack(context);
  }


  void _share(BuildContext context,String transactionName) async {
    var status = await Permission.storage.status;
    if (status==PermissionStatus.granted) {
      imagePaths.clear();
      _imageFile = null;
      screenshotController.capture(delay: Duration(milliseconds: 10))
          .then((Uint8List captureImage) async {
        if (captureImage != null) {
          _imageFile = captureImage;
        }
        var now = DateTime.now();
        var dateFormat = DateFormat('dd-MM-yyyy hh:mm');
        var dateTime = dateFormat.format(now);
        var screenShotName = transactionName + '_' + dateTime;
        final directory = Platform.isAndroid
            ? await getExternalStorageDirectory() //FOR ANDROID
            : await getApplicationSupportDirectory();
        Uint8List pngBytes = _imageFile.buffer.asUint8List();
        File imgFile = new File('$directory/$screenShotName.png');
        imagePaths.add(imgFile.path);
        imgFile.writeAsBytes(pngBytes);
        final RenderBox box = context.findRenderObject();
        /*Platform.isAndroid ? await Share.shareFiles(imagePaths,
          subject: 'Share Receipt of Transaction from QPay',
          text: screenShotName,
          sharePositionOrigin:  box.localToGlobal(Offset.zero) & box.size)
          : */
        await ShareFilesAndScreenshotWidgets().shareFile(
            screenShotName, '$screenShotName.png', pngBytes, "image/png",
            text: 'Share Receipt of Transaction from QPay');
      }).catchError((onError) {
        print(onError);
      });
    }
    if(status==PermissionStatus.denied){
      var requested =  await Permission.storage.request();
      if (requested==PermissionStatus.granted) {
        imagePaths.clear();
        _imageFile = null;
        screenshotController.capture(delay: Duration(milliseconds: 10))
            .then((Uint8List captureImage) async {
          if (captureImage != null) {
            _imageFile = captureImage;
          }
          var now = DateTime.now();
          var dateFormat = DateFormat('dd-MM-yyyy hh:mm');
          var dateTime = dateFormat.format(now);
          var screenShotName = transactionName + '_' + dateTime;
          final directory = Platform.isAndroid
              ? await getExternalStorageDirectory() //FOR ANDROID
              : await getApplicationSupportDirectory();
          Uint8List pngBytes = _imageFile.buffer.asUint8List();
          File imgFile = new File('$directory/$screenShotName.png');
          imagePaths.add(imgFile.path);
          imgFile.writeAsBytes(pngBytes);
          final RenderBox box = context.findRenderObject();
          /*Platform.isAndroid ? await Share.shareFiles(imagePaths,
          subject: 'Share Receipt of Transaction from QPay',
          text: screenShotName,
          sharePositionOrigin:  box.localToGlobal(Offset.zero) & box.size)
          : */
          await ShareFilesAndScreenshotWidgets().shareFile(
              screenShotName, '$screenShotName.png', pngBytes, "image/png",
              text: 'Share Receipt of Transaction from QPay');
        }).catchError((onError) {
          print(onError);
        });
      }
      if(requested == PermissionStatus.permanentlyDenied){
        status = requested;
      }
      }
    if(status == PermissionStatus.permanentlyDenied){
      AppSettings.openAppSettings();
    }
    }
  }


  Widget _viewParams(String title, String value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, softWrap: true ,style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp14,fontWeight: FontWeight.normal),),
        SelectableText(value, cursorColor: Colors.red, showCursor: false,
          toolbarOptions: ToolbarOptions(
              copy: true,
              selectAll: true,
              cut: false,
              paste: false
          ), style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12,fontWeight: FontWeight.bold),),
      ],
    );
}
