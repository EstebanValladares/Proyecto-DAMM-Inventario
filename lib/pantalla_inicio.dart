import 'package:flutter/material.dart';
import 'pantalla_cotizacion.dart';

class PantallaInicio extends StatefulWidget {
  final String nombre;  //variables que recibe del login
  final String email;

  const PantallaInicio({
    super.key, 
    required this.nombre,
    required this.email});


  @override
  _PantallaInicioEstado createState() => _PantallaInicioEstado();
}

class _PantallaInicioEstado extends State<PantallaInicio> {
  String categoriaSeleccionada = 'Todos';
  final List<String> categorias = const [
    'Todos',
    'Proteínas',
    'Vitaminas',
    'Accesorios'
  ];
  final List<Map<String, String>> productos = const [
    {
      'nombre': 'Proteína Whey',
      'precio': '949.90',
      'imagen': 'assets/proteina.png',
      'categoria': 'Proteínas',
      'descripcion':
          'Proteína de suero de alta calidad para el crecimiento muscular.',
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
      'descripcion':
          'Alta presión garantizada   • Baterías: 3 x 15v AAA  • Capacidad: 2 g – 5000 g',
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

  void navegarADetallesProducto(
      BuildContext context, Map<String, String> producto) async {
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
        builder: (context) =>
            PantallaCotizacion(productosCotizados: productosCotizados),
      ),
    );
  }

  void cerrarSesion() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    // final String usuario = ModalRoute.of(context)!.settings.arguments as String;
    List<ListTile> tiles = [
      ListTile(
        title: const Text("Inicio"),
        leading: const Icon(Icons.home),
        onTap: () {
          Navigator.pop(context);
        }
      ),
      ListTile(
        title: const Text("Cotizaciones"),
        leading: const Icon(Icons.shopping_cart),
        onTap: () {
          navegarACotizacion(context);
        }
      ),
      ListTile(
        title: const Text("Cerrar sesión"),
        leading: const Icon(Icons.logout),
        onTap: () {
          cerrarSesion();
        }
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff283673),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Expanded(
              child: Center(
                child: Text('NutriStock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () => navegarACotizacion(context),
            ),
          ],
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.nombre), 
                accountEmail: Text(widget.email),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("assets/logo.jpeg"),
                ),
                decoration: const BoxDecoration(color: Color(0xff283673)),
              ),
              ...tiles
            ]
          ),
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                    items: categorias
                        .map<DropdownMenuItem<String>>((String categoria) {
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
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.blueAccent),
                    isExpanded: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Productos',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
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
                    onTap: () =>
                        navegarADetallesProducto(context, productos[indice]),
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
    super.key,
    required this.producto,
    required this.agregarProductoACotizacion,
  });

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
