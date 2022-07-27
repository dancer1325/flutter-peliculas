import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

// Reasons to create as StatefulWidget
// 1) Keep the reference to the Scrollview
// 2) Initialize and add a listener to the Scrollview
// 3) Destroy ScrollController when they aren't necessaries, to avoid Flutter have always on memory
class MovieSlider extends StatefulWidget {
  // Arguments passed to handle all about the MovieSlider
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;    // Function, which will launch the HTTP call

  const MovieSlider({
    Key? key, 
    required this.movies, 
    required this.onNextPage,
    this.title, 
  }) : super(key: key);

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  // This ScrollController is associated to ListView's builder
  final ScrollController scrollController = new ScrollController();

  // Executed the first time the Widget is built
  @override
  void initState() { 
    super.initState();
    
    scrollController.addListener(() {
      // print(scrollController.position.pixels);     // ScrollController's position, according you move your mouse
      // scrollController.position.maxScrollExtent      Maximum position to which the ScrollController can be extended
      if ( scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500 ) {
        print('Call to the next page elements');
        widget.onNextPage();
      }
    });
  }

  // Executed when the Widget is destroyed
  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          if ( this.widget.title != null )
            Padding(
              padding: EdgeInsets.symmetric( horizontal: 20 ),
              child: Text( this.widget.title!, style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold ),),
            ),

          SizedBox( height: 5 ),

          Expanded(     // Widget to avoid problems with the size, since it's expanded to all the parent Widget's size
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,     // By default the scroll is vertical
              itemCount: widget.movies.length,
              itemBuilder: ( _, int index) => _MoviePoster( widget.movies[index], '${ widget.title }-$index-${ widget.movies[index].id }' )
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;

  const _MoviePoster( this.movie, this.heroId );

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      margin: EdgeInsets.symmetric( horizontal: 10 ),
      child: Column(
        children: [
          GestureDetector(        // It allows doing navigation based on Tap event
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie ),    // details    Name indicated as route
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(   // Wrap FadeInImage with it, to add a 'borderRadius'
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  // image: NetworkImage('https://via.placeholder.com/300x400')     // Blank placeholder image
                  image: NetworkImage( movie.fullPosterImg ),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox( height: 5 ),

          Text( 
            movie.title,
            maxLines: 2,    // # of lines
            overflow: TextOverflow.ellipsis,    // If all text can't be added --> '...' is added
            textAlign: TextAlign.center,
          )

        ],
      ),
    );
  }
}