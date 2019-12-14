import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){

          peliculas[index].uniqueId = '${peliculas[index].id}-card';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              onTap: (){ 
                
                Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);

              },
            ),
          );
        },
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemCount: peliculas.length,
        //pagination: SwiperPagination(),
        //control: SwiperControl(),
        layout: SwiperLayout.STACK,
      ),
    );

  }

}