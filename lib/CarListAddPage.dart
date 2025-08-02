import 'package:flutter/material.dart';
import 'Data/Database.dart';
import 'Data/DAO/CarDAO.dart';
import 'Data/Entity/Car_list.dart';
import 'CarListPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'app_localizations.dart';

  class CarListAddPage extends StatefulWidget {
    final CarList? editCar;
    final CarList? copyCar;
  const CarListAddPage({super.key, this.editCar, this.copyCar});


  @override
  State<CarListAddPage> createState() => _CarListPageState();
  }

class _CarListPageState extends State<CarListAddPage> {
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _passengers = TextEditingController();
  final TextEditingController _size = TextEditingController();


  bool get isEditing => widget.editCar != null;
  bool get isCopying => widget.copyCar != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      _brand.text = widget.editCar!.brand;
      _model.text = widget.editCar!.model;
      _passengers.text = widget.editCar!.nuOfPassengers.toString();
      _size.text = widget.editCar!.tankSize.toString();
    }

    if (isCopying) {
      _brand.text = widget.copyCar!.brand;
      _model.text = widget.copyCar!.model;
      _passengers.text = widget.copyCar!.nuOfPassengers.toString();
      _size.text = widget.copyCar!.tankSize.toString();
    }
  }

  Future<void> removeCars() async {
    if (isEditing) {
      await database.carDAO.deleteCar(widget.editCar!);
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppLocalizations.of(context)!.translate('car_deleted_success'))),
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
           SnackBar(content: Text(AppLocalizations.of(context)!.translate('complete_all_fields'))),
        );
        return;
      }
      final parsedPassengers = int.tryParse(nuOfPassengers);
      final parsedTankSize = double.tryParse(tankSize);

      if (parsedPassengers == null || parsedTankSize == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.translate('invalid_format'))),
        );
        return;
      }

      if (isEditing) {
        final updatedCar = CarList(widget.editCar!.id, brand, model, parsedPassengers, parsedTankSize);
        await database.carDAO.updateCar(updatedCar);

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.translate('car_updated_success'))),
        );
        Navigator.pop(context);
      }
      else {
        final newCar = CarList(DateTime.now().millisecondsSinceEpoch, brand, model, parsedPassengers, parsedTankSize);
        await database.carDAO.insertCar(newCar);
        final encryptedPrefs = EncryptedSharedPreferences();

        await encryptedPrefs.setString('lastBrand', brand);
        await encryptedPrefs.setString('lastModel', model);
        await encryptedPrefs.setString('lastNuPassengers', parsedPassengers.toString());
        await encryptedPrefs.setString('lastTankSize', parsedTankSize.toString());

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.translate('car_added_success'))),
        );
        Navigator.pop(context);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title:Text(isEditing ? AppLocalizations.of(context)!.translate('update_car_title') : AppLocalizations.of(context)!.translate('add_car_title'))),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: _brand,
                decoration:  InputDecoration(
                    labelText: AppLocalizations.of(context)!.translate('car_brand'), border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _model,
                decoration:  InputDecoration(
                    labelText: AppLocalizations.of(context)!.translate('car_model'), border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _passengers,
                decoration:  InputDecoration(
                    labelText: AppLocalizations.of(context)!.translate('number_of_passengers'),
                    border: OutlineInputBorder()),),
              SizedBox(height: 10),
              TextField(controller: _size,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.translate('tank_size_label'),
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
                  child: Text(isEditing ? AppLocalizations.of(context)!.translate('update_car_button') : AppLocalizations.of(context)!.translate('add_car_button')),
                ),
              ),
              SizedBox(height: 10),
              if (isEditing)
                ElevatedButton(onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {

                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.translate('delete_car_title')),
                        content: Text(
                            AppLocalizations.of(context)!.translate('delete_car_confirmation')),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!.translate('cancel')),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              removeCars();
                            },
                            child: Text(AppLocalizations.of(context)!.translate('proceed')),
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
                  child: Text(AppLocalizations.of(context)!.translate('delete_car_button')),
                ),
            ],
          ),
        ),
      );
    }
  }