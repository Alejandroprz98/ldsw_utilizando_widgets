import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex Pro',
      debugShowCheckedModeBanner: false,
      home: PokedexScreen(),
    );
  }
}

// -------------------- MODELO --------------------
class Pokemon {
  final String name;
  final String image;
  final int attack;
  final int defense;
  final int speed;

  Pokemon({
    required this.name,
    required this.image,
    required this.attack,
    required this.defense,
    required this.speed,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      image: json['sprites']['front_default'],
      attack: json['stats'][1]['base_stat'],
      defense: json['stats'][2]['base_stat'],
      speed: json['stats'][5]['base_stat'],
    );
  }
}

// -------------------- API --------------------
Future<Pokemon> fetchPokemonByName(String name) async {
  final response = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}'),
  );

  if (response.statusCode == 200) {
    return Pokemon.fromJson(json.decode(response.body));
  } else {
    throw Exception('No encontrado');
  }
}

Future<Pokemon> fetchRandomPokemon() async {
  final id = Random().nextInt(151) + 1;

  final response = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'),
  );

  if (response.statusCode == 200) {
    return Pokemon.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error');
  }
}

// -------------------- PANTALLA --------------------
class PokedexScreen extends StatefulWidget {
  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final controller = TextEditingController();
  final player = AudioPlayer();

  late Future<Pokemon> pokemon;

  List<Pokemon> favoritos = [];

  @override
  void initState() {
    super.initState();
    pokemon = fetchRandomPokemon();

    // 🔊 VOLUMEN GLOBAL BAJO
    player.setVolume(0.2);
  }

  void buscar() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      pokemon = fetchPokemonByName(text);
    });

    playSound();
  }

  void random() {
    setState(() {
      pokemon = fetchRandomPokemon();
    });

    playSound();
  }

  void agregarFavorito(Pokemon p) {
    if (!favoritos.any((e) => e.name == p.name)) {
      setState(() {
        favoritos.add(p);
      });
    }
  }

  Future<void> playSound() async {
    try {
      await player.stop(); // evita sonidos duplicados

      await player.play(
        UrlSource(
          'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/25.ogg',
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text('Pokédex Pro'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [

          // 🔍 BUSCADOR
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Buscar Pokémon...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: buscar,
                )
              ],
            ),
          ),

          // BOTÓN RANDOM
          ElevatedButton(
            onPressed: random,
            child: Text("Aleatorio"),
          ),

          SizedBox(height: 10),

          // 🔥 RESULTADO
          Expanded(
            child: FutureBuilder<Pokemon>(
              future: pokemon,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final p = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.network(p.image, height: 150),

                    Text(
                      p.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    // 📊 STATS
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text("ATAQUE: ${p.attack}"),
                            Text("DEFENSA: ${p.defense}"),
                            Text("VELOCIDAD: ${p.speed}"),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: () => agregarFavorito(p),
                      icon: Icon(Icons.favorite),
                      label: Text("Favorito"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ❤️ FAVORITOS
          Container(
            height: 120,
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: favoritos.map((p) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Image.network(p.image, height: 50),
                      Text(p.name),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}