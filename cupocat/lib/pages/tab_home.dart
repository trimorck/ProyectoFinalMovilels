import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupocat/pages/page_detalle.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupocat/pages/page_ubicacion.dart';

class TabHome extends StatefulWidget {
  const TabHome({super.key});

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  List<Map<String, dynamic>> products = [];
  List<int> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    FirebaseFirestore.instance.collection('productos').get().then((querySnapshot) {
      setState(() {
        products = querySnapshot.docs.map((doc) {
          return {
            'name': doc['cafe'],
            'imageUrl': doc['imageUrl'], // Campo que representa el nombre del archivo de la imagen
            'price': (doc['precio'] as num).toInt(), // Convertir precio a int
            'descripcion': doc['descripcion'], // Asegúrate de incluir este campo en la base de datos
          };
        }).toList();
      });
    }).catchError((e) {
      print("Error al obtener productos: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.coffee,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Bienvenidos a Cup o\' Cat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        foregroundColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFF523a34),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageUbicacion()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteProducts: favoriteProducts,
                    products: products,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Carrusel de imágenes con texto superpuesto
              CarouselSlider(
                items: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/Las-mejores-obras-de-arte-de-cafe-en-Instagram.jpg', // Cambié la URL por la ruta local
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '¡Disfruta el mejor café!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Nuestros Productos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              if (products.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 200,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navegar a la página de detalles del café
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageDetalle(
                                name: products[index]['name'],
                                imageUrl: products[index]['imageUrl'],
                                price: products[index]['price'],
                                description: products[index]['descripcion'], // Asegúrate de tener este campo
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            color: Color(0xFFF5F5DC),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    'assets/${products[index]['imageUrl']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  left: 8,
                                  bottom: 8,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index]['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '\$ ${products[index]['price']} ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      favoriteProducts.contains(index)
                                          ? Icons.favorite
                                          : Icons.favorite_outline,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (favoriteProducts.contains(index)) {
                                          favoriteProducts.remove(index);
                                        } else {
                                          favoriteProducts.add(index);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<int> favoriteProducts;
  final List<Map<String, dynamic>> products;

  const FavoritesScreen({super.key, required this.favoriteProducts, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Favoritos'),
        backgroundColor: Color(0xFF523a34),
      ),
      body: ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final productIndex = favoriteProducts[index];
          return ListTile(
            leading: Image.asset('assets/${products[productIndex]['imageUrl']}', width: 50, height: 50, fit: BoxFit.cover),
            title: Text(products[productIndex]['name']),
            subtitle: Text('\$ ${products[productIndex]['price']}'),
            trailing: Icon(Icons.favorite, color: Colors.red),
          );
        },
      ),
    );
  }
}
