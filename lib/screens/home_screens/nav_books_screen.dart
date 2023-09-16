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
          Text('Public Book Screen'),
        ],
      ),
    );
  }
}
