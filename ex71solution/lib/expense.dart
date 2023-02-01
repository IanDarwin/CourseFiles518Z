class Expense {
  int? id;
  final String description;
  final String location;
  final double amount;
  final DateTime date;

  Expense(this.date, this.description, this.location, this.amount);

  /// Required method name may be ill-advised as it returns a true Map, NOT
  /// a JSON string nor a JsonObject-like thing, as the name implies.
  /// But, this is how things are done in Flutter-land.
  Map<String, dynamic> toJson() => {
    // Date is send is Unix time_t format, for compat. with old server impl
    // XXX Should change server to accept ISO format yyyy-dd-mm[THH:MM:SS]
    // 'expenseDate': date.toString().substring(0, 10),
    'expenseDate': date.millisecondsSinceEpoch/1000,
    'description': description,
    //T Add two missing fields here
    //-
    'location': location,
    'amount': amount.toString(),
    //+
  };

  String toJsonString() {
    return toJson().toString();
  }

  /// Here's what it should be called:
  Map<String, dynamic> toMap() => toJson();

  static Expense fromJson(Map map) => Expense(
    DateTime.fromMillisecondsSinceEpoch(map['expenseDate'] * 1000),
    map['description'],
    //T Add two fields here
    //-
    map['location'],
    map['amount'],
    //+
  );

  Expense fromMap(map) => Expense.fromJson(map);

  @override
  String toString() {
    return "Expense on ${date} for ${description} at ${location} for ${amount}";
  }

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
