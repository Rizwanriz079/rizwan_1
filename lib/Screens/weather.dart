import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Constants/Constants.dart';

class Weather extends StatefulWidget {

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  TextEditingController _searchController = TextEditingController();
  String _cityName = "";
  String _temperature = "";
  String _weatherCondition = "";
  String _weatherIcon = "";

  void _fetchWeather(String cityName) async {
    APIEndPoints apiEndPoints = APIEndPoints();
    Uri uri = Uri.parse(apiEndPoints.cityUrl + cityName + "&appid=" + apiEndPoints.apiKey + apiEndPoints.unit);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        _cityName = cityName;
        double temperature = jsonData['main']['temp'];
        _temperature = temperature.toStringAsFixed(1) + " °C";
        _weatherCondition = jsonData['weather'][0]['main'];
        _weatherIcon = jsonData['weather'][0]['icon'];
      });
    } else {
      // If the API request fails, show an error message
      setState(() {
        _cityName = "City not found";
        _temperature = "";
        _weatherCondition = "";
        _weatherIcon = "";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey,
      appBar: AppBar(
      title: Text('Weather')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter City Name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _fetchWeather(_searchController.text);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'City: $_cityName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Temperature: $_temperature',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              _weatherIcon.isNotEmpty
                  ? Image.network(
                'http://openweathermap.org/img/wn/$_weatherIcon.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : SizedBox.shrink(),
              SizedBox(height: 10),
              Text(
                'Weather Condition: $_weatherCondition',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
