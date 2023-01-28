import 'package:flutter/material.dart';

class ListTileDemos extends StatelessWidget {
  const ListTileDemos({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: Text('🇨🇦'),
          title: Text("Ian Darwin"),
          subtitle: Text("Mobile Developer"),
          tileColor: Colors.greenAccent,
          trailing:
              Icon(Icons.book,
                color: Colors.red,
              ),
        ),
        ListTile(
          leading: Text('🇬🇧'),
          title: Text("Charles Darwin"),
          subtitle: Text("Naturalist"),
          tileColor: Colors.orangeAccent,
          trailing:
                Icon(Icons.anchor_rounded,
                  color: Colors.blue,
                ),
        ),
      ]
    );
  }
}

