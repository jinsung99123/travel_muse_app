import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({required this.title, required this.description, super.key});
  
  final String title;
  final String description;


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(description, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
