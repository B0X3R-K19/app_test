import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

///
///
///
/// If you read this... might think about adding a BMI calculator
/// And why not think about adding the older F1 calculator software you made in a seperate site
///
///
///
///

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

  // BMI-related variables
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  double bmiResult = 0.0;

  void calculateBMI() {
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);

    // BMI-Formel: Gewicht (kg) / (Größe (m))^2
    double bmi = weight / ((height / 100) * (height / 100));

    bmiResult = bmi;
    notifyListeners();

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
        page = StatisticsPage();
        //page = FavoritesPage();
        break;
      /*
      case 1:
        page = GeneratorPage();
        break;
        */
      case 1:
        page = TrainingTablePage();
        break;
      case 2:
        page = ExcerciseSamplePage();
        break;
      case 3:
        page = BMICalculatorPage();
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
                    icon: Icon(Icons.calendar_today),
                    label: Text('Training'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Excercise Sample')),
                  NavigationRailDestination(
                    icon: Icon(Icons.table_view),
                    label: Text('BMI'),
                  ),
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

class BMICalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
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
                TextField(
                  controller: appState.heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: appState.weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;

  StatisticCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      color: Colors.white, // Hintergrundfarbe der Card
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white, // Hintergrundfarbe der Box
          ),
          child: Text(
            'Statistics',
            style: TextStyle(color: Colors.black), // Schriftfarbe der Box
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: ListView(
          children: <Widget>[
            StatisticCard(
              title: 'Wie oft warst du diese Woche schon beim Sport:',
              value: '1.5 M',
            ),
            StatisticCard(
              title: 'Welches ist deine Lieblings Muskelgruppe:',
              value: 'Test',
            ),
            StatisticCard(
              title: 'Das solltest du vielleicht öfters trainieren:',
              value: '10 K',
            ),
          ],
        ),
      ),
    );
  }
}

class ExcerciseSamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Samples'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Anzahl der Spalten
        crossAxisSpacing: 16.0, // horizontaler Abstand zwischen den Elementen
        mainAxisSpacing: 16.0, // vertikaler Abstand zwischen den Elementen
        children: [
          ImageCard(
            imageUrl:
                'https://modusx.de/wp-content/uploads/brustpresse-parallelgriff.gif',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageOne()),
              );
            },
          ),
          ImageCard(
            imageUrl:
                'https://www.fitundattraktiv.de/wp-content/uploads/2018/11/uebungen_latissimus-einarmiges_kurzhantelrudern.gif',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageTwo()),
              );
            },
          ),
          ImageCard(
            imageUrl:
                'https://www.fitundattraktiv.de/wp-content/uploads/2018/02/45_grad_beinpresse.gif',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageThree()),
              );
            },
          ),
          ImageCard(
            imageUrl:
                'https://www.fitundattraktiv.de/wp-content/uploads/2018/10/bizeps_uebungen_ohne_hilfsmittel-bizepscurls_einarmig.gif',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageFour()),
              );
            },
          ),
          ImageCard(
            imageUrl:
                'https://www.fitundattraktiv.de/wp-content/uploads/2021/03/plank_uebung-mit_gewicht.gif',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageFive()),
              );
            },
          ),
          ImageCard(
            imageUrl:
                'https://www.fitundattraktiv.de/wp-content/uploads/2021/03/seitheben_kurzhantel-stehend.gif',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageSix()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    required this.imageUrl,
    required this.onTap,
  });

  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page One'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Übungstyp'),
              ),
              DataColumn(
                label: Text('Sätze'),
              ),
              DataColumn(
                label: Text('Wiederholungen'),
              ),
            ],
            rows: const <DataRow>[
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
                  DataCell(Text('incline bench press')),
                  DataCell(Text('4')),
                  DataCell(Text('8-12')),
                ],
              ),
              // ... (add more DataRow widgets as needed)
            ],
          ),
        ),
      ),
    );
  }
}

/*
class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page One'),
      ),
      body: Center(
        child: Text('Content of Page One'),
      ),
    );
  }
}
*/
class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Two'),
      ),
      body: Center(
        child: Text('Content of Page Two'),
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Three'),
      ),
      body: Center(
        child: Text('Content of Page Three'),
      ),
    );
  }
}

class PageFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Four'),
      ),
      body: Center(
        child: Text('Content of Page Four'),
      ),
    );
  }
}

class PageFive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Five'),
      ),
      body: Center(
        child: Text('Content of Page Five'),
      ),
    );
  }
}

class PageSix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Six'),
      ),
      body: Center(
        child: Text('Content of Page Six'),
      ),
    );
  }
}

class TrainingTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white),
            color: Colors.white,
          ),
          child: Text(
            'Training',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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

  List<DataRow> generateDataRows() {
    return List<DataRow>.generate(tableData.length, (index) {
      return DataRow(
        cells: List<DataCell>.generate(tableData[index].length, (cellIndex) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(16.0),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Datum')),
                DataColumn(label: Text('Wochentag')),
                DataColumn(label: Text('Trainingsart')),
              ],
              rows: generateDataRows(),
            ),
          ),
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
                'Krafttraining',
              ]); // Initialize to the first item in trainingTypes
            });
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}


/*
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
*/
