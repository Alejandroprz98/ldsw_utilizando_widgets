import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class EditMovieScreen extends StatefulWidget {

  final Movie movie;

  EditMovieScreen({required this.movie});

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {

  final service = MovieService();

  late TextEditingController title;
  late TextEditingController year;
  late TextEditingController director;
  late TextEditingController genre;
  late TextEditingController synopsis;
  late TextEditingController image;

  @override
  void initState() {
    super.initState();

    title = TextEditingController(text: widget.movie.title);
    year = TextEditingController(text: widget.movie.year);
    director = TextEditingController(text: widget.movie.director);
    genre = TextEditingController(text: widget.movie.genre);
    synopsis = TextEditingController(text: widget.movie.synopsis);
    image = TextEditingController(text: widget.movie.image);
  }

  void save() async {

    final updatedMovie = Movie(
      title: title.text,
      year: year.text,
      director: director.text,
      genre: genre.text,
      synopsis: synopsis.text,
      image: image.text,
    );

    await service.updateMovie(widget.movie.id!, updatedMovie);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Película"),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(controller: title, decoration: InputDecoration(labelText: "Título")),
            TextField(controller: year, decoration: InputDecoration(labelText: "Año")),
            TextField(controller: director, decoration: InputDecoration(labelText: "Director")),
            TextField(controller: genre, decoration: InputDecoration(labelText: "Género")),
            TextField(controller: synopsis, decoration: InputDecoration(labelText: "Sinopsis")),
            TextField(controller: image, decoration: InputDecoration(labelText: "Imagen")),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: Text("Guardar cambios"),
            )
          ],
        ),
      ),
    );
  }
}