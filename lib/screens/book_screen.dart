import 'package:flutter/material.dart';

import '../model/book_model.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: book.id,
            child: Material(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    book.icon,
                    style: const TextStyle(fontSize: 100),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            book.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            book.description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
