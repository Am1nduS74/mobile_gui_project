// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Car Dealership App';

  @override
  String get dealerships => 'Dealerships';

  @override
  String get dealershipDetails => 'Dealership Details';

  @override
  String get addDealership => 'Add Dealership';

  @override
  String get updateDealership => 'Update Dealership';

  @override
  String get name => 'Name';

  @override
  String get streetAddress => 'Street Address';

  @override
  String get city => 'City';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get instructionsTitle => 'Instructions';

  @override
  String get instructionsContent => 'Select a dealership to view details. Use the + button to add a new one.';

  @override
  String get selectPrompt => 'Select a dealership to view details';

  @override
  String get confirmDeletion => 'Confirm Deletion';

  @override
  String get areYouSureDelete => 'Are you sure you want to delete this dealership?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get copyPrevious => 'Copy from previous dealership';

  @override
  String get dealershipAdded => 'Dealership added';

  @override
  String get dealershipUpdated => 'Dealership updated';

  @override
  String get dealershipDeleted => 'Dealership deleted';

  @override
  String get errorSaving => 'Error saving dealership';

  @override
  String get errorDeleting => 'Error deleting dealership';

  @override
  String get enterName => 'Please enter a name';

  @override
  String get enterStreet => 'Please enter a street address';

  @override
  String get enterCity => 'Please enter a city';

  @override
  String get enterPostal => 'Please enter a postal code';

  @override
  String get close => 'Close';

  @override
  String get language => 'Switch Languae';
}
