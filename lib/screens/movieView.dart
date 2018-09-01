import 'package:flutter/material.dart';
import 'package:movie_search/modal/modal.dart';
import 'package:movie_search/database/database.dart';


class MovieView extends StatefulWidget {

  final Movie movie;

  MovieView(this.movie);

  @override
  _MovieViewState createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {

  Movie movieState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieState = widget.movie;
    MovieDatabase db = MovieDatabase();
    db.getMovie(movieState.id).then((movie){
      setState(() {
        movieState.favored = movie.favored;
      });
    });
  }

  void onPressed(){
    MovieDatabase db = MovieDatabase();
    setState(() {
      movieState.favored = !movieState.favored;
    });
    movieState.favored == true ? db.addMovie(movieState) : db.deleteMovie(movieState.id);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: movieState.isExpanded ?? false,
      onExpansionChanged: (b) => movieState.isExpanded = b,
      children: <Widget>[
        new Container(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: RichText(
                text: TextSpan(
                  text: movieState.overview,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300
                  )
                )
            ),
          ),
        )
      ],
      leading: IconButton(
          icon: movieState.favored ? Icon(Icons.star) : Icon(Icons.star_border),
          color: Colors.white,
          onPressed: () {
            onPressed();
          }
      ),
      title: Container(
        height: 200.0,
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            movieState.posterPath != null
                ? Hero(
              child: Image.network("http://image.tmdb.org/t/p/w92${movieState.posterPath}"),
              tag: movieState.id,
            )
                :
            Container(),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        movieState.title,
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
    );
  }

}
