class Product {
  String name;
  double price;
  int qty = 1;
  int quantity;
  List imageUrl;
  String doumentId;
  String suppId;
  Product({
    required this.name,
    required this.price,
    required this.qty,
    required this.quantity,
    required this.imageUrl,
    required this.doumentId,
    required this.suppId,
  });
  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}
