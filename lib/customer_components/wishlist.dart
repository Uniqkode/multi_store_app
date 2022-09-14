import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';
import 'package:collection/collection.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({
    Key? key,
  }) : super(key: key);

  @override
  State<Wishlist> createState() => _WishListState();
}

class _WishListState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const AppBarBackButton(),
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Wishlist'),
        actions: [
          context.watch<Wish>().getWish.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                        context: context,
                        title: 'Clear Wishlist',
                        contentText: 'Are you sure to clear wishlist ?',
                        tabNo: () {
                          Navigator.pop(context);
                        },
                        tabYes: () {
                          context.read<Wish>().clearWish();
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ))
        ],
      ),
      body: context.watch<Wish>().getWish.isNotEmpty
          ? const WishItems()
          : const EmptyWishlist(),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Your Wishlist is empty this time !',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(builder: (context, wish, child) {
      return ListView.builder(
          itemCount: wish.count,
          itemBuilder: (context, index) {
            final product = wish.getWish[index];
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 120,
                        child: Image.network(
                          product.imageUrl.first,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.price.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            context
                                                .read<Wish>()
                                                .removeItem(product);
                                          },
                                          icon:
                                              const Icon(Icons.delete_forever)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      context
                                                  .watch<Cart>()
                                                  .getItems
                                                  .firstWhereOrNull((element) =>
                                                      element.doumentId ==
                                                      product.doumentId) !=
                                              null
                                          ? const SizedBox()
                                          : IconButton(
                                              onPressed: () {
                                                // context
                                                //             .read<Cart>()
                                                //             .getItems
                                                //             .firstWhereOrNull(
                                                //                 (element) =>
                                                //                     element
                                                //                         .doumentId ==
                                                //                     product
                                                //                         .doumentId) !=
                                                //         null
                                                //     ? print('already in cart')
                                                context.read<Cart>().addItems(
                                                      product.name,
                                                      product.price,
                                                      1,
                                                      product.quantity,
                                                      product.imageUrl,
                                                      product.doumentId,
                                                      product.suppId,
                                                    );
                                              },
                                              icon: const Icon(
                                                  Icons.add_shopping_cart))
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
