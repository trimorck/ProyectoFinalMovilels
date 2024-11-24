import 'package:cupocat/pages/tab_home.dart';
import 'package:cupocat/pages/tab_profile.dart';
import 'package:cupocat/pages/tab_search.dart';
import 'package:flutter/material.dart';

class PageTabs extends StatefulWidget {
  final String username; // Agregar el parámetro username

  const PageTabs({super.key, required this.username}); // Recibir el username en el constructor

  @override
  State<PageTabs> createState() => _PageTabsState();
}

class _PageTabsState extends State<PageTabs> {
  int _currentIndex = 0;

  // Aquí hemos eliminado la referencia a la pestaña de favoritos (TabLikes)
  List<Map<String, dynamic>> _paginas = [];

  @override
  void initState() {
    super.initState();
    // Inicializamos las páginas, incluyendo TabProfile con el username recibido
    _paginas = [
      {'pagina': const TabHome(), 'texto': 'Inicio', 'icono': Icons.home},
      {'pagina': const TabSearch(), 'texto': 'Búsqueda', 'icono': Icons.search},
      {'pagina': TabProfile(username: widget.username), 'texto': 'Perfil', 'icono': Icons.person},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[_currentIndex]['pagina'],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: const Color(0xFF523a34),
            icon: Icon(_paginas[0]['icono']),
            label: _paginas[0]['texto'],
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color(0xFF523a34),
            icon: Icon(_paginas[1]['icono']),
            label: _paginas[1]['texto'],
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color(0xFF523a34),
            icon: Icon(_paginas[2]['icono']),
            label: _paginas[2]['texto'],
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
