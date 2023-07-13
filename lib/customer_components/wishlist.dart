import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wishlist_model.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appBar_widgets.dart';

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
                        contentText: 'you want to clear wishlist ?',
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
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
            return WishlistModel(product: product);
          });
    });
  }
}
