/// A Shopping Cart implemented in dart

class Product {
	Product(this.name, this.price);
	String name;
	double price;
}

class ShoppingCart {
	
	final Map<Product,int> cart = {};

	void addToCart(Product product) {
		cart.putIfAbsent(product, () => 0);
		var n = cart[product] + 1;
		cart.update(product, (x) => n);
	}
	
	bool removeFromCart(Product removeItem) {
		if (!cart.containsKey(removeItem)) {
			print("WARNING: removing non-present item");
			return false;
		}
		return cart.remove(removeItem) > 0;
	}
	
	List<Product> getOrderItems() {
		return cart.keys.toList(growable: false);
	}
	
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
		return cart.length;
	}

	int getItemCount() {
		int n = 0;
		for (Product oi in cart.keys) {
			n += cart[oi];
		}
		return n;
	}

	/// Imagine that there is a saveCartForLater() method that persists
	/// the user's cart into the database.
	void saveCartForLater() {
		// This would write cart contents to database
	}
}
