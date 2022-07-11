import 'package:dio/dio.dart';
import 'package:nike_shop/data/banner.dart';
import 'package:nike_shop/data/common/http_resoponse_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getBanners();
}

class BannerRemoteDataSource
    with HttpResponseValidtor
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);
  @override
  Future<List<BannerEntity>> getBanners() async {
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    final List<BannerEntity> banners = [];
    for (var element in (response.data as List)) {
      banners.add(BannerEntity.fromJson(element));
    }
    return banners;
  }
}
