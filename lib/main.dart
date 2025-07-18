import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'CarListAddPage.dart';

late AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: const MyHomePage(title: 'Car List'),
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

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final cars = await database.carDAO.getAllCars();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => CarListAddPage()),);},
                        child: Text('Click Here to Add a Car'))
                  ],
                ),
              ],
            ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
    );
  }
}
