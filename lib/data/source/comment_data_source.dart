import 'package:dio/dio.dart';
import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/common/http_resoponse_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll(int productId);
}

class CommentRemoteDataSource
    with HttpResponseValidtor
    implements ICommentDataSource {
  final Dio httpCilent;

  CommentRemoteDataSource(this.httpCilent);

  @override
  Future<List<CommentEntity>> getAll(int productId) async {
    final response = await httpCilent.get('comment/list?product_id=$productId');
    validateResponse(response);

    final List<CommentEntity> comments = [];
    for (var element in (response.data as List)) {
      comments.add(CommentEntity.fromJson(element));
    }
    return comments;
  }
}
