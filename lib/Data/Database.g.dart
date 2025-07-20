// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CarDAO? _carDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CarList` (`id` INTEGER NOT NULL, `brand` TEXT NOT NULL, `model` TEXT NOT NULL, `nuOfPassengers` INTEGER NOT NULL, `tankSize` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CarDAO get carDAO {
    return _carDAOInstance ??= _$CarDAO(database, changeListener);
  }
}

class _$CarDAO extends CarDAO {
  _$CarDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _carListInsertionAdapter = InsertionAdapter(
            database,
            'CarList',
            (CarList item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'nuOfPassengers': item.nuOfPassengers,
                  'tankSize': item.tankSize
                }),
        _carListUpdateAdapter = UpdateAdapter(
            database,
            'CarList',
            ['id'],
            (CarList item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'nuOfPassengers': item.nuOfPassengers,
                  'tankSize': item.tankSize
                }),
        _carListDeletionAdapter = DeletionAdapter(
            database,
            'CarList',
            ['id'],
            (CarList item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'nuOfPassengers': item.nuOfPassengers,
                  'tankSize': item.tankSize
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CarList> _carListInsertionAdapter;

  final UpdateAdapter<CarList> _carListUpdateAdapter;

  final DeletionAdapter<CarList> _carListDeletionAdapter;

  @override
  Future<List<CarList>> getAllCars() async {
    return _queryAdapter.queryList('SELECT * FROM CarList',
        mapper: (Map<String, Object?> row) => CarList(
            row['id'] as int,
            row['brand'] as String,
            row['model'] as String,
            row['nuOfPassengers'] as int,
            row['tankSize'] as double));
  }

  @override
  Future<void> insertCar(CarList car) async {
    await _carListInsertionAdapter.insert(car, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCar(CarList car) async {
    await _carListUpdateAdapter.update(car, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCar(CarList car) async {
    await _carListDeletionAdapter.delete(car);
  }
}
