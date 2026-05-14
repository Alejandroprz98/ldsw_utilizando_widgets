import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  void login() async {
    try {

      final user = await auth.login(
        emailController.text,
        passwordController.text,
      );

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      final role = doc['role'];

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(isAdmin: true),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(isAdmin: false),
          ),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al iniciar sesión")),
      );
    }
  }

  // 🔥 BOTÓN LIMPIAR / VOLVER A INICIO
  void resetLogin() {
    emailController.clear();
    passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Campos limpiados")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio de sesión"),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            SizedBox(height: 30),

            Text(
              "🎬 Bienvenido a Movie Catalog",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Correo",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: login,
              child: Text("Ingresar"),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterScreen(),
                  ),
                );
              },
              child: Text("Registrarse"),
            ),

            // 🔥 BOTÓN NUEVO
            TextButton(
              onPressed: resetLogin,
              child: Text(
                "Volver / Limpiar",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}