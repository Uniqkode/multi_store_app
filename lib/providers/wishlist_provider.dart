import 'package:flutter/foundation.dart';
import 'package:multi_store_app/providers/product_class.dart';

class Wish extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWish {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  Future<void> addWishItems(
    String name,
    double price,
    int qty,
    int quantity,
    List imageUrl,
    String doumentId,
    String suppId,
  ) async {
    final product = Product(
        name: name,
        price: price,
        qty: qty,
        quantity: quantity,
        imageUrl: imageUrl,
        doumentId: doumentId,
        suppId: suppId);
    _list.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWish() {
    _list.clear();
    notifyListeners();
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.doumentId == id);
    notifyListeners();
  }
}
