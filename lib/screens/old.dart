import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:galleryapp/model/image_model.dart';
import 'package:galleryapp/utils/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int page = 1;
  final List<ImageModel> _DataList = [];
  late Future<List<ImageModel>> _future;
  final ScrollController _controller = ScrollController();

  Future<List<ImageModel>> getData(int pageCount) async {
    final dio = Dio();

    String url = Uri.encodeFull(apiUrl);
    var response = await dio
        .get(
          url,
        )
        .timeout(const Duration(seconds: 10));
    ImageResponse payload = ImageResponse.fromJson(response.data);
    _DataList.insertAll(0, payload.hits);

    page++;
    return _DataList;
  }

  @override
  void initState() {
    // _future = getData(page);

    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // setState(() {
        //   _future = getData(page);
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery App"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _controller,
              child: FutureBuilder(
                  future: _future,
                  builder: (BuildContext ctx,
                      AsyncSnapshot<List<ImageModel>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: SizedBox(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Error"));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text("Error"));
                    }

                    var dataToShow = snapshot.data;
                    return MasonryGridView.custom(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                          childCount: dataToShow!.length, (context, index) {
                        ImageModel currentItem = dataToShow[index];

                        return ImageWidget(currentItem: currentItem);
                      }),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.currentItem,
  });

  final ImageModel currentItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: currentItem.largeImageURL,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Shimmer.fromColors(
                    highlightColor: Colors.grey[100]!,
                    baseColor: Colors.grey[300]!,
                    period: const Duration(seconds: 2),
                    child: Container(
                        height: 150,
                        decoration: ShapeDecoration(
                            color: Colors.grey[400]!,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(15))))),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.remove_red_eye, size: 18),
                  const SizedBox(width: 3),
                  Text(
                    "${currentItem.views}",
                    style: const TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: currentItem.userImageURL,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    currentItem.user,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
