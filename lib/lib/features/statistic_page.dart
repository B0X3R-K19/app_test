import 'package:flutter/material.dart';
import 'statistic_card.dart';
import 'weather_widget.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Text(
            'Statistics',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  //border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IS4Fit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Willkommen zu meinem kleinem Flutter Projekt. \nDiese Software entstand aufgrund von privaten Interesse/Bedarf und möglichen Vorteilen für meine Ausbildung. \nFolgende Techniken wurden zum Beispiel implementiert: \n-> Grundstruktur: Tabellenerstellung, einfache Logik Verzweigung, Datenstrukturen(Arrays), URL Einbindungen, Visuelle Anpassungen, etc. \n-> Wetter API Anbindung + Vormerkung für Google Maps API Anbindung',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      WeatherWidget(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0), 
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: StatisticCard(
                          title:
                              'Wie oft warst du diese Woche schon beim Sport:',
                          value: '1.5 M',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: StatisticCard(
                          title: 'Welches ist deine Lieblings Muskelgruppe:',
                          value: 'Test',
                        ),
                      ),
                      StatisticCard(
                        title: 'Das solltest du vielleicht öfters trainieren:',
                        value: '10 K',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
