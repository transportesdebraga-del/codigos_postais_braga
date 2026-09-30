import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/codigo_postal.dart';

class ResultadoCard extends StatelessWidget {
  final CodigoPostal codigo;

  const ResultadoCard({super.key, required this.codigo});

  void _copiar(BuildContext context, String texto) {
    Clipboard.setData(ClipboardData(text: texto));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copiado: $texto'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.home, size: 20),
        ),
        title: Text(
          codigo.morada,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.pin_drop, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  codigo.codigoPostal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.location_city, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    codigo.freguesia,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 20),
          tooltip: 'Copiar código postal',
          onPressed: () => _copiar(context, codigo.codigoPostal),
        ),
      ),
    );
  }
}
