import 'package:floor/floor.dart';
import 'customer_list.dart';

@dao
abstract class CustomerDao {
  @Query('SELECT * FROM CustomerList')
  Future<List<Customerlist>> getAllCustomers();

  @insert
  Future<void> insertCustomer(Customerlist custList);

  @update
  Future<void> updateCustomer(Customerlist custList);

  @delete
  Future<void> deleteCustomer(Customerlist custlist);
}


