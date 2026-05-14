import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieService {

  final collection =
      FirebaseFirestore.instance.collection('movies');

  // ➕ AGREGAR
  Future<void> addMovie(Movie movie) async {
    await collection.add(movie.toMap());
  }

  // 📥 LEER
  Stream<List<Movie>> getMovies() {
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Movie.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  // 🗑️ ELIMINAR
  Future<void> deleteMovie(String id) async {
    await collection.doc(id).delete();
  }

  // ✏️ EDITAR (NUEVO)
  Future<void> updateMovie(String id, Movie movie) async {
    await collection.doc(id).update(movie.toMap());
  }
}