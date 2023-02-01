import 'package:flutter/material.dart';

import 'customer.dart';
import 'customer_details_view.dart';

/// Displays a list of SampleItems.
class CustomerListView extends StatelessWidget {
  const CustomerListView({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: const [
          // None at present
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'customerListView',
        itemCount: customers.length,
        itemBuilder: (BuildContext context, int index) {
          final customer = customers[index];
          return ListTile(
            title: Text(customer.name),
            leading: const Icon(Icons.person_outline_outlined),
            onTap: () {
              // Navigate to the details page. If the user leaves and returns to
              // the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => (CustomerDetailsView(customer)))
              );
            }
          );
        },
      ),
    );
  }
}
