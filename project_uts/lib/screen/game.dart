import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_uts/class/grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  final List<Map<String, dynamic>> listHasil;
  final int ronde;

  Game({required this.listHasil, required this.ronde});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  //Initial variable for storing data in shared preferences
  String _pemain1 = '';
  String _pemain2 = '';
  String _jum_ronde = '';
  String _tingkat_kesulitan = '';
  int _grid = 0;

  //Global Variable for all logic in this screen
  List<int> _randomAns = [];
  List<int> _randomAnsBefore = [];
  String _turn = '';
  String _instruction = '';
  String _presentPlayer = '';
  int _sequencePressed = 0;
  int _scoreCurrPlayer = 0;

  //Grid Field
  int _inActiveStatus = 0;
  bool _activeBoxStatus = true;
  bool _interaction = false;

  late Timer timerBox;

  @override
  void initState(){
    super.initState();
    _loadGameData().then((_){
      GridAnimation();
    });
  }

  //Load Game Data
  Future<void> _loadGameData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        _pemain1 = prefs.getString("pemain1") ?? '';
        _pemain2 = prefs.getString("pemain2") ?? '';
        _jum_ronde = prefs.getString("jumlah_ronde") ?? '';
        _tingkat_kesulitan = prefs.getString("kesulitan") ?? 'Pilih Tingkat Kesulitan';
      });
    
    //Load _tingkat_kesulitan and set grid based on _tingkat_kesulitan
    if (_tingkat_kesulitan == "Gampang") {
      _grid = 3;
    } else if (_tingkat_kesulitan == "Sedang") {
      _grid = 6;
    } else if(_tingkat_kesulitan == "Susah") {
      _grid = 9;
    }

    //Random answer
    for(int i=0; i<_grid; i++){
      _randomAns.add(Random().nextInt(_grid));
    }
    print(_randomAns);
    _turn = _pemain1;
    _instruction = "Hafalkan Polanya!";
    _presentPlayer = _pemain1;
  }

  void ChoosingBox(int tappedIndex) {
    if(_interaction){
      if(tappedIndex == _randomAnsBefore[_sequencePressed]){
        _sequencePressed++;
        _scoreCurrPlayer++;
      } else {
        showDialog(
          context: context, 
          builder: (BuildContext context) => AlertDialog(
            title: Text('Oops, Urutan Salah!'),
            content: Text('Sayang sekali $_presentPlayer, coba lagi nanti.'),
            actions: <Widget>[
              TextButton(onPressed: (){
                Navigator.pop(context, 'OK');
              }, 
              child: const Text('OK'))
            ],
          )
        );
      }
    }
  }

  //Grid Animation
  void GridAnimation(){
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _activeBoxStatus = false; 
      });
    });

    timerBox = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _activeBoxStatus = false; 
        });
      });

      setState(() {
        _activeBoxStatus = true; 
        if(_inActiveStatus < _grid-2){
          _inActiveStatus = (_inActiveStatus + 1);
        } else {
          timerBox.cancel();
          StartAnswer();
        }
      });
    });
  }

  //This method call after all animation was done
  void StartAnswer(){
    print(_interaction);
    setState(() {
      _interaction = true;
      _instruction = 'Tekan tombol sesuai urutan yang ada hafalkan!';
      _activeBoxStatus = true;
      
      //Store the current answer before it randomize again
      _randomAnsBefore = _randomAns;

      for(int i=0; i<_grid; i++){
        _randomAns.add(Random().nextInt(_grid));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Giliran $_presentPlayer',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '$_instruction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Text(
                //   '${formatTime(_elapsedTime)}',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: GameGrid(
                gridCount: _grid,
                activeBoxStatus: _activeBoxStatus,
                interaksi: _interaction,
                randomNumber: _randomAns,
                onTap: ChoosingBox,
                inActiveStatus: _randomAns[_inActiveStatus]
              ),
            ),
          )
        ],
      )
    );
  }
}