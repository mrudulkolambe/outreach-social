import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String content;

  CustomBottomSheet({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5))
    ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.0),
          Text(content, style: TextStyle(fontSize: 16.0)),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          )
        ],
      ),
    );
  }
}
