import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrincipalPage(nombre: 'Your Name', email: 'your.email@example.com'),
    );
  }
}

Future<List<Map<String, dynamic>>> obtenerProductos({String? categoria}) async {
  try {
    final url = categoria != null && categoria != 'Todos'
        ? 'http://localhost:3000/products?categoria=$categoria'
        : 'http://localhost:3000/products';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List productos = jsonDecode(response.body);
      return productos
      .skip(45)
      .take(10)
          .map((producto) => {
                'id': producto['_id'],
                'nombre': producto['name'],
                'descripcion': producto['description'],
                'precio': producto['price'],
                'categoria': producto['category'],
                'stock': producto['stock'],
                'imagen': producto['image'],
              })
          .toList();
    } else {
      throw Exception(
          'Fallo al cargar los productos, código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al obtener los productos: $e');
    throw e;
  }
}

class PrincipalPage extends StatefulWidget {
  final String nombre;
  final String email;

  const PrincipalPage({
    super.key,
    required this.nombre,
    required this.email,
  });

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  Future<List<Map<String, dynamic>>>? productos;
  String categoriaSeleccionada = 'Todos';

  @override
  void initState() {
    super.initState();
    productos = obtenerProductos();
  }

  void cargarProductosPorCategoria(String? categoria) {
    setState(() {
      productos = obtenerProductos(categoria: categoria);
    });
  }

  void cerrarSesion() {
    Navigator.pushReplacementNamed(context, '/');
  }
  String? _selectedOption = 'Todos';
List<Map<String, dynamic>> _allProducts = [];
List<Map<String, dynamic>> _filteredProducts = [];
  
  
  final List<String> _options = [
    'Todos',
    'ACCESORIOS',
    'SHAKERS',
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> categorias = [
      'Todos',
      'Proteínas',
      'Vitaminas',
      'Accesorios'
    ];
    List<ListTile> tiles = [
      ListTile(
          title: const Text("Inicio"),
          leading: const Icon(Icons.home),
          onTap: () {
            Navigator.pop(context);
          }),
      ListTile(
          title: const Text("Cotizaciones"),
          leading: const Icon(Icons.shopping_cart),
          onTap: () {
            // navegarACotizacion(context);
          }),
      ListTile(
          title:
              const Text("Cerrar sesión", style: TextStyle(color: Colors.red)),
          leading: const Icon(Icons.logout, color: Colors.red),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Cerrar sesión'),
                    content: const Text(
                        '¿Estas seguro de que quieres cerrar sesión?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Si'),
                        onPressed: () {
                          cerrarSesion();
                        },
                      )
                    ],
                  );
                });
          }),
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
                child: Text('NutriStock',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {},
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
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
                decoration: const BoxDecoration(color: Color(0xff283673)),
              ),
              ...tiles
            ],
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
                        categoriaSeleccionada = nuevoValor ?? 'Todos';
                      });
                      cargarProductosPorCategoria(nuevoValor);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Accesorios',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent
                  ),
                ),
                DropdownButton<String>(
                  hint: Text('Selecciona una opción'),
                  value: _selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue;
                      _filteredProducts = _allProducts.where((product) {
                        return _selectedOption == 'Todos' || product['categoria'] == _selectedOption;
                      }).toList();
                    });
                  },
                  items: _options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
              future: productos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  _allProducts = snapshot.data ?? [];
                  List<Map<String, dynamic>> filteredProducts = _allProducts.where((product) {
                    return _selectedOption == 'Todos' || product['categoria'] == _selectedOption;
                  }).toList();
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return TarjetaProducto(
                        producto: filteredProducts[index],
                        agregarProductoACotizacion: (producto, cantidad) {
                          // Código para agregar el producto a la cotización...
                        },
                      );
                    },
                  );
                }
              },
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class TarjetaProducto extends StatefulWidget {
  final Map<String, dynamic> producto;
  final Function(Map<String, dynamic>, int) agregarProductoACotizacion;

  const TarjetaProducto({
    super.key,
    required this.producto,
    required this.agregarProductoACotizacion,
  });

  @override
  _TarjetaProductoState createState() => _TarjetaProductoState();
}

class _TarjetaProductoState extends State<TarjetaProducto> {
  int cantidad = 1;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetalleProductoPage(producto: widget.producto),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.producto['imagen'],
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 100);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.producto['nombre'] ?? 'Nombre no disponible',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.producto['categoria'] ?? 'Nombre no disponible',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.producto['precio'] != null
                          ? '\$${widget.producto['precio']}'
                          : 'Precio no disponible',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (cantidad > 1) {
                                cantidad--;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(cantidad.toString()),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (cantidad < widget.producto['stock']) {
                                cantidad++;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'No hay suficiente stock disponible')),
                                );
                              }
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.agregarProductoACotizacion(
                          widget.producto, cantidad);
                    },
                    child: const Text('Agregar al carrito'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetalleProductoPage extends StatelessWidget {
  final Map<String, dynamic> producto;

  const DetalleProductoPage({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto['nombre']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.network(
                producto['imagen'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              producto['nombre'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Clave de producto: ${producto['id']}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Text(
              'Stock: ${producto['stock']}',
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Text(
              'Categoría: ${producto['categoria']}',
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Text(
                  '\$${producto['precio']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              producto['descripcion'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
