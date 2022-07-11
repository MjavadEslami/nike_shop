import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/product_repository.dart';
import 'package:nike_shop/ui/list/bloc/product_list_bloc.dart';
import 'package:nike_shop/ui/product/product.dart';
import 'package:nike_shop/ui/widgets/error.dart';
import 'package:nike_shop/ui/widgets/loading.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;

  const ProductListScreen({Key? key, required this.sort}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType {
  grid,
  list,
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش های ورزشی'),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(produtRepository)
            ..add(ProductListStarted(widget.sort));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.products;
              return Column(
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(32),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 250,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24, bottom: 24),
                                    child: Column(
                                      children: [
                                        Text(
                                          'انتخاب مرتب سازی',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: state.sortNames.length,
                                              itemBuilder: (context, index) {
                                                final int selectedSortIndex =
                                                    state.sort;
                                                return InkWell(
                                                  onTap: () {
                                                    bloc!.add(
                                                        ProductListStarted(
                                                            index));
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(16, 8, 16, 8),
                                                    child: index ==
                                                            selectedSortIndex
                                                        ? SizedBox(
                                                            height: 28,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  CupertinoIcons
                                                                      .check_mark_circled_solid,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(state
                                                                        .sortNames[
                                                                    index])
                                                              ],
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            height: 28,
                                                            child: Row(
                                                              children: [
                                                                const SizedBox(
                                                                  width: 30,
                                                                ),
                                                                Text(state
                                                                        .sortNames[
                                                                    index])
                                                              ],
                                                            ),
                                                          ),
                                                  ),
                                                );
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon:
                                          const Icon(CupertinoIcons.sort_down),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('مرتب سازی'),
                                        Text(
                                          ProductSort.names[state.sort],
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                color: Colors.black.withOpacity(0.1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      viewType = viewType == ViewType.grid
                                          ? ViewType.list
                                          : ViewType.grid;
                                    });
                                  },
                                  icon: const Icon(
                                      CupertinoIcons.square_grid_2x2),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: viewType == ViewType.grid ? 2 : 1,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                            product: product, borderRadius: BorderRadius.zero);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is ProductListLoading) {
              return const AppLoadingWidget();
            } else if (state is ProductListError) {
              return AppErrorWidget(
                  exception: state.appException, onPressed: () {});
            } else {
              throw ('state is not supprot !');
            }
          },
        ),
      ),
    );
  }
}
