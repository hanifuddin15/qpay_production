import 'package:app_settings/app_settings.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/custom_contact.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/application.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_dialog_custom.dart';

class MyContactPage extends StatefulWidget {
  @override
  _MyContactPageState createState() => _MyContactPageState();
}

class _MyContactPageState extends State<MyContactPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  final FocusNode _nodeText1 = FocusNode();

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  @override
  void dispose() {
    searchController.removeListener(() { filterContacts();});
    _nodeText1.dispose();
    super.dispose();
  }

  getPermissions() async {
    var status = await Permission.contacts.status;
    if (status==PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
    if(status==PermissionStatus.denied){
     var requested =  await Permission.contacts.request();
     if (requested==PermissionStatus.granted) {
       getAllContacts();
       searchController.addListener(() {
         filterContacts();
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

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.cyan,
      Colors.pink,
      Colors.purple,
      Colors.lime
    ];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false
    )).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    if(mounted) {
      setState(() {
        var storedContact = CachedContact().contactData;
        if (storedContact != null && storedContact.isNotEmpty) {
          contacts = storedContact;
          return;
        }
        try {
          contacts =
              _contacts.where((element) => element.phones.isNotEmpty).toList();
          CachedContact().set(contacts);
        } catch (e) {
          showToast('Failed to get response!');
        }
      });
    }
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }
        if (searchTermFlatten.isEmpty) {
          return false;
        }
        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);
        return phone != null;
      });
    }
    if(mounted) {
      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }

  _contactSelect(Contact contact,int index) {
    CustomContact _customContact = CustomContact(contact.displayName, contact.phones.elementAt(index).value);
    NavigatorUtils.goBackWithParams(context, _customContact);
  }

  _viewAllContacts(Contact contact) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
    return MyDialogCustome(
            title: contact.displayName,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: contact.phones.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              NavigatorUtils.goBack(context);
                              _contactSelect(contact, index);
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  contact.phones.elementAt(index).value,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.grey,fontSize: 16),
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                              Gaps.vGap16,
                              Gaps.line,
                            ],
                          ),
                        ),

                      );
                    }),
              ),
            ),

          );
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (contactsFiltered.length > 0 || contacts.length > 0);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).contactsTitle,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  focusNode: _nodeText1,
                  controller: searchController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).searchTitle,
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
              Gaps.vGap8,
              listItemsExist == true ?
              Expanded(
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: isSearching == true
                      ? contactsFiltered.length
                      : contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = isSearching == true
                        ? contactsFiltered[index]
                        : contacts[index];

                    var baseColor = contactsColorMap[contact
                        .displayName] as dynamic;

                    Color color1 = baseColor[800];
                    Color color2 = baseColor[400];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (contact.avatar != null &&
                                contact.avatar.length > 0) ?
                            CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar),
                            ) :
                            Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        colors: [
                                          color1,
                                          color2,
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight
                                    )
                                ),
                                child: CircleAvatar(
                                    child: Text(
                                        contact.initials(),
                                        style: TextStyle(
                                            color: Colors.white
                                        )
                                    ),
                                    backgroundColor: Colors.transparent
                                )
                            ),
                            Gaps.hGap16,
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(contact.displayName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: Dimens.font_sp16),),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: contact.phones.length>1 ?Container(
                                      child:Padding(
                                        padding: EdgeInsets.only(top:8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      side: BorderSide(
                                                          color: Colors.black, style: BorderStyle.none),
                                                    ),
                                                  ),
                                                  elevation: MaterialStateProperty.all<double>(.8),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<Color>(Colors.white54)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(Icons.keyboard_arrow_down,color:  Colors.black54,),
                                                  Gaps.hGap4,
                                                  Text(
                                                    AppLocalizations.of(context).seeAllNumbers.toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: Dimens.font_sp14, color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                _viewAllContacts(contact);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ):InkWell(
                                      onTap: (){
                                        setState(() {
                                          _contactSelect(contact,0);
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top:8,left: 16),
                                            child: Text(contact.phones.elementAt(0).value,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                          ),
                                        ],
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ) : Container(
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: CircularProgressIndicator(),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

