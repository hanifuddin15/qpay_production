import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/gender_vm.dart';
import 'package:qpay/providers/nid_parse_information_state_provider.dart';
import 'package:qpay/providers/nid_update_status_provider.dart';
import 'package:qpay/providers/user_registration_state_provider.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/routers.dart';
import 'package:qpay/static_data/dashboard_data.dart';
import 'package:qpay/utils/image_utils.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/registration/register_iview.dart';
import 'package:qpay/views/registration/register_page_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/my_step_indicator.dart';
import 'package:qpay/widgets/text_field.dart';

class RegistrationInformationShowPage extends StatefulWidget{
  @override
  _RegistrationInformationShowPageState createState() => _RegistrationInformationShowPageState();
}

class _RegistrationInformationShowPageState extends State<RegistrationInformationShowPage>
      with BasePageMixin<RegistrationInformationShowPage,RegisterPagePresenter>,
          AutomaticKeepAliveClientMixin<RegistrationInformationShowPage>
    implements RegisterIMvpView{
  final provider = NidParseInformationProvider();
  final registrationDataHolder = UserRegistrationStateProvider();
  bool _value = false;
  bool _clickable = false;
  final images = DashboardImages();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  final TextEditingController _bNameController = TextEditingController();
  final TextEditingController _eNameController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _mNameController = TextEditingController();
  final TextEditingController _dOBController = TextEditingController();
  final TextEditingController _nidNoController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime nowDate = DateTime.now();
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  List<Gender> _genderTypes = Gender.getGenderTypes();
  List<DropdownMenuItem<Gender>> _dropdownGenderTypeItems;
  Gender _selectedGender;
  var _isGenderChangedByUser = false;

  File imageFile;

  List<DropdownMenuItem<Gender>> buildDropDownGenderTypes(List genderTypes) {
    List<DropdownMenuItem<Gender>> items = List();
    for (Gender genderType in genderTypes) {
      items.add(
        DropdownMenuItem(
          value: genderType,
          child: Text(genderType.gender),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    imageFile = File(registrationDataHolder.profileImage);
    _dropdownGenderTypeItems = buildDropDownGenderTypes(_genderTypes);
    _selectedGender = _dropdownGenderTypeItems[0].value;
    _bNameController.addListener(_verify);
    _bNameController.text = provider.getNidInformationParseViewModel().nameBangla;
    _eNameController.addListener(_verify);
    _eNameController.text = provider.getNidInformationParseViewModel().nameEnglish;
    _fNameController.addListener(_verify);
    _fNameController.text = provider.getNidInformationParseViewModel().fathersName;
    _mNameController.addListener(_verify);
    _mNameController.text = provider.getNidInformationParseViewModel().mothersName;
    _dOBController.addListener(_verify);
    _dOBController.text = formatter.format(DateFormat('yyyy-MM-ddThh:mm:ss').parse(provider.getNidInformationParseViewModel().dateOfBirth)) ;
    _nidNoController.addListener(_verify);
    _nidNoController.text = provider.getNidInformationParseViewModel().nidNumber;
    registrationDataHolder.addListener(_onRegistrationDataChanged);
  }

  @override
  void dispose() {
    _bNameController.removeListener(_verify);
    _eNameController.removeListener(_verify);
    _fNameController.removeListener(_verify);
    _mNameController.removeListener(_verify);
    _dOBController.removeListener(_verify);
    _nidNoController.removeListener(_verify);
    _bNameController.dispose();
    _eNameController.dispose();
    _fNameController.dispose();
    _mNameController.dispose();
    _dOBController.dispose();
    _nidNoController.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    _nodeText3.dispose();
    _nodeText4.dispose();
    _nodeText5.dispose();
    _nodeText6.dispose();
    registrationDataHolder.clearVerificationData();
    super.dispose();
  }
  void _onRegistrationDataChanged() {
    _verify();
  }

  Future<bool> _onBack(){
    return showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: AppLocalizations.of(context).cancel,
            title: 'Are you sure?',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Do you want to exit from this page? All your data will be lost!",
                    style: TextStyles.textSize12,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            onPressed: () {
              NavigatorUtils.push(context, Routes.home,
                  replace: true, clearStack: true);
            },
            onBackPressed: (){
              NavigatorUtils.goBack(context);
            },
          );
        }) ??
        false;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dOBController.value = TextEditingValue(text: formatter.format(picked));
      });
  }

  void _verify() {
    final bName = _bNameController.text;
    final String eName = _eNameController.text;
    final String fName = _fNameController.text;
    final String mName = _mNameController.text;
    final String dOB =  _dOBController.text;
    final String nidNo = _nidNoController.text;
    final String genderType = _selectedGender.gender; //s
    bool clickable = true;
    if(eName.isEmpty){
      clickable = false;
    }
    if(dOB.isEmpty){
      clickable = false;
    }
    if(genderType.isEmpty ){
      clickable = false;
    }
    if(_selectedGender.id == 0){
      clickable = false;
    }

    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: SafeArea(
        child: Scaffold(
            appBar: MyAppBar(
              centerTitle: "Verify Information",
            ),
            body: MyScrollView(
              keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[
                _nodeText1,
                _nodeText2,
                _nodeText3,
                _nodeText4,
                _nodeText5,
                _nodeText6,
              ]),
              crossAxisAlignment: CrossAxisAlignment.start,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
              children: _buildBody(),
            ),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Gaps.vGap32,
      Align(
        alignment: Alignment.center,
        child: CircleAvatar(
          radius: 60.0,
          backgroundImage: FileImage(imageFile),
          onBackgroundImageError: (dynamic, stacktrace) {},
        ),
      ),
      Gaps.vGap32,
      MyTextField(
        key: const Key('eName'),
        iconName: 'name',
        focusNode: _nodeText2,
        controller: _eNameController,
        maxLength: 50,
        keyboardType: TextInputType.name,
        hintText: AppLocalizations.of(context).getUserEnglishName,
        labelText: AppLocalizations.of(context).getUserEnglishName,
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('bName'),
        iconName: 'name',
        focusNode: _nodeText1,
        controller: _bNameController,
        maxLength: 50,
        keyboardType: TextInputType.name,
        hintText: AppLocalizations.of(context).getUserBengaliName,
        labelText: AppLocalizations.of(context).getUserBengaliName,
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('fName'),
        iconName: 'name',
        focusNode: _nodeText3,
        controller: _fNameController,
        maxLength: 50,
        keyboardType: TextInputType.name,
        hintText: AppLocalizations.of(context).getUserFathersName,
        labelText: AppLocalizations.of(context).getUserFathersName,
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('mName'),
        iconName: 'name',
        focusNode: _nodeText4,
        controller: _mNameController,
        maxLength: 50,
        keyboardType: TextInputType.name,
        hintText: AppLocalizations.of(context).getUserMothersName,
        labelText: AppLocalizations.of(context).getUserMothersName,
      ),
      Gaps.vGap8,
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        height: 48.0,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
              color: Colours.text_gray,
              width: 1,
            ),
            color: Colors.white),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: _selectedGender,
            items: _dropdownGenderTypeItems,
            onChanged: onGenderTypeChange,
            isExpanded: true,
          ),
        ),
      ),
      Gaps.vGap8,
      GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: MyTextField(
            key: const Key('dOB'),
            iconName: 'date',
            focusNode: _nodeText5,
            controller: _dOBController,
            maxLength: 20,
            keyboardType: TextInputType.name,
            hintText: AppLocalizations.of(context).getUserDOBName,
            labelText: AppLocalizations.of(context).getUserDOBName,

          ),
        ),
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('nidNo'),
        iconName: 'ic',
        focusNode: _nodeText6,
        controller: _nidNoController,
        maxLength: 20,
        keyboardType: TextInputType.name,
        hintText: AppLocalizations.of(context).getUserNIDNo,
        labelText: AppLocalizations.of(context).getUserNIDNo,
        enabled: false,

      ),
      Gaps.vGap24,
      MyButton(
        key: const Key('next'),
        onPressed: _clickable ? _next : null,
        text: AppLocalizations.of(context).submit,
      ),

    ];
  }

  void _next() {
    if(_bNameController.text != null){
      provider.setNameBangla(_bNameController.text??'');
    }
    if(_eNameController.text != null){
      provider.setNameEnglish(_eNameController.text??'');
    }
    if(_fNameController.text != null){
      provider.setFathersName(_fNameController.text??'');
    }
    if(_mNameController.text != null){
      provider.setMothersName(_mNameController.text??'');
    }
    if(_nidNoController.text != null){
      provider.setNidNumber(_nidNoController.text??'');
    }
    if(_dOBController.text != null){
      if(nowDate.difference(formatter.parse(_dOBController.text)).inDays /365 < 100 && nowDate.difference(formatter.parse(_dOBController.text)).inDays/365 > 18 ) {
        provider.setDateOfBirth(DateFormat('MM-dd-yyyy').format(
            formatter.parse(_dOBController.text)));
      }else{
        setState(() {
          _clickable = false;
        });
        Toast.show("Invalid age");
      }
    }
    if(_selectedGender.gender != null){
      provider.setGender(_selectedGender.gender);
    }
    if(provider.getNidInformationParseViewModel() != null ) {
      if(_clickable) {
        _showConfirmDialog();
      }
    }
  }
  @override
  bool get wantKeepAlive => true;

  @override
  RegisterPagePresenter createPresenter() {
    return RegisterPagePresenter();
  }

  void _updateProfile() async {
    var data = registrationDataHolder.getUserData();
    if (provider != null ) {
        var response = await presenter.profileUpdate(data,
            provider.getNidInformationParseViewModel());
        if (response.isSuccess ) {
          _showSuccessDialog();
        }
    }
  }

  onGenderTypeChange(Gender genderType) {
    setState(() {
      _isGenderChangedByUser = true;
      _selectedGender = genderType;
      _verify();
    });
  }

  void _showSuccessDialog() {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).submit,
            cancelText: "",
            title: AppLocalizations.of(context).profile,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppLocalizations.of(context).profileUpdate,
                  textAlign: TextAlign.center),
            ),
            onPressed: () {
              NavigatorUtils.push(context, Routes.home,
                  replace: true, clearStack: true);
            },
          );
        });
  }

  void _showConfirmDialog() {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: 'Edit',
            title: AppLocalizations.of(context).profile,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: FileImage(imageFile),
                        onBackgroundImageError: (dynamic, stacktrace) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name (English)'),
                        Flexible(child: Text(provider.getNidInformationParseViewModel().nameEnglish,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold),))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name (Bengali)'),
                        Flexible(child: Text(provider.getNidInformationParseViewModel().nameBangla,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold),))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).getUserFathersName),
                        Flexible
                          (child: Text(provider.getNidInformationParseViewModel().fathersName,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold),))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).getUserMothersName),
                        Flexible(
                            child: Text(provider.getNidInformationParseViewModel().mothersName,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold),))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Gender"),
                        Flexible(
                            child: Text(provider.getNidInformationParseViewModel().gender,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold),))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).getUserDOBName),
                        Flexible(
                            child: Text(provider.getNidInformationParseViewModel().dateOfBirth,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold),))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).getUserNIDNo),
                        Flexible(
                            child: Text(provider.getNidInformationParseViewModel().nidNumber,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold),))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 24),
                    child: Text(AppLocalizations.of(context).profileAgreement,textAlign: TextAlign.start,style: TextStyle(fontSize: Dimens.font_sp12),),
                  )
                ],
              ),
            ),
            onPressed: () {
              _updateProfile();
              NavigatorUtils.goBack(context);
            },
            onBackPressed:() {
              NavigatorUtils.goBack(context);
            }
          );
        });
  }
}