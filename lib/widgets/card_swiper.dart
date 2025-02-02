import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:peliculas/models/models.dart';

class CardSwiper extends StatelessWidget {
  // Add this property to pass the movies got it via provider
  final List<Movie> movies;

  const CardSwiper({
    Key? key, 
    required this.movies
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the device's width
    final size = MediaQuery.of(context).size;

    // Check since it's invoked at the beginning
    if( this.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          child: CircularProgressIndicator(),   // Widget which shows a circular loading
        ),
      );
    }

    return Container(
      width: double.infinity,     // Fulfill all the possible width
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: ( _ , int index ) {      // Since BuildContext isn't used --> _
          final movie = movies[index];

          // Generate unique Id
          movie.heroId = 'swiper-${ movie.id }';

          return GestureDetector(   // It allows doing navigation based on Tap event
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(            // Wrap with Hero to make a transaction -- animation in the transaction to share the same widget -- by tag
              // This one corresponds to the 'details_screen''s one
              tag: movie.heroId!,   // Hero's Id
              child: ClipRRect(   // Wrap FadeInImage with it, to add a 'borderRadius'
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  // image: NetworkImage('https://via.placeholder.com/300x400')     // Blank placeholder image
                  image: NetworkImage( movie.fullPosterImg ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );

        },
      ),
    );
  }
}