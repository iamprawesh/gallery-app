import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galleryapp/model/image_model.dart';

import '../utils/api_response.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';

final searchNotifier = ChangeNotifierProvider<SearchController>((ref) {
  return SearchController(ref);
});

class SearchController extends ChangeNotifier {
  List<ImageModel> searchImages = [];
  List<ImageModel> favourite = [];

  bool loadMore = false;
  final Ref ref;
  SearchController(this.ref);
  ApiResponse apiResponse = ApiResponse.initial("Empty data");

  fetchData({
    bool isRefresh = false,
    currentPage = 1,
    query = "flowers",
  }) async {
    try {
      if (isRefresh) {
        apiResponse = ApiResponse.loading("");
        searchImages.clear();
      }
      loadMore = true;
      notifyListeners();
      final dio = Dio();
      var url_ = apiUrl;
      url_ += "&q=$query&per_page=10&page=$currentPage";
      String url = Uri.encodeFull(url_);

      var response = await dio.get(url).timeout(const Duration(seconds: 10));
      ImageResponse data = ImageResponse.fromJson(response.data);
      searchImages.addAll(data.hits);
      apiResponse = ApiResponse.completed("");
    } finally {
      notifyListeners();
    }
  }

  handleSave(ImageModel item, context) {
    int index = favourite.indexWhere((element) => item.id == element.id);
    if (index == -1) {
      favourite.add(item);
      createSnackBar(
          "Item has been added to favourite", context, AppColors.primary);
    } else {
      showAlertDialog(context,
          message: "Are you sure want to remove from favourite ?", onYes: () {
        createSnackBar("Item has been added removed to favourite", context,
            AppColors.black);

        favourite.removeWhere((element) => item.id == element.id);
        notifyListeners();

        Navigator.pop(context);
      }, buttonAcceptTitle: "Yes", buttonCancelTitle: "No");
    }
    notifyListeners();
  }
}
