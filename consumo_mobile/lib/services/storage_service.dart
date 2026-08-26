import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/registro_agua.dart';

class StorageService {
  static const String chaveRegistros = 'registros_agua';

  static Future<List<RegistroAgua>> carregarRegistros() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(chaveRegistros);

    if (dados == null) {
      return [];
    }

    final List lista = jsonDecode(dados);

    return lista.map((item) => RegistroAgua.fromMap(item)).toList();
  }

  static Future<void> salvarRegistros(List<RegistroAgua> registros) async {
    final prefs = await SharedPreferences.getInstance();

    final dados = registros.map((registro) => registro.toMap()).toList();

    await prefs.setString(chaveRegistros, jsonEncode(dados));
  }
}