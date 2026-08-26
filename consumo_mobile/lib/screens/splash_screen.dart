import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback alternarTema;
  final bool modoEscuro;

  const SplashScreen({
    super.key,
    required this.alternarTema,
    required this.modoEscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    size: 75,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'AquaControl',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(
                  'Controle seu consumo de água',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),

                const SizedBox(height: 50),

                // Tema
                OutlinedButton.icon(
                  onPressed: alternarTema,
                  icon: Icon(modoEscuro ? Icons.light_mode : Icons.dark_mode),
                  label: Text(modoEscuro ? 'Tema claro' : 'Tema escuro'),
                ),

                const SizedBox(height: 20),

                // Entrar
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    child: const Text(
                      'ENTRAR',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}