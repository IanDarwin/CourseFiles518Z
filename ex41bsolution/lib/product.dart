/// Represents one item that a customer can purchase
/// IRL would have more fields, e.g., SKU, primary key, supplier, ...
class Product {
  Product(this.name, this.price);
  String name;
  double price;
}