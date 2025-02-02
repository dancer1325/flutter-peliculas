import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;      // as   Keyword operator

import 'package:peliculas/helpers/debouncer.dart';

import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {     // ChangeNotifier   To declare as part of Material App's widgets, to share the information
  // Required to make all about this class, to be accessible from the context in any part of the Flutter application

  // TODO: Not commit them
  String _apiKey   = '184dc64f82e7436b85a43f15c730c7c6';
  String _baseUrl  = 'api.themoviedb.org';      // It doesn't contain https://, since it's already understood'
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies   = [];

  // Keep in memory a map of MovieId - List of Cast
  Map<int, List<Cast>> moviesCast = {};
    
  int _popularPage = 0;

  // Class to launch a HTTP after pressing each keyboard
  final debouncer = Debouncer(
    duration: Duration( milliseconds: 500 ),
    // onValue:     // It's not defined here, because we don't know what it's
  );

  // StreamController which emits List<Movie>
  // .broadcast()     allow several objects are suscribed to changes of this stream
  final StreamController<List<Movie>> _suggestionStreamContoller = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamContoller.stream;   // .stream    It's the outcome property

  MoviesProvider() {
    print('MoviesProvider initialized');

    this.getOnDisplayMovies();      // this     It's unnecessary here, but it can be add it to remark it
    this.getPopularMovies();
    // Movie's casting isn't launched each time that it's built the Widget, that's why no request is indicated here
  }

  // [int page = 1]       Optional with 1 as default value
  // []   Indicate that it's optional
  Future<String> _getJsonData( String endpoint, [int page = 1] ) async {
    final url = Uri.https( _baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });
    print('url $url');

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    print('response $response and response.body ${response.body}');
    return response.body;
  }

  // Ways to notify a received request's response
  // 1) notifyListeners();
  getOnDisplayMovies() async {
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    
    onDisplayMovies = nowPlayingResponse.results;
    // It's possible to make the destructuring of the object
    // onDisplayMovies = [...nowPlayingResponse.results];

    // Force to redraw all the widgets, listening
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await this._getJsonData('3/movie/popular', _popularPage );
    final popularResponse = PopularResponse.fromJson( jsonData );

    // Destructuring and concatenating with the one's already stored, since we are changing the page number
    popularMovies = [ ...popularMovies, ...popularResponse.results ];

    // Force to redraw all the widgets, listening
    notifyListeners();
  }

  // 2) Future and await the response in the proper part of the code
  Future<List<Cast>> getMovieCast( int movieId ) async {
    print("movieId $movieId");

    // If the request has been done and stored in memory --> Not to request again
    if( moviesCast.containsKey(movieId) ) return moviesCast[movieId]!;

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson( jsonData );

    // Store in the map, the response received
    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  // Also created, waiting for the response
  Future<List<Movie>> searchMovies( String query ) async {
    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });
    print('url $url');

    final response = await http.get(url);
    print('response $response and response.body ${response.body}');
    final searchResponse = SearchResponse.fromJson( response.body );
    print('searchResponse $searchResponse');

    return searchResponse.results;
  }

  // Establish the logic to launch the request to search the movies
  void getSuggestionsByQuery( String searchTerm ) {
    debouncer.value = '';                         // Reset debouncer.value
    debouncer.onValue = ( value ) async {         // Method invoked after spending timer
      // print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      this._suggestionStreamContoller.add( results );   // Add new event to the StreamController, to be listened by StreamBuilder.stream
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), ( _ ) {     // (_)    Timer which it's not used at all
      debouncer.value = searchTerm;
    });

    // Cancel the timer, if a new value is received
    Future.delayed(Duration( milliseconds: 301)).then(( _ ) => timer.cancel());
  }

}