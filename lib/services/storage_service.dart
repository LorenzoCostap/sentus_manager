import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String clientesKey = 'clientes';
  static const String produtosKey = 'produtos';
  static const String pedidosKey = 'pedidos';

  static Future<void> salvarDados({
    required List<Map<String, dynamic>> clientes,
    required List<Map<String, dynamic>> produtos,
    required List<Map<String, dynamic>> pedidos,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      clientesKey,
      jsonEncode(clientes),
    );

    await prefs.setString(
      produtosKey,
      jsonEncode(produtos),
    );

    await prefs.setString(
      pedidosKey,
      jsonEncode(pedidos),
    );
  }

  static Future<List<Map<String, dynamic>>> carregar(
    String chave,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(chave);

    if (dados == null) {
      return [];
    }

    final lista = jsonDecode(dados);

    return List<Map<String, dynamic>>.from(
      lista,
    );
  }
}