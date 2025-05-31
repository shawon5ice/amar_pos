import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/app_colors.dart';

typedef PagerWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class PagerListView<T> extends StatelessWidget {
  final PagerWidgetBuilder<T> itemBuilder;
  final List<T> items;
  final bool isLoading;
  final bool hasError;
  final _scrollController = ScrollController();
  final Function(int) onNewLoad;
  final int totalPage;
  final int totalSize;
  final int itemPerPage;

  PagerListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.isLoading,
    required this.hasError,
    required this.onNewLoad,
    required this.totalPage,
    required this.totalSize,
    required this.itemPerPage,
  });

  int currentPage = 0;
  int _loadedItems = 0;

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (isLoading || totalPage == 1 || totalSize <= itemPerPage) return;

      if (_scrollController.position.atEdge && _scrollController.position.pixels > 0) {
        int newLength = totalSize % itemPerPage == 0 ? (totalSize - 1) - items.length : totalSize - items.length;
        if (newLength > itemPerPage) {
          int nextPage = totalPage - (newLength / itemPerPage).floor();
          onNewLoad(nextPage);
        } else {
          if (newLength <= 0) return;
          onNewLoad(totalPage);
        }
      }
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          flex: 1,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            key: const PageStorageKey<String>('dashboard'),
            controller: _scrollController,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return itemBuilder(context, items[index]);
            },
          ),
        ),
        if (isLoading)
          Container(
            // color: Colors.white,
            height: 68,
            width: double.infinity,
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FieldTitle(
                    "Loading",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  SpinKitRipple(
                    color: AppColors.primary,
                    size: 50,
                    duration: Duration(milliseconds: 1500),
                    borderWidth: 3,
                  ),
                ],
              ),
            ),
          ),
        if (hasError)
          Container(
            // color: Colors.white,
            height: 68,
            width: double.infinity,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  onNewLoad(currentPage);
                },
                child: const Text("Retry"),
              ),
            ),
          )
      ],
    );
  }
}