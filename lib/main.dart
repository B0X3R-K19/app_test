import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'lib/pages/page_one.dart';
import 'lib/pages/page_two.dart';
import 'lib/pages/page_three.dart';
import 'lib/pages/page_four.dart';

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

//BMI
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
        height: MediaQuery.of(context).size.height, // Hier die Höhe anpassen
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            height: 500.0, // Hier die Höhe des inneren Containers anpassen
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white, // Hintergrundfarbe hier setzen
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

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;

  StatisticCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      color: Colors.white, // backgroundcolor of the Card
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

//Stat
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
            SizedBox(width: 16.0), // Spacer
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

//Weather
class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late String apiKey;
  final String apiUrl =
      'https://api.weatherapi.com/v1/current.json?q=Munich&key=';

  @override
  void initState() {
    super.initState();
    apiKey = dotenv.env['API_KEY']!;
  }

  Future<Map<String, dynamic>> fetchWeather() async {
    final response = await http.get(Uri.parse('$apiUrl$apiKey'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  String getWeatherIcon(String condition, double temperature,
      double? precipitation, double? windSpeed) {
    if (condition.toLowerCase() == 'clear') {
      return '🌞'; // Sunsymbol
    } else if (condition.toLowerCase() == 'cloudy') {
      return '☁️'; // Clouds
    } else if (condition.toLowerCase() == 'rain') {
      return '🌧️'; // Rain
    } else {
      // Symbol for unknown Weathercondition

      // will decide which weather is today
      if (temperature < 10 &&
          precipitation != null &&
          windSpeed != null &&
          precipitation > 50 &&
          windSpeed > 20) {
        return '🌧️'; // Symbol for bad weather
      } else {
        return '❓'; // Symbol for unknown weathercondition
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final weatherData = snapshot.data;
          final temperature = weatherData?['current']['temp_c'];
          final condition = weatherData?['current']['condition']['text'];
          final precipitation = weatherData?['current']['precip_mm'];
          final humidity = weatherData?['current']['humidity'];
          final windSpeed = weatherData?['current']['wind_kph'];
          final localTime = weatherData?['location']['localtime'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wetter in München:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '$condition',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '$temperature °C',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Niederschlag: ${precipitation ?? "N/A"}%',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Luftfeuchte: ${humidity ?? "N/A"}%',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Wind: ${windSpeed ?? "N/A"} km/h',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Zeitpunkt der Vorhersage: $localTime',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Wetter-Icon: ${getWeatherIcon(condition, temperature, precipitation, windSpeed)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          );
        }
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

class ImpressumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impressum'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Left Box for Text
              Expanded(
                flex: 1,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Impressum \n\nFabian Parzer \nAuszubildender \n\nKontakt: \nTelefon: 01234 56789 \nE-Mail: info@musterunternehmen.de \n\nIS4IT GmbH \nGrünwalder Weg 28B \n82041 Oberhaching \n\nwww.is4it.de \nSitz der Gesellschaft: Oberhaching \nGeschäftsführer: Robert Fröhlich, Stephan Kowalsky \nRegistergericht München HRB 141 845',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      // Add more text widgets or details as needed
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.0), // Add spacing between the boxes
              Expanded(
                flex: 1,
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
                  child: Image.asset(
                    'assets/CompanyLocation.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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