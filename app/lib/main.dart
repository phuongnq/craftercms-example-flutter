import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

const String _baseUrl = 'http://localhost:8080';
const String _craftercmsApiDescriptor = '/api/1/site/content_store/descriptor.json';
const String _crafterSite = 'flutter-sample';

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
  final List<Hero> heros;

  const Model({
    required this.id,
    required this.path,
    required this.navLabel,
    required this.title,
    required this.heros,
  });

  factory Model.fromJson(String path, Map<String, dynamic> json) {
    List<Hero> heros = [];

    if(json['page']['content_o']['item'] != null) {
      heros = (json['page']['content_o']['item'] as List)
        .map((dynamic item) => Hero.fromJson(item))
        .toList();
    }
    return Model(
      id: json['page']['objectId'],
      path: path,
      navLabel: json['page']['navLabel'],
      title: json['page']['title_s'],
      heros: heros,
    );
  }
}

class Hero {
  final String id;
  final String backgroundImg;
  final String title;

  const Hero({
    required this.id,
    required this.backgroundImg,
    required this.title,
  });

  factory Hero.fromJson(Map<String, dynamic> json) {
    return Hero(
      id: json['key'],
      backgroundImg: _baseUrl + json['component']['background_s'],
      title: json['component']['title_s'],
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

Future<Model> fetchModel(path) async {
  final String url = _baseUrl + _craftercmsApiDescriptor + '?site_id=' + _crafterSite + '&flatten=true&url=' + path;
  final response = await http.get(
    Uri.parse(url)
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    return Model.fromJson(path, json);
  } else {
    throw Exception('Failed to load model');
  }
}

Future<AboutModel> fetchAboutModel(path) async {
  final String url = _baseUrl + _craftercmsApiDescriptor + '?crafterSite=' + _crafterSite + '&flatten=true&url=' + path;
  final response = await http.get(
    Uri.parse(url)
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return AboutModel.fromJson(path, json);
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
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: snapshot.data!.heros.map((hero) {
                          return Stack(
                            children: [
                              Image.network(
                                hero.backgroundImg,
                                height: 300,
                                width: double.infinity,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
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
                                      hero.title,
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
                          );
                        }).toList(),
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