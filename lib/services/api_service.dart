import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

Future<Pokemon> fetchPokemon() async {
  final response = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon/pikachu'),
  );

  if (response.statusCode == 200) {
    return Pokemon.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error al cargar Pokémon');
  }
}