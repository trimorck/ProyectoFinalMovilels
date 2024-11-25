import 'package:cupocat/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabProfile extends StatelessWidget {
  final String username;

  const TabProfile({super.key, required this.username});

  // Función para cerrar sesión
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Cierra la sesión en Firebase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Redirige a la pantalla de inicio de sesión
      );
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Perfil'),
        backgroundColor: Color(0xFF523a34),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Muestra el nombre de usuario
            Text(
              'Bienvenido, $username',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Botón para cerrar sesión con ícono
            ElevatedButton.icon(
              onPressed: () {
                _signOut(context); // Llamar a la función de cierre de sesión
              },
              icon: Icon(
                Icons.exit_to_app, // Icono de cierre de sesión
                size: 20,
                color: Colors.white,
              ),
              label: Text('Cerrar sesión', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF523a34), // Color del botón
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordes redondeados
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
