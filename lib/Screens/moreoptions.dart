import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JokeScreen extends StatefulWidget {
  @override
  _JokeScreenState createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  String setup = '';
  String punchline = '';

  Future<void> fetchJoke() async {
    final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/random_joke'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        setup = data['setup'];
        punchline = data['punchline'];
      });
    } else {
      throw Exception('Failed to load joke');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke App', style: TextStyle(fontFamily: 'Pacifico')), // Using a playful font
        backgroundColor: Colors.amber[700], // Bright and cheerful color
      ),
      backgroundColor: Colors.amber[100], // Lighter background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Joke Setup:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo[900]), // Larger font size, bold, and a deep color
            ),
            SizedBox(height: 10),
            Text(
              setup,
              style: TextStyle(fontSize: 20, color: Colors.indigo[900]), // Slightly smaller font size
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Punchline:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo[900]), // Larger font size, bold, and a deep color
            ),
            SizedBox(height: 10),
            Text(
              punchline,
              style: TextStyle(fontSize: 20, color: Colors.indigo[900]), // Slightly smaller font size
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchJoke,
              child: Text('Get Another Joke'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900], // Deep color for the button
                textStyle: TextStyle(fontSize: 20), // Larger font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
