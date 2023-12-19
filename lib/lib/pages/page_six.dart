import 'package:flutter/material.dart';

class PageSix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
      ),
      backgroundColor: Theme.of(context)
          .colorScheme
          .primaryContainer, // Hintergrundfarbe des gesamten Bildschirms
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors
                      .white, // Hintergrundfarbe der Tabelle und des Texts
                  //border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Übungstyp',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Sätze',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Wiederholungen',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Liegestütze')),
                        DataCell(Text('3')),
                        DataCell(Text('8-15')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Bankdrücken')),
                        DataCell(Text('4')),
                        DataCell(Text('8-12')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Butterfly')),
                        DataCell(Text('4')),
                        DataCell(Text('8-15')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Incline Bench Press')),
                        DataCell(Text('4')),
                        DataCell(Text('8-12')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Cable Fly klassisch')),
                        DataCell(Text('4')),
                        DataCell(Text('10-15')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Fliegende mit Kurzhanteln')),
                        DataCell(Text('4')),
                        DataCell(Text('8-12')),
                      ],
                    ),
                    // ... (add more DataRow widgets as needed)
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.0), // Spacer
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Hintergrundfarbe des Texts
                //border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Übungen für den Brustmuskel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'In dieser umfangreichen Übersicht findest du eine Vielzahl \nvon effektiven Übungen, um deine Brustmuskeln zu stärken und zu formen. \nEgal ob Bankdrücken, Liegestütze oder Fliegende \n– hier sind Übungen für jeden dabei. \nLos geht’s zum Training!',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
