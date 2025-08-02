import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'DAO/CarDAO.dart';
import 'Entity/Car_list.dart';

part 'Database.g.dart';

@Database(version: 1, entities: [CarList])
abstract class AppDatabase extends FloorDatabase {
  CarDAO get carDAO;
}