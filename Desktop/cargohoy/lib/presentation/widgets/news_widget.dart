import 'package:flutter/material.dart';

class NewsWidget extends StatelessWidget {
  final bool compact;

  const NewsWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Noticias',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (!compact) const SizedBox(height: 8),
            // TODO: Implementar lista de noticias
            const Text('No hay noticias disponibles'),
          ],
        ),
      ),
    );
  }
}
