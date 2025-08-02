import 'package:flutter/material.dart';
import 'dealership.dart';
import 'dealership_details.dart';
import 'dealership_details_content.dart';
import 'dealership_form_page.dart';
import 'app_database.dart';
import 'l10n/app_localizations.dart';

/// Main page for managing car dealerships
class DealershipPage extends StatefulWidget {
  @override
  _DealershipPageState createState() => _DealershipPageState();
}

class _DealershipPageState extends State<DealershipPage> {
  /// List of dealerships loaded from the database
  List<Dealership> dealerships = [];
  /// Database instance
  late AppDatabase database;
  /// Currently selected dealership for device view
  Dealership? selectedDealership;

  @override
  void initState(){
    super.initState();
    _initializeDatabase();
  }

  /// Initializes the database and loads dealerships
  Future<void> _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await _loadDealerships();
  }

  /// Loads all dealerships from the database
  Future<void> _loadDealerships() async {
    final list = await database.dealershipDao.findAllDealerships();
    print('Loaded ${list.length} dealerships'); // Debugging
    setState(() {
      dealerships = list;
    });
  }

  /// Handle deletion of a dealership and updates the UI
  Future<void> _handleDelete(Dealership dealership) async{
    final dao = database.dealershipDao;
    try {
      await dao.deleteDealership(dealership);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.dealershipDeleted)),
      );
      setState(() {
        selectedDealership = null;
      });
      await _loadDealerships();
    } catch (e) {
      print('Error deleting dealership: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorDeleting)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dealerships),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.instructionsTitle),
                  content: Text(AppLocalizations.of(context)!.instructionsContent),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if(constraints.maxWidth > 600) {
            // Tablet or desktop layout
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: dealerships.length,
                    itemBuilder: (context, index) {
                      final dealership = dealerships[index];
                      return ListTile(
                        title: Text(dealership.name),
                        subtitle: Text(dealership.city),
                        onTap: () {
                          setState(() {
                            selectedDealership = dealership;
                          });
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: selectedDealership != null
                    ? DealershipDetailsContent(
                      dealership: selectedDealership!,
                      onUpdate: _loadDealerships,
                      onDelete: () => _handleDelete(selectedDealership!),
                    )
                    : Center(child: Text(AppLocalizations.of(context)!.selectPrompt),),
                ),
              ],
            );
          } else {
            // phone layout
            return ListView.builder(
              itemCount: dealerships.length,
              itemBuilder: (context, index){
                final dealership = dealerships[index];
                return ListTile(
                  title: Text(dealership.name),
                  subtitle: Text(dealership.city),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DealershipDetails(
                          dealership: dealership,
                          onUpdate: _loadDealerships,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DealershipFormPage(
                  isAdding: true,
                  onUpdate: _loadDealerships,
                ),
              ),
            );
          },
        child: Icon(Icons.add),
      ),
    );
  }
}