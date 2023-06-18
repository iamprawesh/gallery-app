import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:galleryapp/model/image_model.dart';

import '../controller/search_page.controller.dart';
import '../utils/api_response.dart';
import '../widget/image_widget.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  int currentPage = 1;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        currentPage++;
        ref.read(searchNotifier).fetchData(currentPage: currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchController = ref.watch(searchNotifier);
    final TextEditingController searchController0 = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: TextField(
          controller: searchController0,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
              hintText: 'Search  : eg flowers',
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
              suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  ),
                  onPressed: () {
                    ref.read(searchNotifier).fetchData(
                          isRefresh: true,
                          query: searchController0.text,
                        );
                  })),
          onChanged: (value) {
            // Perform search functionality here
          },
          onSubmitted: (cal) {
            ref.read(searchNotifier).fetchData(
                  isRefresh: true,
                  query: searchController0.text,
                );
          },
        ),
      ),
      body: Builder(builder: (context) {
        switch (searchController.apiResponse.status) {
          case Status.loading:
            return const Center(child: CircularProgressIndicator());
          case Status.complete:
            return SingleChildScrollView(
              controller: _controller,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    MasonryGridView.custom(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        childCount: searchController.searchImages.length,
                        (context, index) {
                          ImageModel currentItem =
                              searchController.searchImages[index];

                          return ImageWidget(currentItem: currentItem);
                        },
                      ),
                    ),
                    if (searchController.loadMore)
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator())
                  ],
                ),
              ),
            );
          case Status.error:
            return const Text("Error");
          default:
            return const SizedBox();
        }
      }),
    );
  }
}
