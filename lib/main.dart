import 'package:flutter/material.dart';
import 'pantalla_inicio.dart';
import 'pantalla_login.dart';
import 'pantalla_detalles_producto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriStock',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const PantallaLogin(),
        '/inicio': (context) => const PantallaInicio(),
        '/detalles_producto': (context) => const PantallaDetallesProducto(),
        '/productos_categoria': (context) => const PantallaDetallesProducto(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
