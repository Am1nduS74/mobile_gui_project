// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

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

  SalesDao? _salesDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `SalesRecord` (`id` INTEGER NOT NULL, `customerID` TEXT NOT NULL, `carID` TEXT NOT NULL, `dealershipID` TEXT NOT NULL, `date` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SalesDao get salesDao {
    return _salesDaoInstance ??= _$SalesDao(database, changeListener);
  }
}

class _$SalesDao extends SalesDao {
  _$SalesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _salesRecordInsertionAdapter = InsertionAdapter(
            database,
            'SalesRecord',
            (SalesRecord item) => <String, Object?>{
                  'id': item.id,
                  'customerID': item.customerID,
                  'carID': item.carID,
                  'dealershipID': item.dealershipID,
                  'date': item.date
                }),
        _salesRecordUpdateAdapter = UpdateAdapter(
            database,
            'SalesRecord',
            ['id'],
            (SalesRecord item) => <String, Object?>{
                  'id': item.id,
                  'customerID': item.customerID,
                  'carID': item.carID,
                  'dealershipID': item.dealershipID,
                  'date': item.date
                }),
        _salesRecordDeletionAdapter = DeletionAdapter(
            database,
            'SalesRecord',
            ['id'],
            (SalesRecord item) => <String, Object?>{
                  'id': item.id,
                  'customerID': item.customerID,
                  'carID': item.carID,
                  'dealershipID': item.dealershipID,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SalesRecord> _salesRecordInsertionAdapter;

  final UpdateAdapter<SalesRecord> _salesRecordUpdateAdapter;

  final DeletionAdapter<SalesRecord> _salesRecordDeletionAdapter;

  @override
  Future<List<SalesRecord>> findAllSalesRecord() async {
    return _queryAdapter.queryList('SELECT * FROM SalesRecord',
        mapper: (Map<String, Object?> row) => SalesRecord(
            row['id'] as int,
            row['customerID'] as String,
            row['carID'] as String,
            row['dealershipID'] as String,
            row['date'] as String));
  }

  @override
  Future<void> insertSalesRecord(SalesRecord salesRecord) async {
    await _salesRecordInsertionAdapter.insert(
        salesRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSalesRecord(SalesRecord salesRecord) async {
    await _salesRecordUpdateAdapter.update(
        salesRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSalesRecord(SalesRecord salesRecord) async {
    await _salesRecordDeletionAdapter.delete(salesRecord);
  }
}
