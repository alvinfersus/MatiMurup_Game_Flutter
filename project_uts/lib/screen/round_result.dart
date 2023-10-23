import 'package:flutter/material.dart';
import 'package:project_uts/screen/game.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RoundResult extends StatefulWidget {
  @override
  _RoundResultState createState() => _RoundResultState();
}

class _RoundResultState extends State<RoundResult> {
  //Initial variable for storing data in shared preferences
  String _pemain1 = '';
  String _pemain2 = '';
  String _jum_ronde = '';
  String _tingkat_kesulitan = '';
  List<String> _listWinnerStatus = [];

  int _currentRound = 0;
  List<String> _lastResult = [];

  void initState(){
    super.initState();
    _loadGameData();
  }

  //Load game data from shared preferences
  Future<void> _loadGameData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pemain1 = prefs.getString("pemain1") ?? '';
      _pemain2 = prefs.getString("pemain2") ?? '';
      _jum_ronde = prefs.getString("jumlah_ronde") ?? '';
      _tingkat_kesulitan = prefs.getString("kesulitan") ?? '';

      //Retrieve list of winner in every round
      String _listWinner = prefs.getString('list_winner') ?? '';
      if(_listWinner != ''){
        _listWinnerStatus = (jsonDecode(_listWinner) as List<dynamic>).cast<String>();
      }

      _currentRound = _listWinnerStatus.length;
      _lastResult = _listWinnerStatus[_currentRound-1].split('-');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30.0),
        child: Center(
          child: Column(children: [
            Text('Hasil Ronde ${_currentRound} (Level: ${_tingkat_kesulitan})',
                style: const TextStyle(fontSize: 18)),
            Text('${_pemain1} vs ${_pemain2}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 150.0, bottom: 150.0),
              child: Text(_lastResult.length >= 2 ? _lastResult[1].split(':')[1] : "Data Tidak Tersedia",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Game(
                    round: (_currentRound+1),
                  )));
                },
                child: Text('Lanjut Ronde ${(_currentRound+1)}'),
              )
            )
          ]),
        ),
      ),
    );
  }
}