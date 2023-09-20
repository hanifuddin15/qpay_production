import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/providers/cash_out_token_provide.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/dashboard_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/atm_cashout/atm_cashout_iview.dart';
import 'package:qpay/views/atm_cashout/atm_cashout_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/cash_out_token_list_container.dart';
import 'package:qpay/widgets/my_dialog.dart';

class AtmCashOutTokensPage extends StatefulWidget {
  @override
  _AtmCashOutTokensPageState createState() => _AtmCashOutTokensPageState();
}

class _AtmCashOutTokensPageState extends State<AtmCashOutTokensPage>
    with
        BasePageMixin<AtmCashOutTokensPage, AtmCashOutPresenter>,
        AutomaticKeepAliveClientMixin<AtmCashOutTokensPage>
    implements AtmCashOutIMvpView {
  ApiBasicViewModel _responseModel;
  List<CashOutTokenViewModel> _validCashOutTokens = <CashOutTokenViewModel>[];
  List<CashOutTokenViewModel> _expiredCashOutTokens = <CashOutTokenViewModel>[];
  List<CashOutTokenViewModel> _reversedCashOutTokens = <CashOutTokenViewModel>[];
  List<CashOutTokenViewModel> _reversePendingCashOutTokens = <CashOutTokenViewModel>[];
  List<CashOutTokenViewModel> _withdrawnCashOutTokens = <CashOutTokenViewModel>[];
  CashOutTokenProvider _cashOutTokenProvider = CashOutTokenProvider();

  @override
  void initState() {
    _cashOutTokenProvider.addListener(_reLoadTokens);
    super.initState();
  }

  Future<void>  _reLoadTokens() async{
    await presenter.loadCashOutTokens();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          isBack: true,
          centerTitle: AppLocalizations.of(context).cashByCodeTokens,
        ),
        body:  DefaultTabController(
          length: 5,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                      isScrollable: true,
                      labelColor: Colours.app_main,
                      unselectedLabelColor: Colours.text_gray,
                      tabs: [
                        Tab(
                          text:  AppLocalizations.of(context).validToken,
                        ),
                        Tab(
                          text: AppLocalizations.of(context).expiredToken,
                        ),
                        Tab(
                          text: AppLocalizations.of(context).reverseToken,
                        ),
                        Tab(
                          text: AppLocalizations.of(context).reversePendingToken,
                        ),
                        Tab(
                          text: AppLocalizations.of(context).withdrawnToken,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                 CashOutTokenListContainer(context, _validCashOutTokens, null,_onRefresh),
                  CashOutTokenListContainer(context, _expiredCashOutTokens, null,_onRefresh),
                  CashOutTokenListContainer(context, _reversedCashOutTokens, null,_onRefresh),
                  CashOutTokenListContainer(context, _reversePendingCashOutTokens, null,_onRefresh),
                  CashOutTokenListContainer(context, _withdrawnCashOutTokens, null,_onRefresh)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  AtmCashOutPresenter createPresenter() {
    return AtmCashOutPresenter(true);
  }

  @override
  void setTokens(List<CashOutTokenViewModel> tokens) {
    if(mounted) {
      setState(() {
        _validCashOutTokens =
            tokens.where((element) => element.status == 'Valid').toList();
        _expiredCashOutTokens =
            tokens.where((element) => element.status == 'Revoked' ||
                element.status == 'Expired').toList();
        _reversedCashOutTokens =
            tokens.where((element) => element.status == 'Reversed').toList();
        _reversePendingCashOutTokens =
            tokens.where((element) => element.status == 'ReversePending')
                .toList();
        _withdrawnCashOutTokens =
            tokens.where((element) => element.status == 'Withdrawn').toList();
      });
    }
  }

  Future<void> _onRefresh() async {
    await presenter.loadCashOutTokens();
  }

  @override
  bool get wantKeepAlive => true;

  void _extendTime(CashOutTokenViewModel cashOutToken) async{
    var response = await presenter.extendToken(
        cashOutToken.transactionId);
    if (response != null){
      _responseModel = response;
      if (_responseModel.isSuccess ) {
        _showSuccessDialog();
      }else{
        _showErrorDialog(_responseModel.errorMessage);
      }
    }
  }
  void _showSuccessDialog() {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText:"",
            title: AppLocalizations.of(context).cashOutTokenTimeExtend,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppLocalizations.of(context).cashOutTokenTimeExtendMessage, textAlign: TextAlign.center,),
            ),
            onPressed:() {
              _onRefresh();
              NavigatorUtils.goBack(context);
            },
          );
        });
  }

  void _showErrorDialog(String message) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: "",
            cancelText: AppLocalizations.of(context).okay,
            title: AppLocalizations.of(context).cashOutTokenTimeExtend,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(message, textAlign: TextAlign.center,),
            ),
            onBackPressed:() {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }

  @override
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel) {

  }
}
