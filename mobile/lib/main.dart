import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack Mobile',
      debugShowCheckedModeBanner: false, // Quita la etiqueta 'Debug' fea
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const GastosScreen(),
    );
  }
}

class GastosScreen extends StatefulWidget {
  const GastosScreen({super.key});

  @override
  State<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  List<dynamic> gastos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGastos();
  }

  // GET: Pedir gastos
  Future<void> fetchGastos() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/gastos'));
      if (response.statusCode == 200) {
        setState(() {
          gastos = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  // POST: Enviar nuevo gasto
  Future<void> addGasto(String concepto, double cantidad) async {
    final nuevoGasto = {
      "concepto": concepto,
      "cantidad": cantidad,
      "fecha": DateTime.now().toString().split(' ')[0], // Fecha hoy
      "categoria": "Móvil"
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/gastos'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(nuevoGasto),
      );

      if (response.statusCode == 200) {
        fetchGastos(); // Recargar la lista para ver el nuevo
        Navigator.of(context).pop(); // Cerrar el formulario
      }
    } catch (e) {
      print("Error enviando: $e");
    }
  }

  // Mostrar ventanita flotante (Dialog)
  void _mostrarFormulario() {
    final conceptoController = TextEditingController();
    final cantidadController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Gasto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: conceptoController,
              decoration: const InputDecoration(labelText: 'Concepto (ej: Taxi)'),
            ),
            TextField(
              controller: cantidadController,
              decoration: const InputDecoration(labelText: 'Cantidad (€)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancelar
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final concepto = conceptoController.text;
              final cantidad = double.tryParse(cantidadController.text) ?? 0.0;
              if (concepto.isNotEmpty && cantidad > 0) {
                addGasto(concepto, cantidad);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FinTrack Móvil 📱')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final gasto = gastos[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(gasto['concepto'][0].toUpperCase()),
                  ),
                  title: Text(gasto['concepto']),
                  trailing: Text(
                    '-${gasto['cantidad']}€',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario, // Al pulsar, abre el formulario
        child: const Icon(Icons.add),
      ),
    );
  }
}