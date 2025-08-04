// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

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

  DealershipDao? _dealershipDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Dealership` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `streetAddress` TEXT NOT NULL, `city` TEXT NOT NULL, `postalCode` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DealershipDao get dealershipDao {
    return _dealershipDaoInstance ??= _$DealershipDao(database, changeListener);
  }
}

class _$DealershipDao extends DealershipDao {
  _$DealershipDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dealershipInsertionAdapter = InsertionAdapter(
            database,
            'Dealership',
            (Dealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'streetAddress': item.streetAddress,
                  'city': item.city,
                  'postalCode': item.postalCode
                }),
        _dealershipUpdateAdapter = UpdateAdapter(
            database,
            'Dealership',
            ['id'],
            (Dealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'streetAddress': item.streetAddress,
                  'city': item.city,
                  'postalCode': item.postalCode
                }),
        _dealershipDeletionAdapter = DeletionAdapter(
            database,
            'Dealership',
            ['id'],
            (Dealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'streetAddress': item.streetAddress,
                  'city': item.city,
                  'postalCode': item.postalCode
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Dealership> _dealershipInsertionAdapter;

  final UpdateAdapter<Dealership> _dealershipUpdateAdapter;

  final DeletionAdapter<Dealership> _dealershipDeletionAdapter;

  @override
  Future<List<Dealership>> findAllDealerships() async {
    return _queryAdapter.queryList('SELECT * FROM Dealership',
        mapper: (Map<String, Object?> row) => Dealership(
            id: row['id'] as int?,
            name: row['name'] as String,
            streetAddress: row['streetAddress'] as String,
            city: row['city'] as String,
            postalCode: row['postalCode'] as String));
  }

  @override
  Future<void> insertDealership(Dealership dealership) async {
    await _dealershipInsertionAdapter.insert(
        dealership, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDealership(Dealership dealership) async {
    await _dealershipUpdateAdapter.update(dealership, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDealership(Dealership dealership) async {
    await _dealershipDeletionAdapter.delete(dealership);
  }
}
