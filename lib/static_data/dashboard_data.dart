class DashboardImages {
  static final DashboardImages _singleton = DashboardImages._internal();

  factory DashboardImages() => _singleton;

  DashboardImages._internal();

  List<String> get serviceImages => [
        'dashboard/mobile_recharge',
        'dashboard/fund_transfer',
        'dashboard/card_bill_payment',
        'dashboard/wallet_icon',
        'dashboard/bill_pay_icon',
        'dashboard/change_cvv',
      ];


  List<String> get mainMenuImages => [
        'dashboard/add_account',
        'dashboard/add_beneficiary',
        'dashboard/atm_cash_out'
      ];

  List<String> get placeHolderImages =>[
    'dashboard/message',
    'dashboard/appuseravatar'
  ];

}

class DashboardTitles {
  static final DashboardTitles _singleton = DashboardTitles._internal();

  factory DashboardTitles() => _singleton;

  DashboardTitles._internal();

  List<String> get mainMenuTitles =>
      ['Add Card', 'Add Beneficiary', 'Cash By Code'];

  List<String> get servicesTitles => [
        'Mobile \nRecharge',
        'Fund \nTransfer',
        'Credit Card \nBill Payment',
        'Wallet \nTransfer',
        'Bill Payment', 'Generate \nOwn CVV2',
      ];
}
