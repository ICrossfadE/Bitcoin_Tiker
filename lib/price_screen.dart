import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'dart:io' show Platform;

import 'utilities/coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedFiatCurrency;
  Map<String, dynamic>? carensyData;
  String? rateBTC;
  String? rateETH;
  String? rateLTC;

  CoinData coinData = CoinData();

  @override
  void initState() {
    super.initState();
    getCarennsyData('BTC', 'USD');
    getCarennsyData('ETH', 'USD');
    getCarennsyData('LTC', 'USD');
  }

  dynamic getCarennsyData(
    String crypto,
    String fiat,
  ) async {
    var data = await coinData.getRateCarrensy(crypto, fiat);
    updateUI(data, crypto);
  }

  void updateUI(dynamic data, String cryptoCurrency) {
    setState(() {
      if (data != null) {
        double number = data['rate'];
        String rate = number.toStringAsFixed(2);
        if (cryptoCurrency == 'BTC') {
          rateBTC = rate;
        } else if (cryptoCurrency == 'ETH') {
          rateETH = rate;
        } else if (cryptoCurrency == 'LTC') {
          rateLTC = rate;
        }
        print('$cryptoCurrency rate: $rate');
      }
    });
  }

  DropdownButton<String> androidDropdown(
      List<String> list, String? selected, Function(String?) onChangeCallback) {
    return DropdownButton<String>(
      hint: const Text('choose currency'),
      value: selected,
      items: list
          .map((String listValue) =>
              DropdownMenuItem(value: listValue, child: Text(listValue)))
          .toList(),
      onChanged: (value) {
        onChangeCallback(value);
        getCarennsyData('BTC', value!);
        getCarennsyData('ETH', value);
        getCarennsyData('LTC', value);
      },
    );
  }

  List<Card> getCards(List<String> list, rates, selected) {
    List<Card> cards = [];

    for (String listValue in list) {
      var rate = rates[listValue] ?? '0.00';
      var newItem = Card(
        color: const Color.fromARGB(255, 45, 158, 22),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $listValue = $rate ${selected ?? 'USD'}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );

      cards.add(newItem);
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> rates = {
      'BTC': rateBTC ?? '0.00',
      'ETH': rateETH ?? '0.00',
      'LTC': rateLTC ?? '0.00',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getCards(cryptoList, rates, selectedFiatCurrency),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 10),
                color: const Color.fromARGB(255, 67, 3, 244),
                child: androidDropdown(
                  currenciesList,
                  selectedFiatCurrency,
                  (value) => setState(() {
                    selectedFiatCurrency = value;
                    getCarennsyData('BTC', value!);
                    getCarennsyData('ETH', value);
                    getCarennsyData('LTC', value);
                  }),
                ),
              )),
            ],
          )
        ],
      ),
    );
  }
}
