import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomCakeScreen extends StatelessWidget {
  const CustomCakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Custom Cake',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.peach,
              ),
            ),
            child: const Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 55,
                  color: AppColors.brown,
                ),
                SizedBox(height: 12),
                Text(
                  'Upload Cake Reference',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.brown,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Tap to upload',
                  style: TextStyle(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Cake Flavor',
              suffixIcon:
                  Icon(Icons.keyboard_arrow_down),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Cake Size',
              suffixIcon:
                  Icon(Icons.keyboard_arrow_down),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Theme / Occasion',
              hintText:
                  'Birthday, Wedding...',
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Special Instructions',
              hintText:
                  'Write something...',
            ),
          ),

          const SizedBox(height: 25),

          FilledButton(
            onPressed: () {},
            child: const Text(
              'Send Custom Request',
            ),
          ),
        ],
      ),
    );
  }
}