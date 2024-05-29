/* import 'package:flutter/material.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({Key? key}) : super(key: key);

  @override
  _PantallaLoginEstado createState() => _PantallaLoginEstado();
}

class _PantallaLoginEstado extends State<PantallaLogin> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  void _iniciarSesion() {
    String usuario = _usuarioController.text;
    String contrasena = _contrasenaController.text;

    if (usuario.isNotEmpty && contrasena.isNotEmpty) {
      Navigator.pushReplacementNamed(
        context,
        '/inicio',
        arguments: usuario,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Fondo negro
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Bienvenido a NutriStock',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/logo_nutristock.png', // Ruta del logo
                  height: 300,
                  width: 300,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                  ),
                  style: const TextStyle(color: Colors.blueAccent),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _contrasenaController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.blueAccent),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _iniciarSesion,
                  child: const Text('Iniciar Sesión'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */