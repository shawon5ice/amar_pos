import 'package:flutter/material.dart';

class PagerListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final Future<void> Function(int nextPage) onNewLoad;
  final bool isLoading;
  final bool hasError;
  final int totalPage;
  final int totalSize;
  final int itemPerPage;

  const PagerListView({
    required this.items,
    required this.itemBuilder,
    required this.onNewLoad,
    required this.isLoading,
    required this.hasError,
    required this.totalPage,
    required this.totalSize,
    required this.itemPerPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length + 1,
            // Add one for the pagination/loading/error widget
            itemBuilder: (context, index) {
              if (index < items.length) {
                // Build item
                return itemBuilder(context, items[index]);
              } else {
                // Handle pagination/loading/error
                if (isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }
            },
          ),
        ),
        if(hasError)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Trigger retry
                  int nextPage = (items.length ~/ itemPerPage) + 1;
                  await onNewLoad(nextPage);
                },
                child: const Text('Retry'),
              ),
            ),
          ),
      ],
    );
  }
}
