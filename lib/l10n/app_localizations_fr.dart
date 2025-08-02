// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Application de Concession Automobile';

  @override
  String get dealerships => 'Concessions';

  @override
  String get dealershipDetails => 'Détails de la Concession';

  @override
  String get addDealership => 'Ajouter une Concession';

  @override
  String get updateDealership => 'Mettre à jour la Concession';

  @override
  String get name => 'Nom';

  @override
  String get streetAddress => 'Adresse';

  @override
  String get city => 'Ville';

  @override
  String get postalCode => 'Code Postal';

  @override
  String get instructionsTitle => 'Instructions';

  @override
  String get instructionsContent => 'Sélectionnez une concession pour voir les détails. Utilisez le bouton + pour en ajouter une nouvelle.';

  @override
  String get selectPrompt => 'Sélectionnez une concession pour voir les détails';

  @override
  String get confirmDeletion => 'Confirmer la Suppression';

  @override
  String get areYouSureDelete => 'Êtes-vous sûr de vouloir supprimer cette concession ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get update => 'Mettre à jour';

  @override
  String get delete => 'Supprimer';

  @override
  String get copyPrevious => 'Copier depuis la concession précédente';

  @override
  String get dealershipAdded => 'Concession ajoutée';

  @override
  String get dealershipUpdated => 'Concession mise à jour';

  @override
  String get dealershipDeleted => 'Concession supprimée';

  @override
  String get errorSaving => 'Erreur lors de l\'enregistrement de la concession';

  @override
  String get errorDeleting => 'Erreur lors de la suppression de la concession';

  @override
  String get enterName => 'Veuillez entrer un nom';

  @override
  String get enterStreet => 'Veuillez entrer une adresse';

  @override
  String get enterCity => 'Veuillez entrer une ville';

  @override
  String get enterPostal => 'Veuillez entrer un code postal';
}
