import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:galleryapp/model/image_model.dart';
import 'package:galleryapp/utils/app_colors.dart';

import '../controller/search_page.controller.dart';
import '../widget/image_widget.dart';

class FavouritePage extends ConsumerStatefulWidget {
  const FavouritePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavouritePageState();
}

class _FavouritePageState extends ConsumerState<FavouritePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchController = ref.watch(searchNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery App"),
      ),
      body: Builder(builder: (context) {
        if (searchController.favourite.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "No Item Has been added to Favourite",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.custom(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              childCount: searchController.favourite.length,
              (context, index) {
                ImageModel currentItem = searchController.favourite[index];

                return ImageWidget(currentItem: currentItem);
              },
            ),
          ),
        );
      }),
    );
  }
}
