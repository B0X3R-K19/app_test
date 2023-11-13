import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Training',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = TrainingTablePage();
        break;
      case 1:
        page = GeneratorPage();
        break;
      case 2:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.calendar_today),
                      label: Text('Training')),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                    // print('Selected index: $selectedIndex'); // Is needed to see which page is selected
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TrainingTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: [
            Expanded(
              child: TrainingTable(),
            ),
            SizedBox(
              width: 200,
              child: Legend(),
            ),
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        // you could add more trainingmethods here
      ],
    );
  }
}

class TrainingTable extends StatefulWidget {
  @override
  _TrainingTableState createState() => _TrainingTableState();
}

class _TrainingTableState extends State<TrainingTable> {
  List<List<String>> tableData = [
    ['Montag', '01.01.2023', 'Krafttraining'],
  ];

  Set<String> trainingTypes = {
    'Rücken + Bizeps',
    'Brust + Trizeps + Schultern',
    'Beine',
    'Arme'
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: [
            DataColumn(label: Text('Datum')),
            DataColumn(label: Text('Wochentag')),
            DataColumn(label: Text('Trainingsart')),
          ],
          rows: List<DataRow>.generate(tableData.length, (index) {
            return DataRow(
              cells:
                  List<DataCell>.generate(tableData[index].length, (cellIndex) {
                if (cellIndex == 2) {
                  return DataCell(
                    PopupMenuButton<String>(
                      onSelected: (String newValue) {
                        setState(() {
                          tableData[index][cellIndex] = newValue;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return trainingTypes.map((String value) {
                          return PopupMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList();
                      },
                      child: Text(tableData[index][cellIndex]),
                    ),
                  );
                } else {
                  return DataCell(Text(tableData[index][cellIndex]));
                }
              }),
            );
          }),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              final now = DateTime.now();
              final day = DateFormat('EEEE').format(now);
              final date = DateFormat('dd.MM.yyyy').format(now);
              tableData.add([
                day,
                date,
                'Krafttraining'
              ]); // Initialize to the first item in trainingTypes
            });
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
