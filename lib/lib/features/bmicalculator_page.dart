import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class BMICalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          title: Text(
            'BMI Calculator',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, 
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            height: 500.0, 
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white, 
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16.0),
                SliderInput(
                  label: 'Height (cm)',
                  value: appState.height,
                  onChanged: (value) {
                    appState.setHeight(value);
                  },
                ),
                SizedBox(height: 8.0),
                SliderInput(
                  label: 'Weight (kg)',
                  value: appState.weight,
                  onChanged: (value) {
                    appState.setWeight(value);
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    appState.calculateBMI();
                  },
                  child: Text('Calculate BMI'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'BMI Result: ${appState.bmiResult.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 16.0),
                BMIResultCategory(bmi: appState.bmiResult),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SliderInput extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  SliderInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18.0),
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 0.0,
          max: 200.0,
          divisions: 100,
          label: value.toString(),
        ),
      ],
    );
  }
}

class BMIResultCategory extends StatelessWidget {
  final double bmi;

  BMIResultCategory({required this.bmi});

  String getBMICategory() {
    if (bmi < 16) {
      return 'Kritisches Untergewicht';
    } else if (bmi >= 16 && bmi < 18.5) {
      return 'Untergewicht';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normalgewicht';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Leichtes Übergewicht';
    } else {
      return 'Übergewicht';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'BMI Category: ${getBMICategory()}',
      style: TextStyle(fontSize: 20.0),
    );
  }
}
