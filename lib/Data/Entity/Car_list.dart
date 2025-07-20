import 'package:floor/floor.dart';

@entity

class CarList {
  @primaryKey
  int id;
  String brand;
  String model;
  int nuOfPassengers;
  double tankSize;


  CarList(this.id, this.brand, this.model, this.nuOfPassengers, this.tankSize);
}