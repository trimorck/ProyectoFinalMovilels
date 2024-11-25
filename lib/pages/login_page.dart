import 'package:cupocat/pages/page_tabs.dart';
import 'package:cupocat/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      // Intentar iniciar sesión con Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Obtener el correo del usuario autenticado
      String? userEmail = userCredential.user?.email;

      // Mostrar mensaje de éxito con el correo del usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Bienvenido, ${userEmail ?? 'Usuario'}!'),
        ),
      );

      // Navegar a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageTabs(username: userEmail ?? _emailController.text),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Manejo específico de errores de Firebase Authentication
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'El formato del correo electrónico es inválido.';
          break;
        case 'user-not-found':
          errorMessage = 'No existe una cuenta con este correo.';
          break;
        case 'wrong-password':
          errorMessage = 'La contraseña es incorrecta. Intenta nuevamente.';
          break;
        default:
          errorMessage = 'Correo o contraseña incorrecta. Por favor, intenta nuevamente.';
      }

      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Manejo de cualquier otro error inesperado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Agrega el SingleChildScrollView para permitir desplazamiento
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título "Cup o'Cat" arriba de la imagen
              Text(
                'Cup o\'Cat',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Imagen redonda
              const CircleAvatar(
                radius: 130,
                backgroundImage: AssetImage('assets/af416a558f3184fca3c9582e00a580c4.jpg'),
              ),
              const SizedBox(height: 40),
              // Título "Iniciar Sesión" alineado a la izquierda
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Campo de correo electrónico
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              // Campo de contraseña
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF523a34),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 10),
              // Enlace a la pantalla de registro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
