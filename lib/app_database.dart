import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dealership.dart';
import 'dealership_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Dealership])
abstract class AppDatabase extends FloorDatabase {
  DealershipDao get dealershipDao;
}