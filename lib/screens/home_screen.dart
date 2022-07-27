import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Get access to the provider via context
    final moviesProvider = Provider.of<MoviesProvider>(context);
    // final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);
    // listen   true - Value changes trigger automatically the redrawing. By default, it's true.    false - Required to call `Provider.of` inside the method

    // Since you are notifying the listener --> Next line is invoked 3 times
    print('moviesProvider.onDisplayMovies - HomeScreen-  ${moviesProvider.onDisplayMovies}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon( Icons.search_outlined ),
            //https://api.flutter.dev/flutter/material/showSearch.html
            // Shows a full screen search page and returns the search result selected by the user when the page is closed.
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate() ),
          )
        ],
      ),
      body: SingleChildScrollView(    // Widget to avoid problems if we exceed device's size, since you can scroll
        child: Column(    // To place Widgets one down to each other
          children: [
            // Tarjetas principales
            CardSwiper( movies: moviesProvider.onDisplayMovies ),

            // Slider de películas
            MovieSlider(
              movies: moviesProvider.popularMovies,// populares,
              title: 'Populares', // opcional
              onNextPage: () => moviesProvider.getPopularMovies(),    // Function which will call next popular movies
            ),
          ],
        ),
      )
    );
  }
}