import 'package:flutter/material.dart';
import '../data/codigos_repository.dart';
import '../models/codigo_postal.dart';
import '../widgets/resultado_card.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  Map<String, List<CodigoPostal>>? _grouped;
  bool _loading = true;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final grouped = await CodigosRepository.groupByFreguesia();
    setState(() {
      _grouped = grouped;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Completa'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Filtrar por morada ou código...',
                      prefixIcon: Icon(Icons.filter_list),
                    ),
                    onChanged: (v) => setState(() => _filter = v.trim().toLowerCase()),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: _grouped!.entries.map((entry) {
                      final freguesia = entry.key;
                      var items = entry.value;

                      if (_filter.isNotEmpty) {
                        items = items
                            .where((c) =>
                                c.morada.toLowerCase().contains(_filter) ||
                                c.codigoPostal.toLowerCase().contains(_filter))
                            .toList();
                      }

                      if (items.isEmpty) return const SizedBox.shrink();

                      return ExpansionTile(
                        initiallyExpanded: true,
                        title: Text(
                          freguesia,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${items.length} moradas'),
                        children: items
                            .map((c) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  child: ResultadoCard(codigo: c),
                                ))
                            .toList(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
