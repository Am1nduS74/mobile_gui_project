// ignore_for_file: avoid_print
//ifeanyi nnalue
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:intl/intl.dart';

import 'Data/DAO/customer_dao.dart';
import 'app_database.dart';
import 'Data/Entity/customer_list.dart';

/// The main page for listing, adding, updating and deleting customers.
/// Supports encrypted shared preferences, localization, snackbar, alert dialogs, and proper Floor integration.
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late CustomerDao _customerDao;
  List<Customerlist> _customers = [];
  Customerlist? _selectedCustomer;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final EncryptedSharedPreferences _encryptedPrefs = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _customerDao = database.customerDao;
    _loadCustomers();
    _loadLastCustomer();
  }

  Future<void> _loadCustomers() async {
    final list = await _customerDao.getAllCustomers();
    setState(() {
      _customers = list;
    });
  }

  Future<void> _loadLastCustomer() async {
    final firstName = await _encryptedPrefs.getString('firstName');
    final lastName = await _encryptedPrefs.getString('lastName');
    final address = await _encryptedPrefs.getString('address');
    final birthday = await _encryptedPrefs.getString('birthday');

    if (firstName != null) _firstNameController.text = firstName;
    if (lastName != null) _lastNameController.text = lastName;
    if (address != null) _addressController.text = address;
    if (birthday != null) _birthdayController.text = birthday;
  }

  Future<void> _saveLastCustomer() async {
    await _encryptedPrefs.setString('firstName', _firstNameController.text);
    await _encryptedPrefs.setString('lastName', _lastNameController.text);
    await _encryptedPrefs.setString('address', _addressController.text);
    await _encryptedPrefs.setString('birthday', _birthdayController.text);
  }

  void _addCustomer() async {
    if (_formKey.currentState!.validate()) {
      final newCustomer = Customerlist(
        id: null,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _addressController.text,
        birthday: _birthdayController.text,
      );
      await _customerDao.insertCustomer(newCustomer);
      _showSnackbar('Customer added.');
      _saveLastCustomer();
      _clearForm();
      _loadCustomers();
    }
  }

  void _updateCustomer() async {
    if (_formKey.currentState!.validate() && _selectedCustomer != null) {
      final updatedCustomer = Customerlist(
        id: _selectedCustomer!.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _addressController.text,
        birthday: _birthdayController.text,
      );
      await _customerDao.updateCustomer(updatedCustomer);
      _showSnackbar('Customer updated.');
      _clearForm();
      _loadCustomers();
    }
  }

  void _deleteCustomer() async {
    if (_selectedCustomer != null) {
      await _customerDao.deleteCustomer(_selectedCustomer!);
      _showSnackbar('Customer deleted.');
      _clearForm();
      _loadCustomers();
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _addressController.clear();
    _birthdayController.clear();
    setState(() {
      _selectedCustomer = null;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Help'),
        content: const Text('Use the form to add customers. Tap a customer to edit or delete.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  // #ADDED: Build the customer list widget
  Widget _buildCustomerListView() {
    return ListView.builder(
      itemCount: _customers.length,
      itemBuilder: (_, index) {
        final customer = _customers[index];
        return ListTile(

          title: Text('FullName: ${customer.firstName} ${customer.lastName}'),
          subtitle: Text('Address: ${customer.address}, DateOFBirth: ${customer.birthday}'),
          onTap: () {
            setState(() {
              _selectedCustomer = customer;
              _firstNameController.text = customer.firstName;
              _lastNameController.text = customer.lastName;
              _addressController.text = customer.address;
              _birthdayController.text = customer.birthday;
            });
          },
        );
      },
    );
  }

  // #ADDED: Build the form widget
  Widget _buildCustomerForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _birthdayController,
            decoration: const InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _selectedCustomer == null ? _addCustomer : _updateCustomer,
                child: Text(_selectedCustomer == null ? 'Add' : 'Update'),
              ),
              if (_selectedCustomer != null)
                ElevatedButton(
                  onPressed: _deleteCustomer,
                  child: const Text('Delete'),
                ),
              TextButton(
                onPressed: _clearForm,
                child: const Text('Clear'),
              ),
            ],
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          // #ADDED: Responsive layout
          builder: (context, constraints) {
            if (constraints.maxWidth > 720) {
              // Tablet/Desktop: side-by-side layout
              return Row(
                children: [
                  Expanded(child: _buildCustomerListView()),
                  const VerticalDivider(),
                  Expanded(child: SingleChildScrollView(child: _buildCustomerForm())),
                ],
              );
            } else {
              // Phone: vertical layout
              return Column(
                children: [
                  Expanded(child: _buildCustomerListView()),
                  SingleChildScrollView(child: _buildCustomerForm()),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
