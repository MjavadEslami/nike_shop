import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/source/comment_data_source.dart';

abstract class ICommnetRepository {
  Future<List<CommentEntity>> getAll(int productId);
}

final commentRepository = CommentRepository(CommentRemoteDataSource(httClient));

class CommentRepository implements ICommnetRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);
  @override
  Future<List<CommentEntity>> getAll(int productId) =>
      dataSource.getAll(productId);
}
