import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        //border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text('Legende', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Brust + Trizeps + Schultern'),
          Text('Rücken + Bizeps'),
          Text('Beine'),
          Text('Arme'),
          Text('Schultern'),
          Text('Rücken'),
          // you could add more trainingmethods here
        ],
      ),
    );
  }
}
