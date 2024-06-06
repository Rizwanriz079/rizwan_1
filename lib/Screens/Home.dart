import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text('OmniConnect'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.movie),
              onPressed: () {
                Navigator.pushNamed(context, '/movies');
              },
            ),
            IconButton(
              icon: Icon(Icons.cloud),
              onPressed: () {
                Navigator.pushNamed(context, '/weather');
              },
            ),
            IconButton(
              icon: Icon(Icons.language),
              onPressed: () {
                Navigator.pushNamed(context, '/timezones');
              },
            ),
            IconButton(
              icon: Icon(Icons.article),
              onPressed: () {
                Navigator.pushNamed(context, '/news');
              },
            ),
            IconButton(
              icon: Icon(Icons.book),
              onPressed: () {
                Navigator.pushNamed(context, '/bookscreen');
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Menu options
              // Container(
              // height: 80, // Adjust height as needed
              // color: Colors.blue, // Customize color as needed
              // child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // // children: [
              // // MenuItem(icon: Icons.cloud, label: 'Weather'),
              // // MenuItem(icon: Icons.movie, label: 'Movies'),
              // // MenuItem(icon: Icons.language, label: 'Time Zones'),
              // // MenuItem(icon: Icons.article, label: 'News'),
              // // MenuItem(icon: Icons.menu_book, label: 'More'),
              // // ],
              // ),
              // ),
              // Common screen content
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: [
              //         // Display common screen content here
              //         // Example: Weather forecasts, trending movies, news updates, etc.
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
