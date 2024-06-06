import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

const kheight20 = SizedBox(height: 20);
const kheight5 = SizedBox(height: 5);
const kwidth10 = SizedBox(width: 10);
const kwidth5 = SizedBox(width: 5);

class APIEndPoints {
  final apiKey = "JE9L0449XZ2P"; // Replace with your API key
  final timeZoneUrl = "http://api.timezonedb.com/v2.1/get-time-zone";
}

class TimeZoneDetailScreen extends StatefulWidget {
  @override
  _TimeZoneDetailScreenState createState() => _TimeZoneDetailScreenState();
}

class _TimeZoneDetailScreenState extends State<TimeZoneDetailScreen> {
  String selectedTimeZone = '';
  String currentTime = '';
  bool isLoading = false;

  final TextEditingController locationController = TextEditingController();
  final APIEndPoints apiEndPoints = APIEndPoints();

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
  }

  Future<void> fetchTimeZone(String location) async {
    setState(() {
      isLoading = true;
    });

    final Uri uri = Uri.parse('${apiEndPoints.timeZoneUrl}?key=${apiEndPoints.apiKey}&format=json&by=zone&zone=$location');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final String timeZoneId = data['zoneName'];
        setState(() {
          selectedTimeZone = timeZoneId;
          currentTime = _getCurrentTime(timeZoneId);
        });
      } else {
        setState(() {
          selectedTimeZone = 'Location not found';
          currentTime = '';
        });
      }
    } else {
      setState(() {
        selectedTimeZone = 'Error: ${response.reasonPhrase}';
        currentTime = '';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  String _getCurrentTime(String timeZoneId) {
    final location = tz.getLocation(timeZoneId);
    final currentTime = tz.TZDateTime.now(location);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Zone Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Enter location (e.g., America/New_York)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    await fetchTimeZone(locationController.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Time Zone: $selectedTimeZone',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  'Current Time: $currentTime',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
