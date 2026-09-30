import 'package:flutter/material.dart';
import '../data/codigos_repository.dart';
import '../models/codigo_postal.dart';
import '../widgets/resultado_card.dart';

class SearchMoradaScreen extends StatefulWidget {
  const SearchMoradaScreen({super.key});

  @override
  State<SearchMoradaScreen> createState() => _SearchMoradaScreenState();
}

class _SearchMoradaScreenState extends State<SearchMoradaScreen> {
  final _controller = TextEditingController();
  List<CodigoPostal> _results = [];
  bool _searched = false;
  bool _loading = false;

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final results = await CodigosRepository.searchByMorada(query);
    setState(() {
      _results = results;
      _searched = true;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar por Morada'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ex: Rua da Igreja, Travessa...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _results = [];
                            _searched = false;
                          });
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              onChanged: (v) {
                setState(() {});
                if (v.trim().length >= 2) {
                  _search(v);
                } else if (v.isEmpty) {
                  setState(() {
                    _results = [];
                    _searched = false;
                  });
                }
              },
              onSubmitted: _search,
            ),
          ),
          if (_loading)
            const LinearProgressIndicator()
          else if (_searched)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_results.length} resultado(s)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          Expanded(
            child: _results.isEmpty && _searched
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Nenhuma morada encontrada'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      return ResultadoCard(codigo: _results[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
