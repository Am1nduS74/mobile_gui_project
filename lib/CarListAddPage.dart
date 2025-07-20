import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'Data/DAO/CarDAO.dart';
import 'Data/Entity/Car_list.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';

  class CarListAddPage extends StatefulWidget {
    final CarList? editCar;
  const CarListAddPage({super.key, this.editCar});


  @override
  State<CarListAddPage> createState() => _CarListPageState();
  }

class _CarListPageState extends State<CarListAddPage> {
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _passengers = TextEditingController();
  final TextEditingController _size = TextEditingController();

  bool get isEditing => widget.editCar != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      _brand.text = widget.editCar!.brand;
      _model.text = widget.editCar!.model;
      _passengers.text = widget.editCar!.nuOfPassengers.toString();
      _size.text = widget.editCar!.tankSize.toString();
    }
  }

  Future<void> removeCars() async {
    if (isEditing) {
      await database.carDAO.deleteCar(widget.editCar!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car deleted successfully !! ')),
      );
      Navigator.pop(context);
    }
  }

    Future<void> addCar() async {
      final brand = _brand.text;
      final model = _model.text;
      final nuOfPassengers = _passengers.text;
      final tankSize = _size.text;

      if (brand.isEmpty || model.isEmpty || nuOfPassengers.isEmpty ||
          tankSize.isEmpty) {
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

      if (isEditing) {
        final updatedCar = CarList(widget.editCar!.id, brand, model, parsedPassengers, parsedTankSize);
        await database.carDAO.updateCar(updatedCar);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car Updated Successfully!')),
        );
        Navigator.pop(context);
      }
      else {
        final newCar = CarList(DateTime.now().millisecondsSinceEpoch, brand, model, parsedPassengers, parsedTankSize);

        await database.carDAO.insertCar(newCar);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car Added Successfully!')),
        );
        Navigator.pop(context);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title:Text(isEditing ? 'Update the Car' : 'Add a new car')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: _brand,
                decoration: const InputDecoration(
                    labelText: "Car Brand", border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _model,
                decoration: const InputDecoration(
                    labelText: "Car Model", border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _passengers,
                decoration: const InputDecoration(
                    labelText: "Number of Passengers",
                    border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _size,
                decoration: const InputDecoration(labelText: "Size of the tank",
                    border: OutlineInputBorder()),),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(onPressed: addCar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 60),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(isEditing ? 'Update  Car' : 'Add Car'),
                ),
              ),
              SizedBox(height: 10),
              if (isEditing)
                ElevatedButton(onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {

                      return AlertDialog(
                        title: Text('Delete Car'),
                        content: Text(
                            'Are you sure you want to delete the car?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              removeCars();
                            },
                            child: Text('Proceed'),
                          ),
                        ],
                      );
                    },
                  );
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 60),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text('Delete Car'),
                ),
            ],
          ),
        ),
      );
    }
  }