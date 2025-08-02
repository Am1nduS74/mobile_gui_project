import 'package:floor/floor.dart';
import '../Entity/Car_list.dart';

@dao

abstract class CarDAO {

  @Query('SELECT * FROM CarList')
  Future<List<CarList>> getAllCars();

  @insert
  Future<void> insertCar(CarList car);

  @update
  Future<void> updateCar(CarList car);

  @delete
  Future<void> deleteCar(CarList car);
}