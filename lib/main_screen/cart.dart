import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/yellow_button.dart';
import 'package:collection/collection.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: widget.back,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Cart'),
        actions: [
          context.watch<Cart>().getItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                        context: context,
                        title: 'Clear cart',
                        contentText: 'Are you sure to clear cart ?',
                        tabNo: () {
                          Navigator.pop(context);
                        },
                        tabYes: () {
                          context.read<Cart>().clearCart();
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ))
        ],
      ),
      body: context.watch<Cart>().getItems.isNotEmpty
          ? const CartItems()
          : const EmptyCart(),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Total: \$ ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  context.watch<Cart>().totalPrice.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
            YellowButton(
              btnLabel: 'CHECK OUT',
              onPressed: () {},
              width: 0.45,
            )
          ],
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your cart is Empty this time !',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.6,
                onPressed: () {
                  Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : Navigator.pushReplacementNamed(
                          context, '/customer_home');
                },
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ),
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getItems[index];
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
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        product.qty == 1
                                            ? IconButton(
                                                onPressed: () {
                                                  showCupertinoModalPopup<void>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CupertinoActionSheet(
                                                      title: const Text(
                                                          'Remove from cart'),
                                                      message: const Text(
                                                          'You are trying to delete item from cart'),
                                                      actions: <
                                                          CupertinoActionSheetAction>[
                                                        CupertinoActionSheetAction(
                                                          isDefaultAction: true,
                                                          onPressed: () {
                                                            context
                                                                .read<Cart>()
                                                                .removeItem(
                                                                    product);

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'Delete item'),
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            context
                                                                        .read<
                                                                            Wish>()
                                                                        .getWish
                                                                        .firstWhereOrNull((element) =>
                                                                            element.doumentId ==
                                                                            product
                                                                                .doumentId) !=
                                                                    null
                                                                ? context
                                                                    .read<
                                                                        Cart>()
                                                                    .removeItem(
                                                                        product)
                                                                : await context
                                                                    .read<
                                                                        Wish>()
                                                                    .addWishItems(
                                                                        product
                                                                            .name,
                                                                        product
                                                                            .price,
                                                                        1,
                                                                        product
                                                                            .quantity,
                                                                        product
                                                                            .imageUrl,
                                                                        product
                                                                            .doumentId,
                                                                        product
                                                                            .suppId);
                                                            context
                                                                .read<Cart>()
                                                                .removeItem(
                                                                    product);

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'Move to wishlist'),
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          isDestructiveAction:
                                                              true,
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.delete_forever,
                                                  size: 18,
                                                ))
                                            : IconButton(
                                                onPressed: () {
                                                  cart.decrement(product);
                                                },
                                                icon: const Icon(
                                                  FontAwesomeIcons.minus,
                                                  size: 18,
                                                )),
                                        Text(
                                          product.qty.toString(),
                                          style: product.qty == product.quantity
                                              ? const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Acme',
                                                  color: Colors.red)
                                              : const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Acme'),
                                        ),
                                        IconButton(
                                            onPressed:
                                                product.qty == product.quantity
                                                    ? null
                                                    : () {
                                                        cart.increment(product);
                                                      },
                                            icon: const Icon(
                                              FontAwesomeIcons.plus,
                                              size: 18,
                                            )),
                                      ],
                                    ),
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
