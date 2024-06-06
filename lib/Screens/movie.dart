import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Constants/Constants.dart';

const String apiUrl = 'https://hoblist.com/api/movieList';

class Movie extends StatefulWidget {
  @override
  _MovieState createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  List<dynamic> _movies = [];
  bool _isLoading = true;
  String _selectedLanguage = 'kannada';
  String _selectedGenre = 'all';

  @override
  void initState() {
    super.initState();
    _fetchMovieList();
  }

  Future<void> _fetchMovieList() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'category': 'movies',
          'language': _selectedLanguage,
          'genre': _selectedGenre,
          'sort': 'voting',
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('result')) {
          setState(() {
            _movies = responseData['result'];
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load movie list');
        }
      } else {
        throw Exception('Failed to load movie list');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // void _showCompanyInfo() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Company Info'),
  //         content: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Company: Geeksynergy Technologies Pvt Ltd'),
  //             Text('Address: Sanjayanagar, Bengaluru-56'),
  //             Text('Phone: XXXXXXXXX09'),
  //             Text('Email: XXXXXX@gmail.com'),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie'),
        actions: [
          _buildFilterDropdown('Language', _selectedLanguage, ['kannada', 'english', 'hindi','malayalam']),
          _buildFilterDropdown('Genre', _selectedGenre, ['all', 'action', 'romance', 'thriller']),
          // PopupMenuButton(
          //   itemBuilder: (BuildContext context) {
          //     return [
          //       PopupMenuItem(
          //         child: Text('Company Info'),
          //         value: 'company_info',
          //       ),
          //     ];
          //   },
          //   onSelected: (value) {
          //     if (value == 'company_info') {
          //       _showCompanyInfo();
          //     }
          //   },
          // ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_upward),
                        ),
                        Text(
                          movie['voting'] != null ? movie['voting'].toString() : '0',
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_downward),
                        ),
                        Text(
                          'Votes', // Display 'Vote' text
                          style: TextStyle(fontSize: 12), // Customize text style
                        ),
                      ],
                    ),
                    kwidth5, // Add spacing between voting and movie details
                    Expanded(
                      child: ListTile(
                        title: Text(
                          movie['title'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kheight5,
                            Text('Genre: ${_getListAsString(movie['genre']) ?? 'N/A'}'),
                            Text('Director: ${movie['director'] ?? 'N/A'}'),
                            Text('Starring: ${_getListAsString(movie['stars']) ?? 'N/A'}'),
                            Text('Language: ${movie['language'] ?? 'N/A'}'),
                          ],
                        ),
                        leading: Image.network(
                          movie['poster'] ?? '',
                          width: 70,
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 80.0), // Adjust horizontal padding
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => (),
                      child: Text(
                        'Watch Trailer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),),
                ),
              ],
            ),
          );

        },
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options) {
    return DropdownButton<String>(
      value: value,
      onChanged: (newValue) {
        setState(() {
          if (label == 'Language') {
            _selectedLanguage = newValue!;
          } else if (label == 'Genre') {
            _selectedGenre = newValue!;
          }
          _isLoading = true;
          _fetchMovieList();
        });
      },
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }

  String _getListAsString(dynamic value) {
    if (value is List) {
      return value.join(', ');
    } else {
      return value.toString();
    }
  }
}
