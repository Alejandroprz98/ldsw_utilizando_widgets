import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import 'edit_movie_screen.dart';

class AdminScreen extends StatefulWidget {

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  final title = TextEditingController();
  final year = TextEditingController();
  final director = TextEditingController();
  final genre = TextEditingController();
  final synopsis = TextEditingController();
  final image = TextEditingController();

  final service = MovieService();

  void saveMovie() async {

    final movie = Movie(
      title: title.text,
      year: year.text,
      director: director.text,
      genre: genre.text,
      synopsis: synopsis.text,
      image: image.text,
    );

    await service.addMovie(movie);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Película agregada")),
    );

    title.clear();
    year.clear();
    director.clear();
    genre.clear();
    synopsis.clear();
    image.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Administración"),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            // ➕ FORMULARIO
            TextField(controller: title, decoration: InputDecoration(labelText: "Título")),
            TextField(controller: year, decoration: InputDecoration(labelText: "Año")),
            TextField(controller: director, decoration: InputDecoration(labelText: "Director")),
            TextField(controller: genre, decoration: InputDecoration(labelText: "Género")),
            TextField(controller: synopsis, decoration: InputDecoration(labelText: "Sinopsis")),
            TextField(controller: image, decoration: InputDecoration(labelText: "Imagen")),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveMovie,
              child: Text("Guardar película"),
            ),

            Divider(height: 40),

            // 🎬 LISTA DE PELÍCULAS
            StreamBuilder(
              stream: service.getMovies(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final movies = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: movies.length,
                  itemBuilder: (_, index) {

                    final movie = movies[index];

                    return Card(
                      child: ListTile(
                        leading: Image.network(movie.image),
                        title: Text(movie.title),
                        subtitle: Text(movie.year),

                        // 🗑️ ELIMINAR
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            // ✏️ EDITAR
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditMovieScreen(movie: movie),
                                  ),
                                );
                              },
                            ),

                            // ❌ ELIMINAR
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await service.deleteMovie(movie.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}