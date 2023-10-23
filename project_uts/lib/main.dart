import 'package:flutter/material.dart';
import 'package:project_uts/screen/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Setup Permainan'),
      routes: {
        'game': (context) => Game(round: 1),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _pemain1_cont = TextEditingController();
  final TextEditingController _pemain2_cont = TextEditingController();
  final TextEditingController _jum_ronde_cont = TextEditingController();
  String _tingkat_kesulitan = "Pilih Tingkat Kesulitan";

  //Validation
  String _validationError1 = '';
  String _validationError2 = '';
  String _validationError3 = '';

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  Future<void> _loadGameData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pemain1_cont.text = prefs.getString("pemain1") ?? '';
      _pemain2_cont.text = prefs.getString("pemain2") ?? '';
      _jum_ronde_cont.text = prefs.getString("jumlah_ronde") ?? '';
      _tingkat_kesulitan =
      prefs.getString("kesulitan") ?? 'Pilih Tingkat Kesulitan';
    });
  }

  void start() async {
    bool validation = true;
    
    //Validation for pemain1
    if(_pemain1_cont.text.isEmpty){
      setState(() {
        _validationError1 = 'Nama pemain 1 tidak boleh kosong!';
      });
      validation = false;
    } else {
      setState(() {
        _validationError1 = '';
      });
    }

    //Validation for pemain2
    if(_pemain2_cont.text.isEmpty){
      setState(() {
        _validationError2 = 'Nama pemain 2 tidak boleh kosong!';
      });
      validation = false;
    } else if (_pemain1_cont.text == _pemain2_cont.text){
      setState(() {
        _validationError2 = 'Nama pemain tidak boleh sama!';
      });
      validation = false;
    } else {
      setState(() {
        _validationError2 = '';
      });
    }

    //Validation for jum_round
    if(_jum_ronde_cont.text.isEmpty){
      setState(() {
        _validationError3 = 'Jumlah ronde tidak boleh kosong!';
      });
      validation = false;
    } else if(int.tryParse(_jum_ronde_cont.text) == null){
      setState(() {
        _validationError3 = 'Jumlah ronde harus bilangan bulat!';
      });
      validation = false;
    } else if(int.parse(_jum_ronde_cont.text) > 10 || int.parse(_jum_ronde_cont.text) < 1){
      setState(() {
        _validationError3 = 'Jumlah ronde minimal 1 dan maksimal 10';
      });
      validation = false;
    } else {
      setState(() {
        _validationError3 = '';
      });
    }

    if(validation){
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("pemain1", _pemain1_cont.text);
      prefs.setString("pemain2", _pemain2_cont.text);
      prefs.setString("jumlah_ronde", _jum_ronde_cont.text);

      if(_tingkat_kesulitan == "Pilih Tingkat Kesulitan"){
        _tingkat_kesulitan = "Gampang";
      }
      prefs.setString("kesulitan", _tingkat_kesulitan);
      Navigator.pushNamed(context, "game");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextField(
                  controller: _pemain1_cont,
                  decoration: InputDecoration(
                    labelText: 'Nama Pemain #1',
                    errorText: _validationError1,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onChanged: (v) {},
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextField(
                  controller: _pemain2_cont,
                  decoration: InputDecoration(
                    labelText: 'Nama Pemain #2',
                    errorText: _validationError2,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onChanged: (v) {},
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextField(
                  controller: _jum_ronde_cont,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Jumlah Ronde',
                    errorText: _validationError3,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onChanged: (v) {},
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: DropdownButton(
                  isExpanded: true,
                  hint: Text(_tingkat_kesulitan),
                  items: const [
                    DropdownMenuItem(
                      child: Text("Gampang"),
                      value: "Gampang",
                    ),
                    DropdownMenuItem(
                      child: Text("Sedang"),
                      value: "Sedang",
                    ),
                    DropdownMenuItem(
                      child: Text("Susah"),
                      value: "Susah",
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _tingkat_kesulitan = value!;
                    });
                  }),
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(5)),
                    onPressed: () {
                      start();
                    },
                    child: Text('MULAI')
                  ),
                )
              ],
            ),
          ),
        );
  }
}
