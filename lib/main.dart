import 'package:flutter/material.dart';
import 'package:movie_search/screens/home.dart';
import 'package:movie_search/screens/favorate.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Movie Searcher',
      theme: new ThemeData.dark(),
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Movie Searcher App"),
              bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.home),
                      text: 'Home Page',
                    ),
                    Tab(
                      icon: Icon(Icons.favorite),
                      text: "Favorites",
                    )
                  ]
              ),
            ),
            body: TabBarView(
                children: <Widget>[
                  Home(),
                  Favorites()
                ]
            ),
          )
      ),
    );
  }
}

