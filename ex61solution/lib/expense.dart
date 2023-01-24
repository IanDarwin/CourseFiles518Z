class Expense {
  int? id;
	final String description;
	final String location;
	final double amount;
	final DateTime date;

	Expense(this.date, this.description, this.location, this.amount);

  /// Required method name may be ill-advised as it returns a true Map, NOT
  /// a JSON string nor a JsonObject-like thing, as the name implies.
	Map<String, dynamic> toJson() => {
          'date': date.toString().substring(0, 10),
          'description': description,
          'location': location,
          'amount': amount,
	};

  /// Here's what it should be called:
  Map<String, dynamic> toMap() => toJson();

  static Expense fromJson(Map map) => Expense(
			DateTime.parse(map['date']),
			map['description'],
			map['location'],
			map['amount']);

  Expense fromMap(map) => Expense.fromJson(map);

	@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          location == other.location &&
          amount == other.amount &&
          date == other.date;

  @override
  int get hashCode =>
      description.hashCode ^
      location.hashCode ^
      amount.hashCode ^
      date.hashCode;
}
