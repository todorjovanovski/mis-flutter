import 'package:flutter/material.dart';
import 'package:lab1/product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> clothingItems = [
    {
      'name': 'T-Shirt',
      'image': 'assets/images/tshirt.png',
      'description': 'A comfortable cotton T-Shirt.',
      'price': '\$20',
    },
    {
      'name': 'Jeans',
      'image': 'assets/images/jeans.png',
      'description': 'Classic blue denim jeans.',
      'price': '\$40',
    },
    {
      'name': 'Jacket',
      'image': 'assets/images/jacket.png',
      'description': 'A warm winter jacket.',
      'price': '\$60',
    },
    {
      'name': 'Sneakers',
      'image': 'assets/images/shoes.png',
      'description': 'Stylish and durable sneakers.',
      'price': '\$50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('213133'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.55
          ),
          itemCount: clothingItems.length,
          itemBuilder: (context, index) {
            final item = clothingItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(item: item),
                  ),
                );
              },
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        item['image']
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['name'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}