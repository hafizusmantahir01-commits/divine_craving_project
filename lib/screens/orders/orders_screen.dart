import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/cake_data.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          OrderCard(
            cake: CakeData.cakes[0],
            status: 'Preparing',
          ),
          OrderCard(
            cake: CakeData.cakes[1],
            status: 'Delivered',
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final dynamic cake;
  final String status;

  const OrderCard({
    super.key,
    required this.cake,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(14),
              child: Image.network(
                cake.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    cake.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rs ${cake.price.toInt()}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status,
                    style: TextStyle(
                      color: status ==
                              'Delivered'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: AppColors.brown,
            ),
          ],
        ),
      ),
    );
  }
}