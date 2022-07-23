import 'package:flutter/material.dart';
import 'package:peliculas/screens/screens.dart';
import 'package:provider/provider.dart';

import 'package:peliculas/providers/movies_provider.dart';
 
void main() => runApp(AppState());

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: false ),
      ],
      child: MyApp(),
    );
  }
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: 'home',                   // It could be specified in a specific folder
      routes: {
        'home':    ( _ ) => HomeScreen(),     // _    BuildContext    It's not specified, that's why it's indicated as '_'
        'details': ( _ ) => DetailsScreen(),
      },                          // It could be specified in a specific folder
      theme: ThemeData.light().copyWith(      // It could be specified in a specific folder
        appBarTheme: AppBarTheme(
          color: Colors.indigo
        )
      ),
    );
  }
}