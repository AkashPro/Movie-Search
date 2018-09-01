import 'package:flutter/material.dart';
import 'package:movie_search/modal/modal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:movie_search/screens/movieView.dart';
import 'dart:convert';

const key = '3fd48ab4107eaa28f7242170bdffae95';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Movie> movies = List();
  bool hasLoaded = true;

  final PublishSubject subject = PublishSubject<String>();

  @override
  void dispose() {
    // TODO: implement dispose
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subject.stream.debounce(Duration(milliseconds: 1000)).listen(searchMovies);
  }

  void searchMovies(query) {
    resetMovies();
    if (query.isEmpty) {
      setState(() {
        hasLoaded = true;
      });
    }
    setState(() {
      hasLoaded = false;
    });
    http
        .get(
            'https://api.themoviedb.org/3/search/movie?api_key=$key&query=$query')
        .then((res) => (res.body))
        .then(json.decode)
        .then((map) => map["results"])
        .then((movies) => movies.forEach(addMovies))
        .catchError(onError)
        .then((e) {
      setState(() {
        hasLoaded = true;
      });
    });
  }

  void onError(dynamic d) {
    setState(() {
      hasLoaded = true;
    });
  }

  void addMovies(item) {
    setState(() {
      movies.add(Movie.fromJson(item));
    });
    print('${movies.map((m) => m.posterPath)}');
  }

  void resetMovies() {
    setState(() {
      movies.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (String string) => (subject).add(string),
          ),
          hasLoaded ? Container() : CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return new MovieView(movies[index]);
              },
              padding: EdgeInsets.all(10.0),
              itemCount: movies.length,
            ),
          )
        ],
      ),
    );
  }
}
