import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formfield = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  Future<void> saveToServer( 
      String nombre, String email, String password) async { //funcion asincrona que recibe tres parametros de tipo String
    // var url = Uri.parse('http://192.168.1.79:3000/register');
    var url = Uri.parse('http://localhost:3000/register'); // Cambia esto a la URL de tu endpoint de registro
    try {
      var response = await http.post( //variable de tipo http.Response que realiza una peticion POST
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode( //codifica el json
            {'nombre': nombre, 'email': email, 'password': password}), //parametros que se envian al servidor
      );

      if (response.statusCode == 200) { //si el estado de la respuesta es 200
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito')),
        );
      } else if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog( 
            title: const Text('Error'),
            content: const Text('El correo electrónico ya está en uso'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print(
            'Error al registrar el usuario: ${response.statusCode} ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar el usuario')),
        );
      }
    } catch (e) {
      print('Error de red: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de red')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Registro",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xff283673),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundColor: Color(0xff283673),
                  backgroundImage: AssetImage("assets/logo.jpeg"),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formfield,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        controller: nombreController,
                        decoration: const InputDecoration(
                          labelText: "Nombre de usuario",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese un nombre';
                          }
                          bool nameValid =
                              RegExp(r'^[a-zA-Z ]+$').hasMatch(value); //expresion regular para validar el nombre
                          if (!nameValid) {
                            return 'Ingrese un nombre valido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Correo",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese un correo';
                          }
                          bool emailValid =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value);
                          if (!emailValid) {
                            return 'Ingrese un correo valido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passController,
                          decoration: const InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese una contraseña';
                            }
                            if (value.length < 8) {
                              return 'La contraseña debe tener al menos 8 caracteres';
                            }
                            return null;
                          }),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          if (_formfield.currentState!.validate()) { //si el formulario es valido
                            print('success');
                            saveToServer( //llama a la funcion saveToServer
                              nombreController.text, //parametros que recibe la funcion
                              emailController.text,
                              passController.text,
                            );
                            nombreController.clear(); //limpia los campos de texto
                            emailController.clear();
                            passController.clear();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xff283673),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Registrarse",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
