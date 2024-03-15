// packages which are used in the main (includes Hive DB, dotenv and other features)
import 'package:app_test/person.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// imports of the used pages in which the musclegroups are stated
import 'lib/pages/page_one.dart';
import 'lib/pages/page_two.dart';
import 'lib/pages/page_three.dart';
import 'lib/pages/page_four.dart';
import 'lib/pages/page_five.dart';
import 'lib/pages/page_six.dart';

// imports of the used features of the program 
import 'lib/features/impressum_page.dart';
import 'lib/features/legend.dart';
import 'lib/features/statistic_page.dart';
import 'lib/features/bmicalculator_page.dart';

// imports which are so far not necessary but used by other features which got outsourced of the main. These imports will stay here for documentation
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'lib/features/weather_widget.dart';
// import 'lib/features/statistic_card.dart';
// new impoirt option for every feature: import 'lib/features/'

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

/// https://modusx.de/fitness-uebungen/muskelgruppe/brust/
/// If you read this... might think about adding the older F1 calculator software you made in a seperate site
/// https://www.weatherapi.com/
/// https://fonts.foogle.com/icons

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: Builder(
        builder: (context) {
          var myAppState = Provider.of<MyAppState>(context);
          return MaterialApp(
            title: 'Training',
            theme: ThemeData.light().copyWith(
              colorScheme: myAppState.isDarkMode
                  ? ColorScheme.light()
                  : ColorScheme.light(
                      // Hier kannst du deine bevorzugten Farben für den Light-Mode festlegen
                      // IS4IT: primary: Color.fromARGB(255, 211, 50, 36),
                      primary: Color.fromARGB(255, 184, 210, 255),
                      // blue: primary: Color.fromARGB(255, 166, 199, 255),
                      secondary: Color.fromARGB(255, 184, 210, 255),
                      //secondaryVariant: Colors.greenAccent,
                    ),
            ),
            darkTheme: ThemeData.dark(), // Dark mode theme
            themeMode: myAppState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // BMI-related variables
  double height = 170.0; // Default value, change if needed
  double weight = 70.0; // Default value, change if needed
  double bmiResult = 0.0;

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    print('Dark mode toggled: $_isDarkMode');
    notifyListeners();
  }

  void setHeight(double newHeight) {
    height = newHeight;
    notifyListeners();
  }

  void setWeight(double newWeight) {
    weight = newWeight;
    notifyListeners();
  }

  void calculateBMI() {
    // BMI-Calculator
    double bmi = weight / ((height / 100) * (height / 100));
    bmiResult = bmi;
    notifyListeners();
  }

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
    final myAppState = Provider.of<MyAppState>(context);

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = StatisticsPage();
        break;
      case 1:
        page = TrainingTablePage();
        break;
      case 2:
        page = ExcerciseSamplePage();
        break;
      case 3:
        page = BMICalculatorPage();
        break;
      case 4:
        page = ImpressumPage();
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
                      label: Text('Exercise Sample')),
                  NavigationRailDestination(
                    icon: Icon(Icons.table_view),
                    label: Text('BMI'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.info),
                    label: Text('Impressum'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: myAppState.isDarkMode
                    ? Colors.black
                    : Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class DarkModeToggle extends StatelessWidget {
  final MyAppState myAppState;

  DarkModeToggle({required this.myAppState});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(myAppState.isDarkMode ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        myAppState.toggleDarkMode();
      },
    );
  }
}

//Excercise
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
                'https://modusx.de/wp-content/uploads/fliegende-kurzhanteln-flachbank.gif',
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

class TrainingTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            //border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Text(
            'Training',
            style: TextStyle(color: Colors.black),
          ),
        ),
        //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
            //border: Border.all(color: Colors.black),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
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

                /* the following Feature needs to be postponed to the future due to Google difficulties
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.7749, -122.4194), // Replace with your desired initial position
                    zoom: 14.0,
                  ),
                  markers: Set<Marker>.of([
                    Marker(
                      markerId: MarkerId('YourMarkerId'),
                      position: LatLng(37.7749, -122.4194), // Replace with your marker position
                      infoWindow: InfoWindow(
                        title: 'Your Marker Title',
                        snippet: 'Your Marker Snippet',
                      ),
                    ),
                  ]),
                ),*/