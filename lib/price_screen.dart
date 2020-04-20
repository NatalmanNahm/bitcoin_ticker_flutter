import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'services/openJson.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String convert;
  List<String> conversionList = [];
  String seletectedCurrency = 'USD';
  String _conversionBTC = "";
  String _conversionETH = "";
  String _conversionLTC = "";

  _PriceScreenState(){
    updateUI(currency: seletectedCurrency).then((value) => setState(() {
      conversionList = value;
      _conversionBTC = conversionList[0];
      _conversionETH = conversionList[1];
      _conversionLTC = conversionList[2];
    }));

  }

  Future<List<String>> updateUI({String currency}) async{
    List<String> conversionList = [];
    for (String crypto in cryptoList){
      var convertBTC = await OpenJsonData()
          .getBitcoinConvert(currency: currency, crypto: crypto);
      String conversion;
      setState(() {
        if(convertBTC == null){
          conversion = 'Unable to convert data.';
        }
        double rate = convertBTC['rate'];
        double rateDouble = rate.roundToDouble();
        conversion = '1 $crypto = $rateDouble $currency';
        conversionList.add(conversion);
      });
    }
    return conversionList;
  }

  DropdownButton<String> androidDropdown(){
    List<DropdownMenuItem<String>> dropDownItems = [];

    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
        value:seletectedCurrency,
        items: dropDownItems,
        onChanged: (value) async {
          List<String> newConvert =  await updateUI(currency: value);
          setState(() {
            seletectedCurrency = value;
            print(seletectedCurrency);
            _conversionBTC = newConvert[0];
            _conversionETH = newConvert[1];
            _conversionLTC = newConvert[2];
          });
        },
    );
  }

  CupertinoPicker iOSPicker(){
    List<Text> pickerItemList = [];
    for(String currency in currenciesList){
      var newItem = Text(currency);
      pickerItemList.add(newItem);
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async{
        List<String> newConvert = await
          updateUI(currency:currenciesList[selectedIndex]);
        setState(() {
          _conversionBTC = newConvert[0];
          _conversionETH = newConvert[1];
          _conversionLTC = newConvert[2];
        });

      },
      children: pickerItemList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ConversionField(conversion: _conversionBTC),
              ConversionField(conversion: _conversionETH),
              ConversionField(conversion: _conversionLTC),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class ConversionField extends StatelessWidget {
  ConversionField({@required this.conversion});

  final String conversion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            conversion,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

