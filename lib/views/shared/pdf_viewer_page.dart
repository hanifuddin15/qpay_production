import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/main.dart';
import 'package:qpay/widgets/app_bar.dart';

class PdfViewerPage extends StatefulWidget{
  final String title;
  final PDFDocument pdfDocument;

  const PdfViewerPage(this.title, this.pdfDocument);
  @override
  State<StatefulWidget> createState() => _PdfViewerPageState(title,pdfDocument);
  
}
class _PdfViewerPageState extends State<PdfViewerPage>{
  bool _isLoading = true;
  final String _title;
  final PDFDocument _pdfDocument;

  _PdfViewerPageState(this._title, this._pdfDocument);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: MyAppBar(
       centerTitle: _title,
     ),
     body: Center(
       child: _isLoading?CircularProgressIndicator():PDFViewer(document: _pdfDocument,zoomSteps: 1,),
     ) ,
   );
  }
  
}