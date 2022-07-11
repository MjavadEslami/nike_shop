import 'package:nike_shop/data/banner.dart';
import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/source/banner_data_source.dart';

abstract class IBannerRepository {
  Future<List<BannerEntity>> getBanners();
}

final bannerRepository = BannerRepository(BannerRemoteDataSource(httClient));

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);

  @override
  Future<List<BannerEntity>> getBanners() {
    return dataSource.getBanners();
  }
}
