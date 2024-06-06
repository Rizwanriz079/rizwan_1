import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class News extends StatefulWidget {
  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _headlineNewsList = [];
  List<dynamic> _malayalamNewsList = [];
  List<dynamic> _otherNewsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final Map<String, String> sources = {
      'Latest News': 'google-news',
      'Malayalam News': 'manorama-online',
      'Sports News': 'bbc-sport',
      'Politics News': 'politico',
      'Technology News': 'techcrunch',
      'IPL News': 'espn-cric-info', // Add IPL news source
      'Kerala News': 'the-hindu',
    };

    List<dynamic> combinedHeadlineNewsList = [];
    List<dynamic> combinedMalayalamNewsList = [];
    List<dynamic> combinedOtherNewsList = [];

    // Fetch news from specified sources
    for (String categoryName in sources.keys) {
      final String? source = sources[categoryName];
      final Uri url = Uri.parse(
          'https://newsapi.org/v2/top-headlines?sources=$source&apiKey=0d61d0309775460ba97823a2aaeee944');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> categoryNewsList =
        json.decode(response.body)['articles'];
        // Add category label to each news item
        categoryNewsList.forEach((news) {
          news['category'] = categoryName;
        });
        if (categoryName == 'Latest News') {
          combinedHeadlineNewsList.addAll(categoryNewsList);
        }
        else if (categoryName == 'Malayalam News') {
          combinedMalayalamNewsList.addAll(categoryNewsList);
        }
        else {
          combinedOtherNewsList.addAll(categoryNewsList);
        }
      } else {
        throw Exception('Failed to load $categoryName news');
      }
    }

    setState(() {
      _headlineNewsList = combinedHeadlineNewsList;
      _malayalamNewsList = combinedMalayalamNewsList;
      _otherNewsList = combinedOtherNewsList;
    });
  }

  void filterNews(String query) {
    List<dynamic> filteredNews = _otherNewsList.where((news) {
      return news['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _otherNewsList = filteredNews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Headline News',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _buildCarousel(_headlineNewsList),
                  SizedBox(height: 16.0),
                  // Text(
                  //   'Malayalam News',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 8.0),
                  // _buildCarousel(_malayalamNewsList),
                  // SizedBox(height: 16.0),

                  Text(
                    'Other News',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return _buildNewsContainer(_otherNewsList[index]);
              },
              childCount: _otherNewsList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<dynamic> newsList) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: newsList.map((news) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: news['urlToImage'] != null
                          ? Image.network(
                        news['urlToImage'],
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : Center(child: Text('No Image Available')),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        news['title'] ?? '',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }


  Future<Uint8List> _fetchImage(String? imageUrl) async {
    if (imageUrl == null) return Uint8List(0);
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Widget _buildNewsContainer(dynamic newsItem) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          newsItem['urlToImage'] != null
              ? Image.network(
            newsItem['urlToImage'],
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          )
              : SizedBox.shrink(),
          SizedBox(height: 8.0),
          Text(
            newsItem['title'] ?? '',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.0),
          Text(
            newsItem['description'] ?? '',
            style: TextStyle(fontSize: 12.0),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}



// Your API key is: 0d61d0309775460ba97823a2aaeee944