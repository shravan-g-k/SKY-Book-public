import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journalbot/common/pages/error_screen.dart';
import 'package:journalbot/common/widgets/loading.dart';
import 'package:journalbot/repository/book_repo.dart';
import 'package:journalbot/utils/routes.dart';

import '../book_screen.dart';

// User Books is just like a wrapper for the BooksList widget
// calls the futureBookProvider to get the books of the user
// if the books are not empty, it returns the BooksList widget
// else it return No books
class UserBooks extends ConsumerStatefulWidget {
  const UserBooks({super.key});

  @override
  ConsumerState<UserBooks> createState() => _UserBooksState();
}

class _UserBooksState extends ConsumerState<UserBooks> {
  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    // future book provider is just used to initialize the booksProvider
    // it is not used anywhere else the data is used from the booksProvider
    return ref.watch(futureBookProvider).when(
      data: (data) {
        // we check if the books are not empty
        if (books!.isNotEmpty) {
          return const BooksList();
        } else {
          return const Center(
            child: Text(
              'No books',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }
      },
      error: (error, stackTrace) {
        return const ErrorScreen();
      },
      loading: () {
        return const Loader();
      },
    );
  }
}

// List View of the books
class BooksList extends ConsumerStatefulWidget {
  const BooksList({super.key});

  @override
  ConsumerState<BooksList> createState() => _BooksListState();
}

class _BooksListState extends ConsumerState<BooksList> {
  @override
  Widget build(BuildContext context) {
    // get the books from the booksProvider
    final books = ref.watch(booksProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                MyRouter.bookRoute,
                extra: books[index],
              );
            },
            child: Hero(
              tag: books[index].id,
              child: Card(
                color: colorScheme.secondaryContainer,
                child: ListTile(
                  // BOOK ICON
                  leading: Text(
                    books[index].icon,
                    style: const TextStyle(fontSize: 30),
                  ),
                  // BOOK TITLE
                  title: Text(
                    books[index].title,
                    style: TextStyle(
                      fontSize: 20,
                      color: colorScheme.onSecondaryContainer,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // BOOK DESCRIPTION
                  subtitle: Text(
                    books[index].description,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  // BOOK PAGES
                  trailing: Text(
                    books[index].pages.length <= 1
                        ? '${books[index].pages.length} page'
                        : '${books[index].pages.length} pages',
                    style: TextStyle(
                      fontSize: 15,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: books!.length,
      ),
    );
  }
}
