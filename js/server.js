const express = require("express"); // Express es un framework de Node.js que permite crear aplicaciones web y APIs de forma sencilla
const MongoClient = require("mongodb").MongoClient; // MongoClient es una clase que permite conectarse a una base de datos de MongoDB y realizar operaciones sobre ella
const cors = require("cors"); // CORS es un middleware(intermediario entre diferentes sistemas) que permite habilitar las solicitudes HTTP entre diferentes dominios
const bodyParser = require("body-parser"); //bodyParser es un middleware que permite parsear(analizar una cadena de caracteres) el cuerpo de las peticiones HTTP

const app = express(); // Crear un servidor express
app.use(cors()); // Habilitar CORS para todas las rutas
app.use(bodyParser.json()); // Habilitar el parseo de JSON para el body

const uri =
  "mongodb+srv://alejandrodeveloper417:ccwh0XVcnzfphfT3@nutristock.fpenfkp.mongodb.net/nutristock"; // URI de conexión a la base de datos

const client = new MongoClient(uri); // Crear un cliente de MongoDB

//Estados de respuesta http
//200: La solicitud ha tenido éxito. El servidor ha respondido con el recurso solicitado.
//201: La solicitud ha sido exitosa y como resultado se ha creado un nuevo recurso.
//400: El servidor no puede o no procesará la solicitud debido a un error del cliente (por ejemplo, sintaxis de solicitud malformada).
//401: La solicitud no ha sido aplicada porque carece de credenciales de autenticación válidas para el recurso solicitado.
//500: El servidor encontró una condición inesperada que le impidió cumplir con la solicitud.

app.get("/data", async (req, res) => {
  // Ruta para obtener los datos de la base de datos
  try {
    await client.connect(); // Conectar al cliente
    const collection = client.db("users").collection("workers"); // Seleccionar la colección de la base de datos
    const data = await collection.find({}).toArray(); // Obtener todos los documentos de la colección y convertirlos a un array
    console.log(data); // Mostrar los datos en la consola
    res.json(data); // Enviar los datos como respuesta
  } catch (err) {
    // Manejar errores
    console.error(err);
    res.status(500).send("Error connecting to database");
  } finally {
    await client.close(); // Cerrar la conexión a la base de datos
  }
});

app.post("/login", async (req, res) => {
  // Ruta para autenticar a un usuario
  const { email, password } = req.body; // Obtener el correo electrónico y la contraseña del cuerpo de la petición

  try {
    // Intentar realizar la operación
    await client.connect(); // Conectar al cliente
    const collection = client.db("users").collection("workers"); // Seleccionar la colección de la base de datos
    const user = await collection.findOne({ email, password }); // Buscar un usuario con el correo electrónico y la contraseña

    if (user) {
      res.status(200).send({ authenticated: true, nombre: user.nombre }); // Enviar una respuesta con el estado de autenticación y el nombre del usuario
    } else {
      res.status(401).send({ authenticated: false }); // Enviar una respuesta con el estado de autenticación
    }
  } catch (err) {
    console.error(err);
    res.status(500).send("Error connecting to database");
  } finally {
    await client.close(); // Cerrar la conexión a la base de datos
  }
});

app.post("/register", async (req, res) => {
  // Ruta para registrar a un usuario
  const { nombre, email, password } = req.body; // Obtener el nombre, correo electrónico y contraseña del cuerpo de la petición

  try {
    await client.connect(); // Conectar al cliente
    const collection = client.db("users").collection("workers"); // Seleccionar la colección de la base de datos
    const user = await collection.findOne({ email }); // Buscar un usuario con el correo electrónico

    if (user) {
      res.status(400).send("El correo electrónico ya está en uso"); // Enviar una respuesta con un mensaje de error
    } else {
      await collection.insertOne({ nombre, email, password }); // Insertar un nuevo usuario en la colección
      res.sendStatus(200);
    }
  } catch (err) {
    console.error(err);
    res.status(500).send("Error connecting to database");
  } finally {
    await client.close();
  }
});

app.listen(3000, () => {
  console.log("Server is running on port 3000"); // Iniciar el servidor en el puerto 3000
});
