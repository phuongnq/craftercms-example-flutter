import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:app/constant.dart' as craftercms_constants;

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

Future<AboutModel> fetchAboutModel(path) async {
  final String url = craftercms_constants.baseUrl + craftercms_constants.apiDescriptor + '?crafterSite=' + craftercms_constants.siteName + '&flatten=true&url=' + path;
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