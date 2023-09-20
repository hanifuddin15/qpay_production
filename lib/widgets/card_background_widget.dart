import 'package:flutter/material.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/utils/card_utils.dart';

Card CardBackgroudView(
    {@required BuildContext context,
      @required CardType cardType,
      @required String cardIssuedBankImage,
      @required String cardIssuedBank,
      @required String cardNumber,
      @required String cardHolder,
      @required String cardExpiration}) {
  return Card(
    elevation: 8.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    child: Container(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              fit: BoxFit.cover,
              //I assumed you want to occupy the entire space of the card
              image: AssetImage(
                getCardBg(cardType),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*cardIssuedBankImage != ""?Container(
                      width:32,
                      height: 32,
                      decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(cardIssuedBankImage),
                          fit: BoxFit.fill,
                          scale: 10,
                        ),
                      ),
                    ):Container(),
                    Gaps.hGap8,*/
                    Text(
                      '$cardIssuedBank',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.font_sp16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'HelveticaNeue'),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            /* Here we are going to place the Card number */
                            child: Text(
                              '$cardNumber',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.font_sp22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OCR'),
                            ),
                          ),
                        ],
                      ),
                      Gaps.vGap16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          cardExpiration != "N/A"
                              ? _buildDetailsBlock(
                            time: 'Month/Year'.toUpperCase(),
                            label: 'VALID \nTHRU',
                            value: cardExpiration,
                          )
                              : Text(""),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$cardHolder',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.font_sp16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OCR'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Row _buildDetailsBlock(
    {@required String time, @required String label, @required String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        '$label',
        style: TextStyle(
            color: Colors.white,
            fontSize: Dimens.font_sp10,
            fontWeight: FontWeight.bold,
            fontFamily: 'OCR'),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$time',
            style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.font_sp10,
                fontWeight: FontWeight.bold,
                fontFamily: 'OCR'),
          ),
          Gaps.vGap4,
          Text(
            '$value',
            style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.font_sp18,
                fontWeight: FontWeight.bold,
                fontFamily: 'OCR'),
          ),
        ],
      ),
    ],
  );
}

String getCardBg(CardType cardType) {
  switch (cardType) {
    case CardType.Visa:
      return 'assets/images/cards/visa_card_bg.png';
      break;
    case CardType.MasterCard:
      return 'assets/images/cards/master_card_bg.png';
      break;
    case CardType.AmericanExpress:
      return 'assets/images/cards/amex_card_bg.png';
      break;
    default:
      return 'assets/images/cards/default_card_bg.png';
      break;
  }
}