import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/search_page.controller.dart';
import '../model/image_model.dart';
import '../utils/app_colors.dart';
import '../utils/helper.dart';

class ImageWidget extends ConsumerStatefulWidget {
  const ImageWidget({
    super.key,
    required this.currentItem,
  });
  final ImageModel currentItem;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends ConsumerState<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    final searchController = ref.watch(searchNotifier);

    return GestureDetector(
      onTap: () {
        searchController.handleSave(widget.currentItem, context);
      },
      child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.currentItem.largeImageURL,
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
                                      borderRadius:
                                          BorderRadius.circular(15))))),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 138, 136, 136),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Builder(builder: (context) {
                      int index = searchController.favourite.indexWhere(
                          (element) => widget.currentItem.id == element.id);

                      return Icon(
                        index != -1 ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.primary,
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 30,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: widget.currentItem.userImageURL,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "By : ${widget.currentItem.user}",
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromARGB(95, 68, 68, 68)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    keyValue(Icons.remove_red_eye,
                        "${commaSeperated(widget.currentItem.views)}"),
                    keyValue(Icons.download,
                        "${commaSeperated(widget.currentItem.downloads)}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    keyValue(Icons.thumb_up_alt,
                        "${commaSeperated(widget.currentItem.likes)}"),
                    keyValue(Icons.comment,
                        "${commaSeperated(widget.currentItem.comments)}"),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    const Text(
                      "Tags : ",
                      style: TextStyle(fontSize: 14, color: AppColors.primary),
                    ),
                    ...widget.currentItem.tags
                        .split(",")
                        .map((e) => Text(
                              e,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(96, 104, 104, 104)),
                            ))
                        .toList()
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ).animate().scale(
          duration: 200.ms,
        );
  }
}

Padding keyValue(icon, title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
        const SizedBox(width: 3),
        Text(
          "$title",
          style: const TextStyle(fontSize: 12, color: Colors.black38),
        ),
      ],
    ),
  );
}
