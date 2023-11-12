import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final apiKey = '6b27e1846136009822d1ee1076156a5f';
  final city = 'Kathmandu';
  List<String> cities = ['New York', 'London', 'Dallas', 'Sydney'];
  String cityName = '';
  int temperature = 0;
  String condition = '';
  int index = 0;
  TextEditingController locationController = TextEditingController();

  Future checkWeather(String location) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&APPID=$apiKey'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        cityName = data['name'];
        temperature = (data['main']['temp'] - 273.15).round();
        condition = data['weather'][0]['description'];
        locationController.text = '';
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Positioned(
              left: 0.0,
              child: Text("Quick Check",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Row(
              children: cities
                  .map((value) => ElevatedButton(
                      onPressed: () {
                        checkWeather(value);
                      },
                      child: Text(value)))
                  .toList()),
          TextField(
            controller: locationController,
            decoration: InputDecoration(
              hintText: 'Enter location',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          // Row(
          //   children: cities.map((value){
          //   ElevatedButton(child: Text(value) ,onPressed: (){},)
          // }).toList()
          // ),
          ElevatedButton(
              onPressed: () {
                String location = locationController.text;
                if (location.isNotEmpty) {
                  checkWeather(location);
                }              
              },
              child: Text('Check Weather')),
          Text(
            'City: $cityName',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Temperature: $temperature C',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Condition: $condition',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
