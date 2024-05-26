import 'package:flutter/material.dart';
import 'pantalla_cotizacion.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({Key? key}) : super(key: key);

  @override
  _PantallaInicioEstado createState() => _PantallaInicioEstado();
}

class _PantallaInicioEstado extends State<PantallaInicio> {
  String categoriaSeleccionada = 'Todos';
  final List<String> categorias = const ['Todos', 'Proteínas', 'Vitaminas', 'Accesorios'];
  final List<Map<String, String>> productos = const [
    {
      'nombre': 'Proteína Whey',
      'precio': '949.90',
      'imagen': 'assets/proteina.png',
      'categoria': 'Proteínas',
      'descripcion': 'Proteína de suero de alta calidad para el crecimiento muscular.',
    },
    {
      'nombre': 'Vitamina C Masticable',
      'precio': '335.93',
      'imagen': 'assets/vitamina_c.jpg',
      'categoria': 'Vitaminas',
      'descripcion': 'Este producto no es un medicamento.',
    },
    {
      'nombre': 'Báscula de Alimentos',
      'precio': '799.90',
      'imagen': 'assets/bascula.jpg',
      'categoria': 'Accesorios',
      'descripcion': 'Alta presión garantizada   • Baterías: 3 x 15v AAA  • Capacidad: 2 g – 5000 g',
    },
    {
      'nombre': 'Creatina Elemental',
      'precio': '599.90',
      'imagen': 'assets/creatina.jpg',
      'categoria': 'Proteínas',
      'descripcion': 'Este producto no es un medicamento.',
    },
  ];

  List<Map<String, String>> productosCotizados = [];

  void navegarAPantallaCategoria(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/productos_categoria',
      arguments: categoriaSeleccionada,
    );
  }

  void navegarADetallesProducto(BuildContext context, Map<String, String> producto) async {
    final resultado = await Navigator.pushNamed(
      context,
      '/detalles_producto',
      arguments: producto,
    );

    if (resultado != null && resultado is Map<String, String>) {
      agregarProductoACotizacion(resultado);
    }
  }

  void agregarProductoACotizacion(Map<String, String> producto) {
    setState(() {
      productosCotizados.add(producto);
    });
  }

  void navegarACotizacion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaCotizacion(productosCotizados: productosCotizados),
      ),
    );
  }

  void cerrarSesion() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    // final String usuario = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'logout') {
                  cerrarSesion();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Cerrar sesión'),
                ),
              ],
              child: const Row(
                  children: <Widget>[
              //     // Text(usuario),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('NutriStock'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => navegarACotizacion(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: categoriaSeleccionada,
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        categoriaSeleccionada = nuevoValor!;
                      });
                      navegarAPantallaCategoria(context);
                    },
                    items: categorias.map<DropdownMenuItem<String>>((String categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria,
                        child: Text(categoria),
                      );
                    }).toList(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                    isExpanded: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Productos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: productos.length,
                itemBuilder: (context, indice) {
                  return InkWell(
                    onTap: () => navegarADetallesProducto(context, productos[indice]),
                    child: TarjetaProducto(
                      producto: productos[indice],
                      agregarProductoACotizacion: agregarProductoACotizacion,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TarjetaProducto extends StatelessWidget {
  final Map<String, String> producto;
  final Function(Map<String, String>) agregarProductoACotizacion;

  const TarjetaProducto({
    Key? key,
    required this.producto,
    required this.agregarProductoACotizacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                producto['imagen']!,
                fit: BoxFit.cover,
                height: 100,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              producto['nombre']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              producto['descripcion']!,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '\$${producto['precio']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () => agregarProductoACotizacion(producto),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
