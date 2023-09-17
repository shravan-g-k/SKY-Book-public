import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/common/pages/error_screen.dart';
import 'package:skybook/common/widgets/loading.dart';
import 'package:skybook/repository/book_repo.dart';
import 'package:skybook/utils/routes.dart';

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
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/sky-logo.png',
                  height: 150,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create your first book',
                ),
              ],
            ),
          );
        }
      },
      error: (error, stackTrace) {
        return const MyErrorWidget();
      },
      loading: () {
        return const Center(child: Loader());
      },
    );
  }
}

// List View of the books
class BooksList extends ConsumerWidget {
  const BooksList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get the books from the booksProvider
    final books = ref.watch(booksProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ReorderableListView.builder(
        // TODO: implement onReorder
        onReorder: (oldIndex, newIndex) {},
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            key: ValueKey(books[index].id),
            onTap: () {
              if (books[index].password != null) {
                context.pushNamed(
                  MyRouter.passwordRoute,
                  extra: books[index],
                );
              } else {
                context.pushNamed(
                  MyRouter.bookRoute,
                  extra: books[index],
                );
              }
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
                  // BOOK PAGES & public/private
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // PUBLIC/PRIVATE
                      if (books[index].publicBookId != null)
                        const Icon(
                          Icons.public,
                        ),
                      Text(
                        books[index].pages.length <= 1
                            ? '${books[index].pages.length} page'
                            : '${books[index].pages.length} pages',
                        style: TextStyle(
                          fontSize: 15,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
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
