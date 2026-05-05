import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';

class PerfilScreen extends StatelessWidget {

  final Future<Pokemon> pokemon = fetchPokemon();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blue,
            child: Column(
              children: [
                Text(
                  'Alejandro Pérez Rosas',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  'Desarrollador Flutter',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          FutureBuilder<Pokemon>(
            future: pokemon,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final poke = snapshot.data!;
                return Column(
                  children: [
                    Image.network(poke.image),
                    Text(
                      poke.name.toUpperCase(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}