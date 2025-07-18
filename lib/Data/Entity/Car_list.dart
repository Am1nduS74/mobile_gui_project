import 'package:floor/floor.dart';

@entity

class CarList {
  @primaryKey
  int id;
  String brand;
  String model;
  String nuOfPassengers;
  String tankSize;


  CarList(this.id, this.brand, this.model, this.nuOfPassengers, this.tankSize);
}