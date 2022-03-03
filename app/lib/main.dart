import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:xml2json/xml2json.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

const String _baseUrl = 'http://localhost:8080';
const String _crafterApiGetContent = '/studio/api/1/services/api/1/content/get-content.json';
const String _crafterSite = 'flutter-sample';
const String _authorization = 'Bearer eyJhbGciOiJQQkVTMi1IUzUxMitBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiY3R5IjoiSldUIiwicDJjIjo4MTkyLCJwMnMiOiJvZDhFcGZ5VHNTeHVZVHNEIn0.D1duKec1uFngkhohTKG5O1s7YMQtAcmQGTIKyCriGiNk7o3bXhE6LnAHZqmb_fa6_NN2DwPdWXA7A0l7CPdIsw1R-Khl2fJQ.5L6-ZLV0rdGPiHA_avl_lA.RU2nodWyL0fldnHhdR92Y97IjWclqDq0rXfs_CKAbm7PACEHf6SDAFG3HTA9ACZF8rh1AwBiRAIMLOtFyxgdiuh4Y8FOFPN55wuFqoZ_EvnPi2FGBeI2oJUbYkK91n25yIckrfcEXEB7uQqqSkckoAFgaqO_hHrgeI_OV3yV59SckYIqh3LU1avYZd6zrZcOhHebZlEZH7wI_WONyWIkX6YGIEl-f1jYvTnzEiY3mVXmx1bm_AJGWhjzHX4AbgxarZilM6njK-2a0loKjxuKXuCF2vqHNC0mEn3F_LJd5i7wlB5nveXLiMetufyIJkLbu6hVG6zKnhOm4Lk1_MRzhg.u6eEMh2oJs2DhY9mfdfChP7Eh34mzDmyGrdNqs57kcA';

void main() {
  runApp(const MaterialApp(
    title: 'Flutter + CrafterCMS Demo',
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter + CrafterCMS Demo'),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'About',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class Model {
  final String id;
  final String path;
  final String navLabel;
  final String title;
  final Hero hero;

  const Model({
    required this.id,
    required this.path,
    required this.navLabel,
    required this.title,
    required this.hero,
  });

  factory Model.fromJson(String path, Map<String, dynamic> json, Hero hero) {
    return Model(
      id: json['page']['objectId'],
      path: path,
      navLabel: json['page']['navLabel'],
      title: json['page']['title_s'],
      hero: hero,
    );
  }
}

class Hero {
  final String backgroundImg;
  final String title;

  const Hero({
    required this.backgroundImg,
    required this.title,
  });

  factory Hero.fromJson(Map<String, dynamic> json) {
    final transformer = Xml2Json();
    transformer.parse(json['content']);
    final content = transformer.toParker();
    final parsedJson = jsonDecode(content);
    return Hero(
      backgroundImg: _baseUrl + parsedJson['component']['background_s'],
      title: parsedJson['component']['title_s'],
    );
  }
}

class AboutModel {
  final String id;
  final String path;
  final String navLabel;
  final String title;

  const AboutModel({
    required this.id,
    required this.path,
    required this.navLabel,
    required this.title,
  });

  factory AboutModel.fromJson(path, Map<String, dynamic> json) {
    return AboutModel(
      id: json['page']['objectId'],
      path: path,
      navLabel: json['page']['navLabel'],
      title: json['page']['title_s'],
    );
  }
}

Future<Hero> fetchHero(String path) async {
  final String url = _baseUrl + _crafterApiGetContent + '?site_id=' + _crafterSite + '&path=' + path;
  final response = await http.get(
    Uri.parse(url),
    headers: {
      HttpHeaders.authorizationHeader: _authorization,
    },
  );

  if (response.statusCode == 200) {
    return Hero.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load model');
  }
}

Future<Model> fetchModel(path) async {
  final String url = _baseUrl + _crafterApiGetContent + '?site_id=' + _crafterSite + '&path=' + path;
  final response = await http.get(
    Uri.parse(url),
    headers: {
      HttpHeaders.authorizationHeader: _authorization,
    },
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final transformer = Xml2Json();
    transformer.parse(json['content']);
    final content = transformer.toParker();
    final parsedJson = jsonDecode(content);

    final heroPath = parsedJson['page']['content_o']['item']['include'];
    final hero = await fetchHero(heroPath);

    return Model.fromJson(path, parsedJson, hero);
  } else {
    throw Exception('Failed to load model');
  }
}

Future<AboutModel> fetchAboutModel(path) async {
  final String url = _baseUrl + _crafterApiGetContent + '?site_id=' + _crafterSite + '&path=' + path;
  final response = await http.get(
    Uri.parse(url),
    headers: {
      HttpHeaders.authorizationHeader: _authorization,
    },
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final transformer = Xml2Json();
    transformer.parse(json['content']);
    final content = transformer.toParker();
    final parsedJson = jsonDecode(content);
    return AboutModel.fromJson(path, parsedJson);
  } else {
    throw Exception('Failed to load model');
  }
}

class _HomePageState extends State<HomePage> {
  late Future<Model> _futureModel;

  _HomePageState();

  @override
  void initState() {
    super.initState();
    const path = '/site/website/index.xml';
    _futureModel = fetchModel(path);
    Stream.fromFuture(_futureModel).listen((model) {
      final id = model.id;
      final label = model.navLabel;
      js.context.callMethod('initICE', [path, id, label]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: FutureBuilder<Model>(
              future: _futureModel,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        snapshot.data!.title,
                        style: Theme.of(context).textTheme.headline4
                      ),
                      Stack(
                        children: [
                          Image.network(
                            snapshot.data!.hero.backgroundImg,
                            height: 300,
                            fit: BoxFit.fitWidth,
                          ),
                          Positioned(
                            bottom: 100,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Text(
                                  snapshot.data!.hero.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late Future<AboutModel> _futureModel;

  _AboutPageState();

  @override
  void initState() {
    super.initState();

    const path = '/site/website/about/index.xml';
    _futureModel = fetchAboutModel(path);
    Stream.fromFuture(_futureModel).listen((model) {
      final id = model.id;
      final label = model.navLabel;
      js.context.callMethod('initICE', [path, id, label]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: FutureBuilder<AboutModel>(
              future: _futureModel,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        snapshot.data!.title,
                        style: Theme.of(context).textTheme.headline4
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}