import 'package:flutter/material.dart';
import 'package:mobile_gui_project/Data/Entity/Car_list.dart';
import 'Data/Database.dart';
import 'CarListAddPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          textTheme: GoogleFonts.averageSansTextTheme(),
      ),
      home: const HomePage(title: 'Car List'),

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

  void viewCar(CarList car) {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>CarListAddPage(editCar: car),
    ),
    ).then((_) async {
      await _loadCars();
    });
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
                             onTap: (){
                               final item = items[index];
                               viewCar(item);
                             },
                             child: Card(
                              elevation: 8,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('${index+1}:Brand: ${item.brand}', style: GoogleFonts.averageSans( textStyle: const TextStyle(fontSize: 40)),),),
                                    Expanded(child: Text('Model: ${item.model}', style: GoogleFonts.averageSans( textStyle: const TextStyle(fontSize: 40)),),),
                                    Expanded(child:  Text('Max Passengers: ${item.nuOfPassengers}', style: GoogleFonts.averageSans( textStyle: const TextStyle(fontSize: 40)),),),
                                    Expanded(child: Text('Tank size: ${item.tankSize} litres', style: GoogleFonts.averageSans( textStyle: const TextStyle(fontSize: 40)),),)
                                   ],
                                ),
                              )
                             )
                           );
                        }),
                ),
                SizedBox(
                width: double.infinity,
                height: 50,
                child:ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CarListAddPage()),
                    );
                    _loadCars();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 60),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text('Click Here to Add a Car'),
                ),
                )
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
