import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rizwan/Screens/moreoptions.dart';

import 'Screens/Home.dart';
import 'Screens/movie.dart';
import 'Screens/news.dart';
import 'Screens/timezone.dart';
import 'Screens/weather.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/movies': (context) => Movie(),
        '/weather': (context) => Weather(),
        '/timezones': (context) => TimeZoneDetailScreen(),
        '/news': (context) => News(),
        '/bookscreen': (context) => JokeScreen(),
      },
    );
  }
}
