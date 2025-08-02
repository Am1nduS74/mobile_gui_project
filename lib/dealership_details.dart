import 'package:flutter/material.dart';
import 'dealership.dart';
import 'dealership_details_content.dart';
import 'app_database.dart';
import 'l10n/app_localizations.dart';

/// Display details of a dealership
class DealershipDetails extends StatelessWidget {
  /// The dealership to display
  final Dealership dealership;
  /// Callback to refresh the dealership list after an update
  final VoidCallback onUpdate;

  DealershipDetails({required this.dealership, required this.onUpdate});

  /// Delete dealership from the database
  Future<void> _deleteDealership(BuildContext context) async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final dao = database.dealershipDao;
    try {
      await dao.deleteDealership(dealership);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.dealershipDeleted)),
      );
      onUpdate();
      Navigator.pop(context);
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
        title: Text(AppLocalizations.of(context)!.dealershipDetails),
      ),
      body: DealershipDetailsContent(
        dealership: dealership,
        onUpdate: onUpdate,
          onDelete: () => _deleteDealership(context),
      ),

    );
  }
}