import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key});
// 
// 
// 
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Image(
            image: AssetImage('assets/sky-error.png'),
            height: 150,
          ),
          SizedBox(height: 10),
          Text(
            'Something unexpected happened',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
