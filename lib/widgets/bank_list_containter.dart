import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/toast.dart';

import '../res/gaps.dart';

class BankListContainer extends StatefulWidget{
  final List<BankViewModel> _bankList;
  final Function(BankViewModel) onSelect;
  BankListContainer(this._bankList, this.onSelect);
  _BankListContainerState createState() => _BankListContainerState(_bankList,onSelect);

}
class _BankListContainerState extends State<BankListContainer> {
  final List<BankViewModel> _bankList;
  final Function(BankViewModel) onSelect;

  _BankListContainerState(this._bankList, this.onSelect);
  TextEditingController searchController = new TextEditingController();
  List<BankViewModel> _bankListFiltered = [];
  final FocusNode _nodeText1 = FocusNode();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterBanks();
    });
  }
  @override
  void dispose() {
    searchController.removeListener(() { filterBanks();});
    _nodeText1.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (_bankListFiltered.length > 0 || _bankList.length > 0);
    if (_bankList.length>0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0,top:8.0),
                  child: TextField(
                    focusNode: _nodeText1,
                    controller: searchController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).searchBankAndFI,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colours.text_gray
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colours.app_main
                            )
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(color: Colours.text_gray),
                        ),
                        labelStyle:  _nodeText1.hasFocus ? TextStyle(color: Colours.app_main):TextStyle(color: Colours.text_gray),
                        prefixIcon: Icon(
                            Icons.search,
                            color:  _nodeText1.hasFocus ? Colours.app_main:Colours.text_gray
                        )
                    ),
                  ),
                ),
              ),
              Gaps.vGap8,
              listItemsExist == true ?
              Expanded(
                child: ListView.builder(
                    itemCount: isSearching == true?_bankListFiltered.length : _bankList.length,
                    itemBuilder: (context, index) {
                      BankViewModel bankVM = isSearching == true ?
                      _bankListFiltered[index]:_bankList[index];
                      return Card(
                        elevation:0,
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(bankVM.imageUrl)??'',
                                fit: BoxFit.scaleDown,
                                scale: 1,
                              ),
                            ),
                          ),
                          title: Text(bankVM.name??'',style: TextStyle(fontWeight: FontWeight.w500),),
                          dense: true,
                          onTap: (){
                            onSelect(bankVM);
                          },
                        ),
                      );
                    }),
              ):Container(
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: CircularProgressIndicator(),
                ),
                ),
              ),],
          ),
        ),
      );
    }
    return Container(
        child: Center(
          child: Text("Bank list not available",style: TextStyle(fontWeight: FontWeight.bold),),
        )
      );
  }

  filterBanks() {
    List<BankViewModel> _banks = [];
    _banks.addAll(_bankList);
    if (searchController.text.isNotEmpty) {
      _banks.retainWhere((_bankList) {
        String searchTerm = searchController.text.toLowerCase();
        String bankName = _bankList.name.toLowerCase();
        bool nameMatches = bankName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }
        return false;
      });

    }
    if(mounted){
      setState(() {
        _bankListFiltered = _banks;
      });
    }
  }
}