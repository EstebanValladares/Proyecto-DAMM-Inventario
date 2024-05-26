import 'package:flutter/material.dart';

class PantallaProductosCategoria extends StatelessWidget {
  const PantallaProductosCategoria({super.key});

  @override
  Widget build(BuildContext context) {
    final String categoria = ModalRoute.of(context)!.settings.arguments as String;

    final List<Map<String, String>> productos = [
      {
        'nombre': 'Proteína Whey',
        'precio': '949.90',
        'imagen': 'assets/proteina.png',
        'categoria': 'Proteínas',
        'descripcion': 'Proteína de suero de alta calidad para el crecimiento muscular.',
      },
      {
        'nombre': 'Vitamina C',
        'precio': '335.93',
        'imagen': 'assets/vitamina_c.jpg',
        'categoria': 'Vitaminas y Minerales',
        'descripcion': 'Vitamina C para fortalecer el sistema inmunológico.',
      },
      {
        'nombre': 'Báscula de Alimentos',
        'precio': '799.90',
        'imagen': 'assets/bascula.jpg',
        'categoria': 'Accesorios',
        'descripcion': 'Alta presión garantizada   • Baterías: 3 x 15v AAA  • Capacidad: 2 g – 5000 g',
      },
      {
        'nombre': 'Creatina',
        'precio': '599.90',
        'imagen': 'assets/creatina.jpg',
        'categoria': 'Proteínas',
        'descripcion': 'Creatina monohidratada para mejorar el rendimiento deportivo.',
      },
      // Agrega más productos según sea necesario
    ];

    final productosFiltrados = productos.where((producto) => producto['categoria'] == categoria || categoria == 'Todos').toList();

    void navegarADetallesProducto(BuildContext context, Map<String, String> producto) {
      Navigator.pushNamed(
        context,
        '/detalles_producto',
        arguments: producto,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: productosFiltrados.length,
          itemBuilder: (context, indice) {
            return InkWell(
              onTap: () => navegarADetallesProducto(context, productosFiltrados[indice]),
              child: TarjetaProducto(producto: productosFiltrados[indice]),
            );
          },
        ),
      ),
    );
  }
}

class TarjetaProducto extends StatelessWidget {
  final Map<String, String> producto;

  const TarjetaProducto({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            producto['imagen']!,
            fit: BoxFit.cover,
            height: 180,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              producto['nombre']!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\$${producto['precio']}',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
