import 'package:floor/floor.dart';
import 'dealership.dart';
// Data Access object for dealerships
@dao
abstract class DealershipDao {
  /// Retrieves all dealerships from the database
  @Query('SELECT * FROM Dealership')
  Future<List<Dealership>> findAllDealerships();

  /// Inserts a new dealership into the database
  @insert
  Future<void> insertDealership(Dealership dealership);

  /// Update an existing dealership in the database
  @update
  Future<void> updateDealership(Dealership dealership);

  /// Deletes a dealership from the database
  @delete
  Future<void> deleteDealership(Dealership dealership);
}