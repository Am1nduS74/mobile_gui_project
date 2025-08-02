import 'package:floor/floor.dart';

@entity
class SalesRecord {

  static int ID = 1;

  @primaryKey
  final int id;

  final String customerID;

  final String carID;

  final String dealershipID;

  final String date;

  SalesRecord(this.id ,this.customerID, this.carID, this.dealershipID, this.date){
    if (id >= ID) {
      ID = id +1;
    }
  }
}