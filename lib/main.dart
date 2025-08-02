// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_gui_project/database.dart';
import 'package:mobile_gui_project/salesDao.dart';
import 'package:mobile_gui_project/salesRecord.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales List Page',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Sales List Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _storage = const FlutterSecureStorage();
  late TextEditingController customerID_Field;
  late TextEditingController carID_Field;
  late TextEditingController dealershipID_Field;
  late TextEditingController date_Field;
  late AppDatabase database;
  late SalesDao DAO;
  List<SalesRecord> records = [];
  SalesRecord? selectedSalesRecord;

  @override
  void initState() {
    super.initState();
    customerID_Field = TextEditingController();
    carID_Field = TextEditingController();
    dealershipID_Field = TextEditingController();
    date_Field = TextEditingController();
    initialize();
  }

  Future<void> initialize() async {
    database = await $FloorAppDatabase.databaseBuilder('salesRecord_database.db').build();
    DAO = database.salesDao;
    final test = await DAO.findAllSalesRecord();

    setState(() {
      records = test;
      if (test.isNotEmpty) {
        SalesRecord.ID = test.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
      }
    });

    final savedData = await _storage.read(key: 'last_record');
    if (savedData != null) {
      final Map<String, dynamic> data = json.decode(savedData);
      customerID_Field.text = data['customerID'];
      carID_Field.text = data['carID'];
      dealershipID_Field.text = data['dealershipID'];
      date_Field.text = data['date'];
    }
  }

  void insert() async {
    String customerId = customerID_Field.text.trim();
    String carId = carID_Field.text.trim();
    String dealershipId = dealershipID_Field.text.trim();
    String date = date_Field.text.trim();

    if ([customerId, carId, dealershipId, date].every((e) => e.isNotEmpty)) {
      final record = SalesRecord(SalesRecord.ID++, customerId, carId, dealershipId, date);
      await DAO.insertSalesRecord(record);
      await _storage.write(
        key: 'last_record',
        value: json.encode({
          'customerID': customerId,
          'carID': carId,
          'dealershipID': dealershipId,
          'date': date
        }),
      );
      setState(() {
        records.add(record);
        customerID_Field.clear();
        carID_Field.clear();
        dealershipID_Field.clear();
        date_Field.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sales record saved')),
      );
    }
  }

  void updateRecord() async {
    if (selectedSalesRecord == null) return;

    final updated = SalesRecord(
      selectedSalesRecord!.id,
      customerID_Field.text,
      carID_Field.text,
      dealershipID_Field.text,
      date_Field.text,
    );

    await DAO.updateSalesRecord(updated);

    setState(() {
      final index = records.indexWhere((r) => r.id == updated.id);
      if (index != -1) {
        records[index] = updated;
      }
      selectedSalesRecord = null;
      customerID_Field.clear();
      carID_Field.clear();
      dealershipID_Field.clear();
      date_Field.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sales record updated')),
    );
  }

  void showInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Instructions'),
        content: const Text(
            'To add a Sales record, fill out all fields and tap Save. Tap on a Sale to see or update details.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void deleteRecord(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content: const Text("Do you want to delete the sale history?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              final item = records[index];
              await DAO.deleteSalesRecord(item);
              setState(() {
                records.removeAt(index);
                selectedSalesRecord = null;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sales record deleted')),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: customerID_Field,
                decoration: const InputDecoration(labelText: "Customer ID"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: carID_Field,
                decoration: const InputDecoration(labelText: "Car ID"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dealershipID_Field,
                decoration: const InputDecoration(labelText: "Dealership ID"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: date_Field,
                decoration: const InputDecoration(labelText: "Date"),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: insert,
                    child: const Text("Save"),
                  ),
                  const SizedBox(width: 8),
                  if (selectedSalesRecord != null)
                    ElevatedButton(
                      onPressed: updateRecord,
                      child: const Text("Update"),
                    ),
                  const SizedBox(width: 8),
                  if (selectedSalesRecord != null)
                    ElevatedButton(
                      onPressed: () => setState(() => selectedSalesRecord = null),
                      child: const Text("Cancel"),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    if (records.isEmpty) {
      return const Center(
        child: Text("No sales records yet. Add one using the form above."),
      );
    }
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final r = records[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text("Customer ID: ${r.customerID}"),
            subtitle: Text("Car: ${r.carID} | Dealer: ${r.dealershipID} | Date: ${r.date}"),
            onTap: () {
              setState(() {
                selectedSalesRecord = r;
                customerID_Field.text = r.customerID;
                carID_Field.text = r.carID;
                dealershipID_Field.text = r.dealershipID;
                date_Field.text = r.date;
              });
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => deleteRecord(index),
            ),
          ),
        );
      },
    );
  }

  Widget buildDetailView() {
    if (selectedSalesRecord == null) {
      return const Center(child: Text("Select a record to see details."));
    }
    final r = selectedSalesRecord!;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${r.id}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Customer ID: ${r.customerID}"),
            Text("Car ID: ${r.carID}"),
            Text("Dealership ID: ${r.dealershipID}"),
            Text("Date: ${r.date}"),
          ],
        ),
      ),
    );
  }

  Widget reactiveLayout() {
    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                buildForm(),
                Expanded(child: buildList()),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: buildDetailView(),
          )
        ],
      );
    } else {
      return Column(
        children: [
          buildForm(),
          Expanded(child: selectedSalesRecord == null ? buildList() : buildDetailView()),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: showInstructions,
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fedor.jpg', // Adjust path as needed
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerRight,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.05), // Optional white overlay for clarity
          ),
          reactiveLayout(),
        ],
      ),
    );
  }
}
