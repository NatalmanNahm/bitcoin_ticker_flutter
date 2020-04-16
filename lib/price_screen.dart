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
  String seletectedCurrency = 'USD';
  String _conversion = "";

  _PriceScreenState(){
    updateUI().then((value) => setState(() {
      _conversion = value;
    }));
  }

  Future<String> updateUI() async{
    var convertBTC = await OpenJsonData().getBitcoinConvert();
    String conversion;
    setState(() {
      if(convertBTC == null){
        conversion = 'Unable to convert data.';
      }
      double rate = convertBTC['rate'];
      double rateDouble = rate.roundToDouble();
      conversion = '1 BTC = $rateDouble USD';
    });
    return conversion;
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
        onChanged: (value){
          setState(() {
            seletectedCurrency = value;
            print(seletectedCurrency);
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
      onSelectedItemChanged: (selectedIndex){
        print(selectedIndex);
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
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
                  _conversion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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