import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/codigo_postal.dart';

class CodigosRepository {
  static List<CodigoPostal>? _cache;

  static Future<List<CodigoPostal>> loadAll() async {
    if (_cache != null) return _cache!;

    final String jsonString =
        await rootBundle.loadString('assets/codigos_postais_este.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    _cache = jsonList
        .map((item) => CodigoPostal.fromJson(item as Map<String, dynamic>))
        .toList();

    return _cache!;
  }

  /// Pesquisa por morada (parcial, case-insensitive)
  static Future<List<CodigoPostal>> searchByMorada(String query) async {
    final all = await loadAll();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    return all
        .where((c) => c.morada.toLowerCase().contains(q))
        .toList();
  }

  /// Pesquisa por código postal (parcial ou completo)
  static Future<List<CodigoPostal>> searchByCodigo(String query) async {
    final all = await loadAll();
    final q = query.trim().replaceAll(' ', '');
    if (q.isEmpty) return [];

    return all
        .where((c) => c.codigoPostal.replaceAll(' ', '').contains(q))
        .toList();
  }

  /// Valida se o código postal existe nos dados (Este - São Mamede / São Pedro)
  static Future<bool> isValidCodigo(String codigo) async {
    final all = await loadAll();
    final cleaned = codigo.trim().replaceAll(' ', '');
    return all.any((c) => c.codigoPostal.replaceAll(' ', '') == cleaned);
  }

  /// Retorna todas as freguesias únicas
  static Future<List<String>> getFreguesias() async {
    final all = await loadAll();
    return all.map((c) => c.freguesia).toSet().toList()..sort();
  }

  /// Agrupa por freguesia
  static Future<Map<String, List<CodigoPostal>>> groupByFreguesia() async {
    final all = await loadAll();
    final map = <String, List<CodigoPostal>>{};
    for (final c in all) {
      map.putIfAbsent(c.freguesia, () => []).add(c);
    }
    return map;
  }
}
