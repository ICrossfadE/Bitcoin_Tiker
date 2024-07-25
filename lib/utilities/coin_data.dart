import 'package:bitcoin_ticker/services/networking.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'Аня',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String _api = '914D34A2-6AAF-42BB-A711-D1B4EDC27B4F';
const String url = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  double? raate;

  CoinData({this.raate});

  Future<dynamic> getRateCarrensy(String crypto, String fiat) async {
    if (fiat != '' && crypto != '') {
      NetworkHelper networkHelper =
          NetworkHelper('$url/$crypto/$fiat?apikey=$_api');
      dynamic coinData = await networkHelper.getCoinData();
      return coinData;
    }
  }
}
