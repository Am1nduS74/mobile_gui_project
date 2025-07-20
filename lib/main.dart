import 'package:flutter/material.dart';
import 'package:mobile_gui_project/Data/Entity/Car_list.dart';
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
  List<CarList> items = [];

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {

    final cars = await database.carDAO.getAllCars();
    setState(() {
      items = cars;
    });
  }

  Future<void> removeCars(int index) async {
    final removeCar = items[index];
    await database.carDAO.deleteCar(removeCar);

    await _loadCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded( child: items.isEmpty ? Center(
                child: Text('There is no car in the list')):
            ListView.builder(
                        itemCount : items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                           return GestureDetector(
                               onLongPress: (){
                                showDialog(context: context,
                                builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      'Do you want to delete this car from the list ? '),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        removeCars(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('${index+1}:Brand: ${item.brand}', style: TextStyle(fontSize: 35),),
                               SizedBox(width: 50),
                               Text('Model: ${item.model}', style: TextStyle(fontSize: 35),),
                               SizedBox(width: 50),
                               Text('Max Passengers: ${item.nuOfPassengers}', style: TextStyle(fontSize: 35),),
                               SizedBox(width: 50),
                               Text('Tank size: ${item.tankSize} litres', style: TextStyle(fontSize: 35),),
                               SizedBox(width: 50),
                             ],
                           ),
                           );
                        }),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CarListAddPage()),
                    );
                    _loadCars();
                  },
                  child: Text('Click Here to Add a Car'),
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
