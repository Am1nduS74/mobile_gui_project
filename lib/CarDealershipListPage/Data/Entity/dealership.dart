import 'package:floor/floor.dart';

// A Car dealership with its details
@entity
class Dealership {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name; /// Name of the dealership
  final String streetAddress;
  final String city;
  final String postalCode;

  Dealership({
    this.id,
    required this.name,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
  });
}