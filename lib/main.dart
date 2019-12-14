import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pediculas',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/'       :   ( BuildContext context ) => HomePage(),
        'detalle' :   ( BuildContext context ) => PeliculaDetallePage(),
      },
      theme: ThemeData.dark(),
    );
  }
}