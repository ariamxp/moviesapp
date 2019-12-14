import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Ironman',
    'Shazam',
    'Capitan America'
  ];

  final peliculasRecientes = [
    'Wonder Woman',
    'La Cenicicenta',
    'IT',
    'Los Vengadores',
    'El Chacal',
    'Frozen 2'
  ];

  String seleccion = '';
  final peliculasProvider = PeliculasProviders();

  //PARA RESPETAR EL TEMA DARK
  @override
   ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones para nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados para mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.black26,
        child: Text(seleccion),
      ),
    );
  }

 

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que se muestra al buscar

    if(query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {

          final peliculas = snapshot.data;
          print(peliculas);
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  //close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );

        } else {

          return Center(
            child: CircularProgressIndicator(),
          );

        }
      },
    );
    
  }



    // @override
    // Widget buildSuggestions(BuildContext context) {
    //   // Son las sugerencias que se muestra al buscar

    //   final listaSugerida = (query.isEmpty)
    //                             ? peliculasRecientes
    //                             : peliculas.where(
    //                               (p)=>p.toLowerCase().startsWith(query.toLowerCase())
    //                               ).toList();

    //   return ListView.builder(
    //     itemCount: listaSugerida.length,
    //     itemBuilder: (context, i){
    //       return ListTile(
    //         leading: Icon(Icons.movie),
    //         title: Text(listaSugerida[i]),
    //         onTap: (){
    //           seleccion = listaSugerida[i];
    //           showResults(context);
    //         },
    //       );
    //     },
    //   );
    // }

  
}

