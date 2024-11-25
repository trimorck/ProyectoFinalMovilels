import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TabSearch extends StatefulWidget {
  const TabSearch({super.key});

  @override
  State<TabSearch> createState() => _TabSearchState();
}

class _TabSearchState extends State<TabSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false; // Bandera para saber si se está buscando

  @override
  void initState() {
    super.initState();
    _fetchAllProducts(); // Cargar todos los productos al iniciar
  }

  // Función para cargar todos los productos
  Future<void> _fetchAllProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('productos').get();
      setState(() {
        searchResults = snapshot.docs.map((doc) {
          return {
            'cafe': doc['cafe'],
            'precio': doc['precio'],
            // Verificar si existe el campo imageUrl
            'imageAsset': doc.data().containsKey('imageUrl') ? doc['imageUrl'] : null,
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar productos: $e');
    }
  }

  // Función para buscar productos en Firestore
  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      // Si el campo está vacío, mostrar todos los productos
      _fetchAllProducts();
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('productos')
          .where('cafe', isGreaterThanOrEqualTo: query)
          .where('cafe', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        searchResults = snapshot.docs.map((doc) {
          return {
            'cafe': doc['cafe'],
            'precio': doc['precio'],
            // Verificar si existe el campo imageUrl
            'imageAsset': doc.data().containsKey('imageUrl') ? doc['imageUrl'] : null,
          };
        }).toList();
      });
    } catch (e) {
      print('Error al buscar productos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Productos'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF523a34),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar cafés...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) {
                _searchProducts(query); // Buscar mientras escribe
              },
            ),
          ),
          // Lista de resultados
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final product = searchResults[index];
                return ListTile(
                  leading: product['imageAsset'] != null
                      ? Image.asset(
                          'assets/${product['imageAsset']}', // Usar el nombre del archivo
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/default.png', // Imagen predeterminada
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                  title: Text(product['cafe']),
                  subtitle: Text('\$${product['precio']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
