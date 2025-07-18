import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'Data/DAO/CarDAO.dart';
import 'Data/Entity/Car_list.dart';

late AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

}
  class CarListAddPage extends StatefulWidget {
  const CarListAddPage({super.key});

  @override
  State<CarListAddPage> createState() => _CarListPageState();
  }

class _CarListPageState extends State<CarListAddPage> {
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _passengers = TextEditingController();
  final TextEditingController _size = TextEditingController();

  Future<void> addCar() async {
    final brand = _brand.text;
    final model = _model.text;
    final passengers = _passengers.text;
    final size = _size.text;

    final newCar = CarList(DateTime.now().millisecondsSinceEpoch, brand, model, passengers, size);
    await database.carDAO.insertCar(newCar);

    final newItems = await database.carDAO.getAllCars();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: const Text('ADD A NEW CAR')),
     body: Padding(
       padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: _brand, decoration: const InputDecoration(labelText: "Car Brand", border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _model, decoration: const InputDecoration(labelText: "Car Model", border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _passengers, decoration: const InputDecoration(labelText: "Number of Passengers", border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _size, decoration: const InputDecoration(labelText: "Size of the tank", border: OutlineInputBorder()),),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(onPressed: addCar, child: const Text('Add car')),
              )

            ],

          ),
     ),
   );
  }
}