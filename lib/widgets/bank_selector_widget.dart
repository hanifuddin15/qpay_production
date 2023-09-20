import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/widgets/load_image.dart';

import '../res/gaps.dart';
import '../res/styles.dart';

class BankSelector extends StatelessWidget{
  final BankViewModel _bankViewModel;

  const BankSelector(this._bankViewModel);

  @override
  Widget build(BuildContext context) {
   return Container(
     width: MediaQuery.of(context).size.width,
     child: Card(
       margin: EdgeInsets.all(0),
       shape: RoundedRectangleBorder(
         borderRadius: const BorderRadius.all(
           Radius.circular(5.0),
         ),
         side: BorderSide(color: Colours.text_gray, width: 1),
       ),
       child: ListTile(
         leading: _bankViewModel != null ?Container(
           width: 48,
           height: 36,
           decoration: BoxDecoration(
             shape: BoxShape.rectangle,
             image: DecorationImage(
               image: NetworkImage(_bankViewModel.imageUrl),
               fit: BoxFit.scaleDown,
               scale: 1,
             ),
           ),
         ):Icon(Icons.account_balance,size: 24,),
         title: _bankViewModel != null ?Text(_bankViewModel.name,style: TextStyle(fontWeight: FontWeight.w500),):Text('Select Bank / Financial Institute',style: TextStyle(fontWeight: FontWeight.w500)),
         trailing: _bankViewModel != null ?Icon(Icons.arrow_forward_ios,size: 16,):Icon(Icons.arrow_forward_ios,size: 16,),
       ),
     ),
   );
  }

}