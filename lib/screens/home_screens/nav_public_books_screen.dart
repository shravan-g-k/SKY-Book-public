import 'package:flutter/material.dart';

class PublicBookScreenComponent extends StatefulWidget {
  const PublicBookScreenComponent({super.key});

  @override
  State<PublicBookScreenComponent> createState() =>
      _PublicBookScreenComponentState();
}

class _PublicBookScreenComponentState extends State<PublicBookScreenComponent> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Explore Public Books'),
          ),
        ],
      ),
    );
  }
}
