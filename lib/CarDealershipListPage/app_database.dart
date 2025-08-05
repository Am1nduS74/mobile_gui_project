import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'Data/Entity/dealership.dart';
import 'Data/DAO/dealership_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Dealership])
abstract class AppDatabase extends FloorDatabase {
  DealershipDao get dealershipDao;
}