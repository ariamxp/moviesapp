import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

Future<List<Pelicula>> _procesarRespuesta(Uri uri) async{

  final resp = await http.get( uri );
  final decodedData = json.decode(resp.body);
  final peliculas = Peliculas.fromJsonList(decodedData['results']);
  print('${peliculas.items} callo');
  return peliculas.items;
  
}

class PeliculasProviders {

  String _apikey   = '7a7e15b3c8da925b8011e41db12bef54';
  String _url      = 'api.themoviedb.org';
  String _lenguaje = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   : _apikey,
      'language'  : _lenguaje
    });

    return await _procesarRespuesta(url);

  }

  Future<List<Pelicula>> getPopulares() async {

    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   : _apikey,
      'language'  : _lenguaje,
      'page'      : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;

  }
  
  Future<List<Actor>> getCast(String peliId) async{
    
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key'   : _apikey,
      'language'  : _lenguaje
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final casting = Casting.fromJsonList(decodedData['cast']);

    return casting.actores;

  }


  Future<List<Pelicula>> buscarPelicula( String query ) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'   : _apikey,
      'language'  : _lenguaje,
      'query'     : query
    });

    return await _procesarRespuesta(url);

  }
 
}

