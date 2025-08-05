import 'package:flutter/material.dart';
import 'Data/Entity/dealership.dart';
import 'app_database.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'l10n/app_localizations.dart';

/// Page for adding or updating a dealership
class DealershipFormPage extends StatefulWidget {
  /// Indicates if a new dealership is being added
  final bool isAdding;
  final Dealership? dealership;
  /// The dealership to update if any
  final VoidCallback onUpdate;


  DealershipFormPage({required this.isAdding, this.dealership, required this.onUpdate});

  @override
  _DealershipFormPageState createState() => _DealershipFormPageState();
}

class _DealershipFormPageState extends State<DealershipFormPage> {
final _formKey = GlobalKey<FormState>(); ///Form key for validation
late TextEditingController nameController; /// Controller for the name field
late TextEditingController streetController; /// Controller for the street address
late TextEditingController cityController; /// Controller for the city
late TextEditingController postalController; /// Controller for the postal code
/// Instance of EncryptedSharedPreferences
EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
/// To copy data from the previous dealership
bool copyFromPrevious = false;

@override
void initState(){
  super.initState();
  nameController = TextEditingController(text: widget.dealership?.name ?? '');
  streetController = TextEditingController(text: widget.dealership?.streetAddress ?? '');
  cityController = TextEditingController(text: widget.dealership?.city ?? '');
  postalController = TextEditingController(text: widget.dealership?.postalCode ?? '');
}

/// Loads previous dealership data from encryptedSharedPreferences
Future<void> _loadPreviousData() async{
  try {
    final name = await prefs.getString('name');
    final street = await prefs.getString('streetAddress');
    final city = await prefs.getString('city');
    final postal = await prefs.getString('postalCode');
    setState(() {
      nameController.text = name ?? '';
      streetController.text = street ?? '';
      cityController.text = city ?? '';
      postalController.text = postal ?? '';
    });
  } catch (e){
    print('Error loading previous data: $e');
  }
}

// save the dealership to the database and update preference
Future<void> _saveDealership() async {
  if(_formKey.currentState!.validate()) {
    final name = nameController.text;
    final street = streetController.text;
    final city = cityController.text;
    final postal = postalController.text;
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final dao = database.dealershipDao;
    try{
      if (widget.isAdding) {
        final dealership = Dealership(name: name, streetAddress: street, city: city, postalCode: postal);
        await dao.insertDealership(dealership);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.dealershipAdded)),
        );
      } else {
        final updateDealership = Dealership(
          id: widget.dealership!.id,
          name: name,
          streetAddress: street,
          city: city,
          postalCode: postal,
        );
        await dao.updateDealership(updateDealership);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.dealershipUpdated)),
        );
      }
      await prefs.setString('name', name);
      await prefs.setString('streetAddress', street);
      await prefs.setString('city', city);
      await prefs.setString('postalCode', postal);
      widget.onUpdate();
      Navigator.pop(context);
    } catch (e) {
      print('Error saving dealership: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorSaving)),
      );
    }
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text(widget.isAdding
        ? AppLocalizations.of(context)!.addDealership
        : AppLocalizations.of(context)!.updateDealership),
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
              validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.enterName : null,
            ),
            TextFormField(
              controller: streetController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.streetAddress),
              validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.enterStreet : null,
            ),
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.city),
              validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.enterCity : null,
            ),
            TextFormField(
              controller: postalController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.postalCode),
              validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.enterPostal : null,
            ),
            if(widget.isAdding)
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.copyPrevious),
                value: copyFromPrevious,
                onChanged: (value){
                  setState(() {
                    copyFromPrevious = value!;
                    if (copyFromPrevious){
                      _loadPreviousData();
                    }
                  });
                },
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDealership,
              child: Text(widget.isAdding
                  ? AppLocalizations.of(context)!.addDealership
                  : AppLocalizations.of(context)!.updateDealership),
            ),
          ],
        ),
      ),
    ),
  );
}
}
