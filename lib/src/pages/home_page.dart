import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget {

  final peliculasProvider = PeliculasProviders();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){

              showSearch( 
                context: context, 
                delegate: DataSearch(),
                //query: 'Hola'
                );

            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper( peliculas: snapshot.data );
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator()
              ),
          );
        }
      },
    );

  }

  Widget _footer( BuildContext context ){

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle,)
            ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal( 
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares, );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator()
                    ),
                );
              }
            },
          ),
        ],
      ),
    );

  }

}