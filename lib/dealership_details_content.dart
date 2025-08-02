import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dealership.dart';
import 'dealership_form_page.dart';
import 'l10n/app_localizations.dart';

/// Widget to display dealership details content
class DealershipDetailsContent extends StatelessWidget {
  /// The dealership to display
  final Dealership dealership;
  /// Callback to refresh the dealership list after an update
  final VoidCallback onUpdate;
  /// Callback to handle dealership deletion
  final VoidCallback onDelete;

  DealershipDetailsContent({
    required this.dealership,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppLocalizations.of(context)!.name}: ${dealership.name}', style: TextStyle(fontSize: 18),),
              SizedBox(height: 8),
              Text('${AppLocalizations.of(context)!.streetAddress}: ${dealership.streetAddress}'),
              SizedBox(height: 8),
              Text('${AppLocalizations.of(context)!.city}: ${dealership.city}'),
              SizedBox(height: 8),
              Text('${AppLocalizations.of(context)!.postalCode}: ${dealership.postalCode}'),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealershipFormPage(
                              isAdding: false,
                              dealership: dealership,
                              onUpdate: onUpdate,
                            ),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.update),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.confirmDeletion),
                            content: Text(AppLocalizations.of(context)!.areYouSureDelete),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(AppLocalizations.of(context)!.no),
                              ),
                              TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  onDelete();
                                },
                                child: Text(AppLocalizations.of(context)!.yes),
                              ),
                            ],
                          ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.delete),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}