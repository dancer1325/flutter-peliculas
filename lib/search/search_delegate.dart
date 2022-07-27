import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/providers/movies_provider.dart';

// Required by showSearch --> extends SearchDelegate
class MovieSearchDelegate extends SearchDelegate {
  // Go into flutter's code to check the description
  @override
  String get searchFieldLabel => 'Search movie';

  // Go into flutter's code to check the description
  @override
  List<Widget> buildActions(BuildContext context) {
    // Coding randomly, to return the expected type, to check the outcome
    // return [
    //   Text('buildActions')
    // ];
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',    // query - string shown in the AppBar about the search.
        // If the query is not empty, this should typically contain a button to clear the query
      )
    ];
  }

  // Go into flutter's code to check the description
  @override
  Widget buildLeading(BuildContext context) {
    // Coding randomly, to return the expected type, to check the outcome
    // return Text('buildLeading');
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {   // Typically an [IconButton] configured with a [BackButtonIcon] that exits the search with [close]
        close(context, null);   // null   Value provided for `result` is used as the return value of the call
      },
    );
  }

  // Go into flutter's code to check the description
  @override
  Widget buildResults(BuildContext context) {
    // Coding randomly, to return the expected type, to check the outcome
    return Text('buildResults');
  }

  // Widget to show when no character has been introduced in the text box
  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 130,
        ),
      ),
    );
  }

  // Go into flutter's code to check the description
  @override
  Widget buildSuggestions(BuildContext context) {
    // Coding randomly, to return the expected type, to check the outcome
    // $query   One of the SearchDelegate's properties. Query string shown in the AppBar
    // return Text('buildSuggestions $query');
    if (query.isEmpty) {
      return _emptyContainer();
    }

    // Get access to the provider via context
    // listen   false - Since it won't be redrawn in case that there are value changes, my code is in charge of relaunching the request
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    
    return FutureBuilder(
        future: moviesProvider.searchMovies(query),
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) return _emptyContainer();
          final movies = snapshot.data!;    // .data    It's the latest data received from the async computation

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) => _MovieItem(movies[index]));
        }
    );
    
    moviesProvider.getSuggestionsByQuery(query);

    // return StreamBuilder(
    //   stream: moviesProvider.suggestionStream,
    //   builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
    //     if (!snapshot.hasData) return _emptyContainer();
    //
    //     final movies = snapshot.data!;
    //
    //     return ListView.builder(
    //         itemCount: movies.length,
    //         itemBuilder: (_, int index) => _MovieItem(movies[index]));
    //   },
    // );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
