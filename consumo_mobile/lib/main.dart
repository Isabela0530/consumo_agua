import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const ConsumoAguaApp());
}

class ConsumoAguaApp extends StatefulWidget {
  const ConsumoAguaApp({super.key});

  @override
  State<ConsumoAguaApp> createState() => _ConsumoAguaAppState();
}

class _ConsumoAguaAppState extends State<ConsumoAguaApp> {
  bool modoEscuro = false;

  void alternarTema() {
    setState(() {
      modoEscuro = !modoEscuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AquaControl',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F9FC),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,

      home: SplashScreen(alternarTema: alternarTema, modoEscuro: modoEscuro),
    );
  }
}