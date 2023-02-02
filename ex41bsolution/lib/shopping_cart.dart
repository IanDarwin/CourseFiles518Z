/// A Shopping Cart implemented in dart

class OrderItem {
	OrderItem(this.name, this.price, this.quantity);
	String name;
	double price;
	int quantity;
}

class ShoppingCart {
	
	List<OrderItem> cart = [];

	void addToCart(OrderItem newItem) {
		for (OrderItem item in cart) {
			if (item == newItem) {
				item.quantity++;
				return;
			}
		}
		newItem.quantity = 1;
		cart.add(newItem);
	}
	
	bool removeFromCart(OrderItem removeItem) {
		for (OrderItem item in cart) {
			if (item == removeItem) {
				cart.remove(removeItem);
				return true;
			}
		}
		return false;
	}
	
	List<OrderItem> getOrderItems() {
		return (cart);
	}
	
	double getTotalPrice() {
		double total = 0;
		//T Iterate over the OrderItems in 'cart'; for each one, add its selling
		// price (quantity multiplied by sellable.price) into 'total'.
		//-
		for (OrderItem item in cart) {
			total += item.quantity * item.price;
		}
		//+
		return total;
	}

	int getCartSize() {
		return cart.length;
	}

	int getItemCount() {
		int n = 0;
		for (OrderItem oi in cart) {
			n += oi.quantity;
		}
		return n;
	}

	/// Imagine that there is a saveCartForLater() method that persists
	/// the user's cart into the database.
	void saveCartForLater() {
		// This would write cart contents to database
	}
}
