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
      theme: ThemeData(primarySwatch: Colors.blue),
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

  // Función para pedir datos a Spring Boot
  Future<void> fetchGastos() async {
    try {
      // Si se usa emulador Android, sería 'http://10.0.2.2:8080/api/gastos'
      final response = await http.get(Uri.parse('http://localhost:8080/api/gastos'));

      if (response.statusCode == 200) {
        setState(() {
          gastos = json.decode(response.body); // Convertir JSON a Lista
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar gastos');
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💸 Mis Gastos')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Cargando...
          : gastos.isEmpty
              ? const Center(child: Text('No hay gastos registrados'))
              : ListView.builder(
                  itemCount: gastos.length,
                  itemBuilder: (context, index) {
                    final gasto = gastos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: const Icon(Icons.monetization_on, color: Colors.green),
                        title: Text(gasto['concepto'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(gasto['categoria'] ?? 'Varios'),
                        trailing: Text(
                          '-${gasto['cantidad']}€',
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchGastos, // Botón para recargar
        child: const Icon(Icons.refresh),
      ),
    );
  }
}