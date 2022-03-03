import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app/pages/home.dart';
import 'package:app/pages/about.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter + CrafterCMS Demo',
    initialRoute: '/',
    onGenerateRoute: (RouteSettings settings) {
      final List<String> pathElements = settings.name!.split('/');

      if (pathElements[0] != '') {
        return null;
      }

      if (pathElements[1] == '' || pathElements[1] == 'home') {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const MainApp(pageName: 'home'),
        );
      }

      if (pathElements[1] == 'about') {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const MainApp(pageName: 'about'),
        );
      }
      return null;
    },
  ));
}

class MainApp extends StatefulWidget {
  final String pageName;
  const MainApp({ Key? key, this.pageName = 'home' }) : super(key: key);
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AboutPage(),
  ];

  @override
  void initState() {
    super.initState();

    switch (widget.pageName) {
      case 'home':
        _selectedIndex = 0;
        break;
      case 'about':
        _selectedIndex = 1;
        break;
      default:
        _selectedIndex = 0;
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/about');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
      );
  }
}