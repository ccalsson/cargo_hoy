import 'package:flutter/material.dart';

class FilterOption {
  final String label;
  final List<String> options;

  const FilterOption({required this.label, required this.options});
}

class LoadSearchWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onSearch;
  final List<FilterOption> filters;

  const LoadSearchWidget({
    super.key,
    required this.onSearch,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar cargas',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                onSearch({'query': value});
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: filters.map((filter) {
                return FilterChip(
                  label: Text(filter.label),
                  onSelected: (selected) {
                    // TODO: Implementar filtrado
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
