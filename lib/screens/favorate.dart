import 'package:flutter/material.dart';
import 'package:movie_search/modal/modal.dart';
import 'package:movie_search/database/database.dart';
import 'package:rxdart/rxdart.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Movie> filteredMovies = List();
  List<Movie> movieCache = List();

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
    filteredMovies = [];
    movieCache = [];
    subject.stream.listen(searchDataList);
    setupList();
  }

  void setupList() async{
    MovieDatabase db = MovieDatabase();
    filteredMovies = await db.getMovies();
    setState(() {
      movieCache = filteredMovies;
    });
  }

  void searchDataList(query) {
    if(query.isEmpty){
      setState(() {
        filteredMovies = movieCache;
      });
    }
    setState(() {
    });
    filteredMovies = filteredMovies.where((m) => m.title.toLowerCase().trim().contains(RegExp(r'' + query.toLowerCase().trim() + ''))).toList();
    setState(() {
    });
  }


  void onPressed(int index){
    setState(() {
      filteredMovies.remove(filteredMovies[index]);
    });
    MovieDatabase db = MovieDatabase();
    db.deleteMovie(filteredMovies[index].id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (String string) => (subject.add(string)),
            keyboardType: TextInputType.url,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredMovies.length,
              itemBuilder: (BuildContext context, int index) {
                return new ExpansionTile(
                  title: Container(
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        filteredMovies[index].posterPath != null
                            ? Hero(
                                child: Image.network(
                                    "http://image.tmdb.org/t/p/w92${filteredMovies[index].posterPath}"),
                                tag: filteredMovies[index].id,
                              )
                            : Container(),
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    filteredMovies[index].title,
                                    maxLines: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  initiallyExpanded: filteredMovies[index].isExpanded ?? false,
                  onExpansionChanged: (b) =>
                      filteredMovies[index].isExpanded = b,
                  children: <Widget>[],
                  leading:
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {onPressed(index);
                      }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
