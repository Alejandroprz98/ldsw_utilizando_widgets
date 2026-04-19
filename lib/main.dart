import 'package:flutter/material.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil',
      home: PerfilScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [

          // HEADER
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

          // STACK (imagen con etiqueta)
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 150,
                height: 150,
                color: Colors.grey,
              ),
              Container(
                width: 150,
                color: Colors.black54,
                padding: EdgeInsets.all(5),
                child: Text(
                  'Foto',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // INFO (COLUMN)
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📍 Guadalajara'),
                Text('📧 correo@email.com'),
                Text('📱 333-456-7890'),
              ],
            ),
          ),

          SizedBox(height: 20),

          // BOTONES (ROW)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.call, color: Colors.green, size: 30),
              Icon(Icons.message, color: Colors.blue, size: 30),
              Icon(Icons.share, color: Colors.orange, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}