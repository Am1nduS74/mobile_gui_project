import 'package:floor/floor.dart';
import '../Entity/customer_list.dart';
//ifeanyi nnalue
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


