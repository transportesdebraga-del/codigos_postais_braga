import 'package:flutter/material.dart';
import '../data/codigos_repository.dart';
import '../models/codigo_postal.dart';

class ValidacaoScreen extends StatefulWidget {
  const ValidacaoScreen({super.key});

  @override
  State<ValidacaoScreen> createState() => _ValidacaoScreenState();
}

class _ValidacaoScreenState extends State<ValidacaoScreen> {
  final _controller = TextEditingController();
  bool? _isValid;
  List<CodigoPostal> _matches = [];
  bool _loading = false;
  bool _checked = false;

  Future<void> _validate() async {
    final codigo = _controller.text.trim();
    if (codigo.isEmpty) return;

    setState(() {
      _loading = true;
      _checked = false;
    });

    final valid = await CodigosRepository.isValidCodigo(codigo);
    final matches = await CodigosRepository.searchByCodigo(codigo);

    setState(() {
      _isValid = valid;
      _matches = matches;
      _loading = false;
      _checked = true;
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
        title: const Text('Validar Código Postal'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Introduz um código postal para verificar se pertence a Este (São Mamede) ou Este (São Pedro):',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Código Postal',
                hintText: 'Ex: 4715-487',
                prefixIcon: Icon(Icons.pin),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _validate(),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loading ? null : _validate,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.verified),
              label: const Text('Validar'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 32),
            if (_checked) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isValid!
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isValid! ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isValid! ? Icons.check_circle : Icons.cancel,
                      size: 64,
                      color: _isValid! ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isValid!
                          ? 'Código VÁLIDO'
                          : 'Código NÃO encontrado',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isValid! ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isValid!
                          ? 'Pertence a Este (São Mamede / São Pedro) - Braga'
                          : 'Este código não está nos dados disponíveis',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isValid! ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                    if (_isValid! && _matches.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      Text(
                        '${_matches.length} morada(s) associada(s):',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ..._matches.take(5).map((c) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text('• ${c.morada} (${c.freguesia})'),
                          )),
                      if (_matches.length > 5)
                        Text('... e mais ${_matches.length - 5}'),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
