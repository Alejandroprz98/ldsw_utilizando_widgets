import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/movie_service.dart';
import 'admin_screen.dart';
import 'movie_detail_screen.dart';
import 'login_screen.dart';
import 'edit_movie_screen.dart';

class HomeScreen extends StatelessWidget {

  final bool isAdmin;

  HomeScreen({required this.isAdmin});

  final service = MovieService();

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Catálogo"),
        actions: [

          // 🔐 BOTÓN ADMIN
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminScreen(),
                  ),
                );
              },
            ),

          // 🚪 LOGOUT
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),

      body: Column(
        children: [

          // 👋 BIENVENIDA
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            color: Colors.red.shade100,
            child: Text(
              "🎬 Bienvenido al catálogo de películas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // 🎥 CATÁLOGO
          Expanded(
            child: StreamBuilder(
              stream: service.getMovies(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final movies = snapshot.data!;

                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: movies.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),

                  itemBuilder: (_, index) {

                    final movie = movies[index];

                    return Card(
                      child: Column(
                        children: [

                          // 🎬 IMAGEN + CLICK A DETALLE
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MovieDetailScreen(movie: movie),
                                  ),
                                );
                              },
                              child: Image.network(movie.image),
                            ),
                          ),

                          // 🎞️ TITULO
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(movie.title),
                          ),

                          // ✏️ BOTÓN EDITAR (SOLO ADMIN)
                          if (isAdmin)
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
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}