import 'package:floor/floor.dart';
import 'customer_list.dart';

@dao
abstract class CustomerDao {
  @Query('SELECT * FROM ShoppingItem')
  Future<List<Customerlist>> getAllItems();

  @insert
  Future<void> insertItem(Customerlist custList);

  @update
  Future<void> updateItem(Customerlist custList);

  @delete
  Future<void> deleteItem(Customerlist custlist);
}


