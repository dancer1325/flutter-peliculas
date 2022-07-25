// To parse this JSON data, do
//
//     final nowPlayingResponse = nowPlayingResponseFromMap(jsonString);

import 'dart:convert';

import 'movie.dart';

class NowPlayingResponse {
  
    NowPlayingResponse({
        required this.dates,
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    Dates dates;
    int page;
    List<Movie> results;        // In provider's model is named 'Result'
    int totalPages;
    int totalResults;

    // factory     Constructor to return an
    // A) existing instance (from a cache)
    // B) new instance of a subtype
    factory NowPlayingResponse.fromJson(String str) => NowPlayingResponse.fromMap(json.decode(str));        //json.decode()     Returns Map<String, dynamic>

    factory NowPlayingResponse.fromMap(Map<String, dynamic> json) => NowPlayingResponse(
        dates       : Dates.fromMap(json["dates"]),
        page        : json["page"],
        results     : List<Movie>.from( json["results"].map((x) => Movie.fromMap(x))),
        totalPages  : json["total_pages"],
        totalResults: json["total_results"],
    );
}

class Dates {
    Dates({
        required this.maximum,
        required this.minimum,
    });

    DateTime maximum;
    DateTime minimum;

    factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str));      //json.decode()     Returns Map<String, dynamic>

    factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
    );
}

