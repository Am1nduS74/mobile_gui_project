import 'package:floor/floor.dart';
//ifeanyi nnalue
@entity
class Customerlist {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String firstName;
  final String lastName;
  final String address;
  final String birthday;

  Customerlist({this.id, required this.firstName, required this.lastName, required this.address, required this.birthday});
}