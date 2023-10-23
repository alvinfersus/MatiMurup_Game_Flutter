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
        'game': (context) => Game(listHasil: [], ronde: 1),
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
      _tingkat_kesulitan = prefs.getString("kesulitan") ?? 'Pilih Tingkat Kesulitan';
    });
  }

  void start() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("pemain1", _pemain1_cont.text);
    prefs.setString("pemain2", _pemain2_cont.text);
    prefs.setString("jumlah_ronde", _jum_ronde_cont.text);
    prefs.setString("kesulitan", _tingkat_kesulitan);
    Navigator.pushNamed(context, "game");
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
          children: <Widget>[
            TextField(
              controller: _pemain1_cont,
              decoration: const InputDecoration(
                labelText: 'Nama Pemain #1',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (v) {},
            ),
            TextField(
              controller: _pemain2_cont,
              decoration: const InputDecoration(
                labelText: 'Nama Pemain #2',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (v) {},
            ),
            TextField(
              controller: _jum_ronde_cont,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Ronde',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (v) {},
            ),
            DropdownButton(
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
            ElevatedButton(
                style: ButtonStyle(elevation: MaterialStateProperty.all(5)),
                onPressed: () {
                  start();
                },
                child: Text('MULAI'))
          ],
        ),
      ),
    );
  }
}
