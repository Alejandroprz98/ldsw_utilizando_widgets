import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  void register() async {

    try {

      await auth.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario registrado correctamente")),
      );

      Navigator.pop(context);

    } catch (e) {

      String mensaje = "Error al registrar usuario";

      if (e.toString().contains("email-already-in-use")) {
        mensaje = "Este correo ya está registrado";
      } else if (e.toString().contains("weak-password")) {
        mensaje = "La contraseña es muy débil (mínimo 6 caracteres)";
      } else if (e.toString().contains("invalid-email")) {
        mensaje = "El correo no es válido";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Correo",
              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Contraseña",
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: register,
              child: Text("Crear cuenta"),
            )
          ],
        ),
      ),
    );
  }
}