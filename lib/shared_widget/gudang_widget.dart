// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class GudangWidget extends StatelessWidget {
  String subtitile;
  
  String title;

   GudangWidget({
    super.key,
    required this.title,
    required this.subtitile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8), // Add border
      ),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.label,
                color: Colors.purple,
              )),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
