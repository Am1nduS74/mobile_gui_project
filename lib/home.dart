import 'CarListAddPage.dart';
import 'CarListPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}
Widget buildImageButton(String imgSource, String label, VoidCallback onTap, String name) {
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.asset(height: double.maxFinite, imgSource,fit: BoxFit.cover, width: double.infinity,),
            ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text('By', style: const TextStyle(fontSize: 20)),
        Text(name, style: const TextStyle(fontSize: 20)),


      ],
    ),
  );

}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main menu'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
                childAspectRatio: 0.7,
                physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
              buildImageButton(
              'assets/car.png',
              'CARS',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ),
                );
              },
                'Amindu Udawatta'
            ),
              buildImageButton(
                'assets/customer.png',
                'CUSTOMERS',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
                  'Ifeanyi Nnalue'
              ),
              buildImageButton(
                'assets/dealership.png',
                'DEALERSHIP',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
                  'Thierno Balde'
              ),
              buildImageButton(
                'assets/sales.jpg',
                'SALES',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
                  'John Chamoun'
              ),
          ],
        )
            )],
        ),

      ),
    );
  }
}
