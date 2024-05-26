import 'package:flutter/material.dart';

class PantallaDetallesProducto extends StatelessWidget {
  const PantallaDetallesProducto({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> producto = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(producto['nombre']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: SizedBox(
                height: 180, // Ajusta la altura de la imagen aquí
                child: Image.asset(
                  producto['imagen']!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              producto['nombre']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${producto['precio']}',
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              producto['descripcion']!,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, producto);
                },
                child: const Text('Cotizar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
