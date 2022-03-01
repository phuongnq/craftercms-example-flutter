import 'package:flutter/material.dart';
import 'dart:js' as js;

void main() {
  runApp(const MaterialApp(
    title: 'Flutter + CrafterCMS Demo',
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState(this);

  void onLoad(BuildContext context) {
    js.context.callMethod('initICE', ['/']);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home '),
      ),
      body: Center(
        child: Column(
          children: <Widget> [
            const Text(
              'Welcome to CrafterCMS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
            )
            ),
            ElevatedButton(
              child: const Text('About Us'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      )
    );
  }
}

class _HomePageState extends State<HomePage> {
  HomePage widget;

  _HomePageState(this.widget);

  @override
  Widget build(BuildContext context) => widget.build(context);

  @override
  void initState() => widget.onLoad(context);
}

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutPageState(this);

  void onLoad(BuildContext context) {
    js.context.callMethod('initICE', ['/about']);
  }

  Widget build(BuildContext context) {
    js.context.callMethod('initICE', ['/about']);
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const Center(
        child: Text(
          'About Us',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          )
        ),
      ),
    );
  }
}

class _AboutPageState extends State<AboutPage> {
  AboutPage widget;

  _AboutPageState(this.widget);

  @override
  Widget build(BuildContext context) => widget.build(context);

  @override
  void initState() => widget.onLoad(context);
}