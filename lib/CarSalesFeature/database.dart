import 'dart:async';
import 'package:floor/floor.dart';
import 'package:mobile_gui_project/CarSalesFeature/Data/DAO/salesDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:mobile_gui_project/CarSalesFeature/Data/Entity/salesRecord.dart';

part 'database.g.dart';

@Database(version: 1, entities: [SalesRecord])
abstract class AppDatabase extends FloorDatabase {
  SalesDao get salesDao;
}