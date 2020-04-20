import 'network.dart';

const apiKey = '4C2BE95E-3FB5-4C12-B6D1-CE7C564CB0C5';
const apiKey2 = '066FFEBD-8FB8-4486-A9ED-AC7C38620890';
const apiK = '1D1CABFF-DA2C-4331-A314-50BE914421BB';

class OpenJsonData {

  Future <dynamic> getBitcoinConvert({String currency, String crypto}) async {
    NetworkHelper networkHelper = NetworkHelper
      ('https://rest.coinapi.io/v1/exchangerate/$crypto/$currency?apikey=$apiK');

    var convertedBitcoin = await networkHelper.getBitcoinData();
    return convertedBitcoin;
  }
}