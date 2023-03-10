import 'package:ex41bsolution/product.dart';
import "package:test/test.dart";
import '../lib/shopping_cart.dart';

///  Test the logic in the given ShoppingCart
final Product product = Product("Front Row Centre Tickets", 12.98);

void main() {
  ShoppingCart cart;

  setUp(() {
    cart = ShoppingCart();
  });

  test('AddToCart', () {
    // Add 'product' to the cart, check that getOrderItems().size is 1
    expect(cart.getOrderItems().length, 0);
    cart.addToCart(product);
    expect(cart.getOrderItems().length, 1);
  });

  //T Add a test that adding then removing a product leaves 0 items
  //-
  test('RemoveFromCart', () {
    // Check that adding then removing a product leaves 0 items in cart
    cart.addToCart(product);
    cart.removeFromCart(product);
    // expect(cart.orderItems.size(), 0);
  });
  //+

  //T Add a test that, after adding the same product twice,
  // getCartSize() returns 1
  // getItemCount() returns 2
  //-
  test('GetCartSizeAndItemCount',() {
    // Add the product TWICE to the cart; ensure that now:
    // getCartSize() returns 1
    // getItemCount() returns 2
    // "Make that a pair of tickets"
    cart.addToCart(product);
    cart.addToCart(product);

    // Adding an existing object should not change cart size!
    expect(cart.getCartSize(), 1);

    // Adding an existing object should bump total quantity.
    expect(cart.getItemCount(), 2);
  });
  //+

  //T Test that adding an item twice results in
  // getTotalPrice doubling.
  //-
  test('GetTotalPrice', () {
    expect(cart.getTotalPrice(), 0.0);
    cart.addToCart(product);
    expect(product.price, cart.getTotalPrice());
    cart.addToCart(product);
    expect(2 * product.price, cart.getTotalPrice());
  });
  //+
}

