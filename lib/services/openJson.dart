import 'network.dart';

const apiKey = '4C2BE95E-3FB5-4C12-B6D1-CE7C564CB0C5';

class OpenJsonData {

  Future <dynamic> getBitcoinConvert() async {

    NetworkHelper networkHelper = NetworkHelper
      ('https://rest.coinapi.io/v1/exchangerate/BTC/USD?apiKey=$apiKey');

    var convertedBitcoin = await networkHelper.getBitcoinData();
    return convertedBitcoin;
  }
}