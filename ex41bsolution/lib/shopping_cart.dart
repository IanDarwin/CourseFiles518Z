import 'package:ex41bsolution/product.dart';

/// A Shopping Cart implemented in dart
/// @author Ian Darwin
class ShoppingCart {
	
	final Map<Product,int> cart = {};

	/// Either add the item to the cart or, if it is
	/// already present, increment its quantity
	void addToCart(Product product) {
		//T Implement this method
		//-
		cart.putIfAbsent(product, () => 0);
		var n = cart[product] + 1;
		cart.update(product, (x) => n);
		//+
	}

	/// Remove the product from the cart, regardless of its quantity
	/// Warn if trying to remove a product that isn't present
	bool removeFromCart(Product removeItem) {
		//T Implement this method
		//-
		if (!cart.containsKey(removeItem)) {
			print("WARNING: removing non-present item");
			return false;
		}
		return cart.remove(removeItem) > 0;
		//+
	}
	
	List<Product> getOrderItems() {
		return cart.keys.toList(growable: false);
	}

	/// Return the total price of all items in the cart, taking
	/// into account that some may have quantity > 1
	double getTotalPrice() {
		double total = 0;
		//T Iterate over the OrderItems in 'cart'; for each one, add its selling
		// price (quantity multiplied by sellable.price) into 'total'.
		//-
		for (Product item in cart.keys) {
			total += cart[item] * item.price;
		}
		//+
		return total;
	}

	int getCartSize() {
		//T Return the number of distinct products
		//R return 0
		//-
		return cart.length;
		//+
	}

	int getItemCount() {
		//T Return the total number of products in cart
		//R return 0
		//-
		int n = 0;
		for (Product oi in cart.keys) {
			n += cart[oi];
		}
		return n;
		//+
	}

	/// Reset the cart if the user checks out and wants to continue shopping
	void resetAfterCheckout() {
		cart.clear();
	}
}
