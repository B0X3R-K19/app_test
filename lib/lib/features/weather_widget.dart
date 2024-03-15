import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      return '🌞'; 
    } else if (condition.toLowerCase() == 'cloudy') {
      return '☁️'; 
    } else if (condition.toLowerCase() == 'rain') {
      return '🌧️'; 
    } else {
      if (temperature < 10 &&
          precipitation != null &&
          windSpeed != null &&
          precipitation > 50 &&
          windSpeed > 20) {
        return '🌧️'; 
      } else {
        return '❓'; 
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
