import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/comment_repository.dart';
import 'package:nike_shop/ui/product/comments/bloc/commentslistbloc_bloc.dart';
import 'package:nike_shop/ui/widgets/error.dart';
import 'package:nike_shop/ui/widgets/loading.dart';

class CommentsList extends StatelessWidget {
  final ProductEntity product;
  const CommentsList({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CommentsListBloc bloc = CommentsListBloc(
            commnetRepository: commentRepository, productId: product.id);
        bloc.add(CommnetsListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentsListBloc, CommentsListState>(
          builder: (context, state) {
        if (state is CommentsListSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Column(
                children: [
                  CommentItem(
                    comment: state.comments[index],
                  ),
                ],
              );
            }, childCount: state.comments.length),
          );
        } else if (state is CommentsListLoading) {
          return const SliverToBoxAdapter(
            child: AppLoadingWidget(),
          );
        } else if (state is CommentsListError) {
          return SliverToBoxAdapter(
            child: AppErrorWidget(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<CommentsListBloc>(context)
                      .add(CommnetsListStarted());
                }),
          );
        } else {
          throw Exception('state not suported !');
        }
      }),
    );
  }
}

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.title),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    comment.email,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Text(comment.date, style: Theme.of(context).textTheme.caption)
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Text(comment.content)
        ],
      ),
    );
  }
}
