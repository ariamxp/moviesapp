import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetallePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Container(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _crearAppbar( pelicula ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox( height: 10.0,),
                  _posterTitulo( context, pelicula ),
                  _descripcion( pelicula ),
                  _castingPelicula( pelicula )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {

    return SliverAppBar(
      elevation: 2.0,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(
            fontSize: 16.0, 
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
                ),
            ]), 
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgrounImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );

  }

  Widget _posterTitulo( BuildContext context, Pelicula pelicula) {

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
                child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: 10.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle,  style: Theme.of(context).textTheme.subtitle, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon( Icons.star_border ),
                    Text( pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );

  }

  Widget _descripcion(Pelicula pelicula) {

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(pelicula.overview, textAlign: TextAlign.justify,),
    );

  }

  Widget _castingPelicula(Pelicula pelicula) {

    final peliProvider = PeliculasProviders();
    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.hasData) {
          return _createActoresPageView( snapshot.data);
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
      },
    );

  }

  Widget _createActoresPageView( List<Actor> actores ) {

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,

        itemBuilder: (context, i){
          return _actorTarjeta(actores[i]);
        },
      ),
    );

  }

  Widget _actorTarjeta(Actor actor) {

    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
              image: NetworkImage(actor.getActorImg()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              fit: BoxFit.cover,
              height: 150.0,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis),
        ],
      ),
    );

  }

}