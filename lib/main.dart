import 'package:flutter/material.dart';
import 'pantalla_inicio.dart';
import 'pantalla_detalles_producto.dart';
import 'screens/login.dart';

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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/inicio':
            final args = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (_) => PantallaInicio(
                nombre: args['nombre']!,
                email: args['email']!,
              ),
            );
          default:
            throw Exception('Ruta no definida');
        }
      },
      routes: {
        '/': (context) => const Login(),        
        '/detalles_producto': (context) => const PantallaDetallesProducto(),
        '/productos_categoria': (context) => const PantallaDetallesProducto(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
