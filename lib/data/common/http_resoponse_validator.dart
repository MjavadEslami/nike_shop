import 'package:dio/dio.dart';
import 'package:nike_shop/common/exception.dart';

mixin HttpResponseValidtor {
  validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException(message: response.data['message']);
    }
  }
}
