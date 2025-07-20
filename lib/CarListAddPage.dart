import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'Data/DAO/CarDAO.dart';
import 'Data/Entity/Car_list.dart';
import 'main.dart';

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
    final nuOfPassengers = _passengers.text;
    final tankSize = _size.text;

    if(brand.isEmpty || model.isEmpty || nuOfPassengers.isEmpty || tankSize.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all the fields !! ')),
      );
      return;
    }
    final parsedPassengers = int.tryParse(nuOfPassengers);
    final parsedTankSize = double.tryParse(tankSize);

    if (parsedPassengers == null || parsedTankSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid format')),
      );
      return;
    }
    final newCar = CarList(DateTime.now().millisecondsSinceEpoch, brand, model, parsedPassengers, parsedTankSize);
    await database.carDAO.insertCar(newCar);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car Added Successfully!')),
    );
    Navigator.pop(context);

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