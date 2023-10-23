import 'package:flutter/material.dart';
import 'package:project_uts/main.dart';
import 'package:project_uts/screen/game.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RoundFinish extends StatefulWidget {
  @override
  _RoundFinishState createState() => _RoundFinishState();
}

class _RoundFinishState extends State<RoundFinish> {
  //Initial variable for storing data in shared preferences
  String _pemain1 = '';
  String _pemain2 = '';
  List<String> _listWinnerStatus = [];
  List<String> _lastResult = [];
  List<Map<String, dynamic>> _listHasil = [];

  List<String> _lastResultRound = [];
  List<String> _lastResultWinner = [];

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  //Load game data from shared preferences
  Future<void> _loadGameData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pemain1 = prefs.getString("pemain1") ?? '';
      _pemain2 = prefs.getString("pemain2") ?? '';

      //Retrieve list of winner in every round
      String _listWinner = prefs.getString('list_winner') ?? '';
      if (_listWinner != '') {
        _listWinnerStatus = (jsonDecode(_listWinner) as List<dynamic>).cast<String>();
      }
      print('length: ${_listWinnerStatus.length}');
      for (var i = 0; i < _listWinnerStatus.length; i++) {
        _lastResult = _listWinnerStatus[i].split('-');
        _lastResultRound = _lastResult[0].split(':');
        _lastResultWinner = _lastResult[1].split(':');
        _listHasil.add({'round': _lastResultRound[1], 'winner': _lastResultWinner[1]});
      }
    });
  }

  void PlayAgain() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('list_winner', '');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Game(
                  round: 1,
                )));
  }

  void MainMenu() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('list_winner', '');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Text(
                'Hasil Permainan',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '$_pemain1 vs $_pemain2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ]),
            SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Ronde')),
                  DataColumn(label: Text('Hasil')),
                ],
                rows: _listHasil.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item['round'])),
                      DataCell(Text(item['winner'])),
                    ],
                  );
                }).toList(),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ElevatedButton(
                onPressed: () {
                  PlayAgain();
                },
                child: Text("MAIN LAGI "),
              ),
              ElevatedButton(
                onPressed: () {
                  MainMenu();
                },
                child: Text("MENU UTAMA"),
              ),
            ])
          ],
        )),
      ),
    );
  }
}
