import 'package:flutter/material.dart';
import 'app_database.dart';
import 'customer_list.dart';
import 'customer_dao.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: CustomerListPage(),
    );
  }
}

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late AppDatabase database;
  List<Customerlist> _customers = [];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _setupDatabase();
  }

  Future<void> _setupDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('customer_list.db').build();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await database.customerDao.getAllCustomers();
    setState(() {
      _customers = items;
    });
  }

  Future<void> _addItem() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String quantityText = lastNameController.text.trim();
    final String address = addressController.text.trim();
    final String birthday = birthdayController.text.trim();


    if(firstName.isNotEmpty && lastName.isNotEmpty && address.isNotEmpty && birthday.isNotEmpty != null) {

      final newItem = Customerlist(id: null, firstName: firstName, lastName: lastName, address: address, birthday: birthday);
      await database.customerDao.insertCustomer(newItem);

      firstNameController.clear();
      lastNameController.clear();
      addressController.clear();
      birthdayController.clear();

      _loadItems();
    }
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Do you want to delete this item ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                final item = _customers[index];
                if (item.id != null) {
                  await database.customerDao.deleteCustomer(item);
                  _loadItems();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: Colors.purple[100],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      hintText: 'Type the item here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      hintText: 'Type the quantity here',
                      border: OutlineInputBorder(),
                    ),

                  ),
                ),

                Expanded (/***/
                  child: ElevatedButton(
                    onPressed: _addItem,
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _customers.isEmpty
                ? const Center(child: Text('There are no items in the list'))
                : Center(
                child: ListView.builder(
                  itemCount: _customers.length,
                  itemBuilder: (context, index){
                    final item = _customers[index];
                    return ListTile(
                      title: Text(
                        '${index + 1}: ${item.firstName}  quantity: ${item.lastName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      onLongPress: () => _showDeleteDialog(index),
                    );
                  },
                )
            ),
          ),
        ],
      ),
    );
  }
}