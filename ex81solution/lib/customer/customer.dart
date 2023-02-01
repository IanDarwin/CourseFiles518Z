class Customer {
	int id;
	String firstName, lastName;
	String streetAddr;
	String city;
	String country;

	Customer(this.id, this.firstName, this.lastName, this.streetAddr,
	  this.city, this.country);

	@override
  toString() => "Customer $firstName $lastName of $city, $country";

	String get name => "$lastName, $firstName";
}

final customers = [
	Customer(0, "John", "Jones", "123 Main St", "Toronto", "Canada"),
	Customer(2, "Muhammed", "Martle", "123 Main St", "Riyadh", "Saudi Arabia"),
	Customer(4, "Vinit", "Mitsurania", "123 Main St", "Delhi", "India"),
	Customer(6, "Randolph", "Whittington", "123 Main St", "Derbyshire", "UK"),
];
