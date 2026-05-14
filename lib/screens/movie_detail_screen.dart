import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {

  final Movie movie;

  MovieDetailScreen({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Image.network(movie.image),

            SizedBox(height: 20),

            Text(
              movie.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text("Año: ${movie.year}"),
            Text("Director: ${movie.director}"),
            Text("Género: ${movie.genre}"),

            Padding(
              padding: EdgeInsets.all(20),
              child: Text(movie.synopsis),
            )
          ],
        ),
      ),
    );
  }
}