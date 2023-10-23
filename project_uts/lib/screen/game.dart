import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_uts/class/grid.dart';
import 'package:project_uts/screen/round_result.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  final int round;

  Game({required this.round});

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
  List<String> _listWinnerStatus = [];

  //Global Variable for all logic in this screen
  List<int> _randomAns = [];
  List<int> _randomAnsBefore = [];
  String _instruction = '';
  String _presentPlayer = '';
  int _sequencePressed = 0;
  int _scoreCurrPlayer = 0;

  int _scorePlayer1 = 0;
  int _scorePlayer2 = 0;

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

        //Retrieve list of winner in every round
        String _listWinner = prefs.getString('list_winner') ?? '';
        if(_listWinner != ''){
          _listWinnerStatus = (jsonDecode(_listWinner) as List<dynamic>).cast<String>();
        }
      });
    
    //Load _tingkat_kesulitan and set grid based on _tingkat_kesulitan
    if (_tingkat_kesulitan == "Gampang") {
      _grid = 3;
    } else if (_tingkat_kesulitan == "Sedang") {
      _grid = 6;
    } else if(_tingkat_kesulitan == "Susah") {
      _grid = 9;
    }

    _instruction = "Hafalkan Polanya!";
    _presentPlayer = _pemain1;
  }

  //Choosing Box
  void ChoosingBox(int tappedIndex) {
    if(_interaction){
      if(tappedIndex == _randomAnsBefore[_sequencePressed]){
        _sequencePressed++;
        _scoreCurrPlayer++;

        //Check if the player already guess all the box or not
        if(_sequencePressed == _randomAnsBefore.length){
            showDialog(
            context: context, 
            builder: (BuildContext context) => AlertDialog(
              title: Text('Selamat!'),
              content: Text('Kamu hebat $_presentPlayer, semua urutan benar'),
              actions: <Widget>[
                TextButton(
                  onPressed: (){
                    Navigator.pop(context, 'OK');
                    SwitchTurn();
                }, 
                child: const Text('OK'))
              ],
            )
          );
        }

      } else {
        showDialog(
          context: context, 
          builder: (BuildContext context) => AlertDialog(
            title: Text('Oops, Urutan Salah!'),
            content: Text('Sayang sekali $_presentPlayer, kamu menekan urutan yang salah'),
            actions: <Widget>[
              TextButton(onPressed: (){
                Navigator.pop(context, 'OK');
                SwitchTurn();
              }, 
              child: const Text('OK'))
            ],
          )
        );
      }
    }
  }

  //Switch player turn
  void SwitchTurn() {
    setState(() {
      if(_presentPlayer == _pemain1){
        print('masuk sini');
        _scorePlayer1 += _scoreCurrPlayer;
        _presentPlayer = _pemain2;
        _instruction = 'Hafalkan polanya';
        _interaction = false;
        _activeBoxStatus = true;
        _sequencePressed = 0;
        GridAnimation();
      } else {
        _scorePlayer2 += _scoreCurrPlayer;
        CheckWinner();

        if(_listWinnerStatus.length >= int.parse(_jum_ronde)){

        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RoundResult()));
        }
      }
      _scoreCurrPlayer = 0;
    });
  }

  //Method to check the winner and call the SaveWinner to save it into shared preferences
  void CheckWinner(){
    String _result = '';
    if(_scorePlayer1 > _scorePlayer2){
      _listWinnerStatus.add('round: ${widget.round}-winner: $_pemain1');
    } else if (_scorePlayer2 > _scorePlayer1){
      _listWinnerStatus.add('round: ${widget.round}-winner: $_pemain2');
    } else {
      _listWinnerStatus.add('round: ${widget.round}-winner: seimbang');
    }
    SaveWinner();
  }

  //Save winner status to shared preferences
  Future<void> SaveWinner() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = jsonEncode(_listWinnerStatus);
    prefs.setString('list_winner', result);
  }

  //Grid Animation
  void GridAnimation(){
    _randomAns.clear();
    for(int i=0; i<_grid; i++){
      _randomAns.add(Random().nextInt(_grid));
    }
    print(_randomAns);

    // Future.delayed(Duration(milliseconds: 300), () {
    //   setState(() {
    //     _activeBoxStatus = false; 
    //   });
    // });

    Timer(Duration(milliseconds: 300), (){
      setState(() {
        _activeBoxStatus = false;
      });
    });

    timerBox = Timer.periodic(Duration(milliseconds: 800), (Timer t) {
      // Future.delayed(Duration(milliseconds: 300), () {
      //   setState(() {
      //     _activeBoxStatus = false; 
      //   });
      // });

      setState(() {
        _activeBoxStatus = true; 
        if(_inActiveStatus < _grid-1){
          _inActiveStatus = (_inActiveStatus + 1);
        } else {
          timerBox.cancel();
          StartAnswer();
        }
      });

      Timer(Duration(milliseconds: 500), (){
        setState(() {
          _activeBoxStatus = false;
        });
      });
    });
  }

  //This method call after all animation was done
  void StartAnswer(){
    setState(() {
      _interaction = true;
      _instruction = 'Tekan tombol sesuai urutan yang ada hafalkan!';
      _activeBoxStatus = false;
      _inActiveStatus = 0;
      
      //Store the current answer before it randomize again
      _randomAnsBefore = _randomAns;

      // for(int i=0; i<_grid; i++){
      //   _randomAns.add(Random().nextInt(_grid));
      // }
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