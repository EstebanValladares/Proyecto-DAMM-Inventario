import 'package:flutter/material.dart';

class PantallaCotizacion extends StatefulWidget {
  final List<Map<String, String>> productosCotizados;

  const PantallaCotizacion({Key? key, required this.productosCotizados}) : super(key: key);

  @override
  _PantallaCotizacionEstado createState() => _PantallaCotizacionEstado();
}

class _PantallaCotizacionEstado extends State<PantallaCotizacion> {
  @override
  Widget build(BuildContext context) {
    double totalPrecio = widget.productosCotizados.fold(
      0.0,
      (total, producto) => total + double.parse(producto['precio']!),
    );

    void eliminarProducto(int index) {
      setState(() {
        widget.productosCotizados.removeAt(index);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotización'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Productos Cotizando: ${widget.productosCotizados.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.productosCotizados.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Image.asset(widget.productosCotizados[index]['imagen']!),
                      title: Text(
                        widget.productosCotizados[index]['nombre']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      subtitle: Text(
                        '\$${widget.productosCotizados[index]['precio']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => eliminarProducto(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: \$${totalPrecio.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
