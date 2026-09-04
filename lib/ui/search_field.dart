import 'package:flutter/material.dart';

import '../core/theme/values.dart';

class SearchField extends StatefulWidget {
  const SearchField({this.hint, this.onChanged, this.onSubmitted, super.key});

  final String? hint;
  final void Function(String query)? onChanged;
  final void Function(String query)? onSubmitted;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final controller = TextEditingController();
  var clearVisible = false;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: Radiuses.r12,
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary.withAlpha(40),
      ),
    ),
    child: Padding(
      padding: const .symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: .search,
              onChanged: (query) {
                widget.onChanged?.call(query);
                if (clearVisible != query.isNotEmpty) {
                  setState(() => clearVisible = query.isNotEmpty);
                }
              },
              onSubmitted: widget.onSubmitted,
              style: const .new(fontSize: 14),
              decoration: .new(
                icon: const Icon(Icons.search_rounded, size: 18),
                hintText: widget.hint,
                border: .none,
                isDense: true,
                contentPadding: const .symmetric(vertical: 12),
              ),
            ),
          ),
          if (clearVisible)
            IconButton(
              onPressed: () {
                controller.clear();
                widget.onChanged?.call('');
                setState(() => clearVisible = false);
              },
              iconSize: 18,
              style: .new(minimumSize: .all(.zero)),
              icon: const Icon(Icons.clear_rounded),
            ),
        ],
      ),
    ),
  );
}
