import 'package:flutter/material.dart';

import 'customer.dart';

/// Displays detailed information about a SampleItem.
class CustomerDetailsView extends StatelessWidget {
  const CustomerDetailsView(this.customer, {super.key});
  final Customer customer;
  static const label = TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  static const data = TextStyle(fontWeight: FontWeight.normal, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
      ),
      body: Table(
          children: [
            TableRow(children: [const Text("Name", style: label), Text(customer.name, style: data)]),
            TableRow(children: [const Text("Street", style: label), Text(customer.streetAddr, style: data)]),
            TableRow(children: [const Text("City", style: label), Text(customer.city, style: data)]),
            TableRow(children: [const Text("Country", style: label), Text(customer.country, style: data)]),
          ]
        ),
      );
  }
}
