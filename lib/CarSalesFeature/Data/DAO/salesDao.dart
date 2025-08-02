import 'package:floor/floor.dart';
import 'package:mobile_gui_project/CarSalesFeature/Data/Entity/salesRecord.dart';

@dao
abstract class SalesDao {
  @Query('SELECT * FROM SalesRecord')
  Future<List<SalesRecord>> findAllSalesRecord();

  @delete
  Future<void> deleteSalesRecord(SalesRecord salesRecord);

  @insert
  Future<void> insertSalesRecord(SalesRecord salesRecord);

  @update
  Future<void> updateSalesRecord(SalesRecord salesRecord);
}