import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mobile_gui_project/Data/Entity/Car_list.dart';
import 'Data/Database.dart';
import 'CarListAddPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

late AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');

  void changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [

        Locale('en', 'US'),
        Locale('es', 'ES'),

      ],

      localizationsDelegates: const[

        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
          textTheme: GoogleFonts.averageSansTextTheme(),
      ),
      home: Builder(
        builder: (context) {
          return const HomePage(title: 'Main Menu');
        },
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


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

  Future<CarList?> copyCar() async{
    final prefs = EncryptedSharedPreferences();
    final brand = await prefs.getString('lastBrand') ?? '';
    final model = await prefs.getString('lastModel') ?? '';
    final passengers = await prefs.getString('lastNuPassengers') ?? '';
    final tank = await prefs.getString('lastTankSize') ?? '';

    final parsedPassengers = int.tryParse(passengers);
    final parsedTankSize = double.tryParse(tank);

    if(parsedPassengers == null || parsedTankSize == null) {
      return null;
    }
    return CarList(DateTime.now().millisecondsSinceEpoch, brand, model, parsedPassengers, parsedTankSize);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded( child: items.isEmpty ? Center(
                child: Text(AppLocalizations.of(context)!.translate('no_cars'))):
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
                                      AppLocalizations.of(context)!.translate('deleteMsg')),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context)!.translate('no')),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        removeCars(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context)!.translate('yes')),
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
                    final copiedCar = await copyCar();

                    if(copiedCar != null) {
                      showDialog(context: context,
                          builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.translate('copyCar')),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CarListAddPage()),
                              ).then((_) => _loadCars());
                            },
                                child:  Text(AppLocalizations.of(context)!.translate('no')),
                            ),
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CarListAddPage(copyCar: copiedCar)),
                              ).then((_) => _loadCars());
                            },
                              child:  Text(AppLocalizations.of(context)!.translate('yes')),
                            ),
                          ],
                        );
                          }
                      );
                    }
                    else {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CarListAddPage()),
                    );
                    _loadCars();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 60),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(AppLocalizations.of(context)!.translate('addCar')),
                )
                )
              ],
            ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.translate('title')),
        actions: [
          PopupMenuButton<Locale>(
              icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
                MyApp.setLocale(context, locale);
            },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: const Locale('en', 'US'),
          child: const Text('English'),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('es', 'ES'),
          child: const Text('Español'),
          ),
        ],
      ),
    ],
    ),
  );
  }
}
