import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/common/widgets/loading.dart';
import 'package:journalbot/repository/page_repo.dart';

class UserPages extends ConsumerStatefulWidget {
  const UserPages(this.bookId, {super.key});
  final String bookId;

  @override
  ConsumerState<UserPages> createState() => _UserPagesState();
}

class _UserPagesState extends ConsumerState<UserPages> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(futurePagesProvider(widget.bookId)).when(
          data: (pages) {
            if (pages.isNotEmpty) {
              return const PagesList();
            } else {
              return const Center(
                child: Text(
                  'No pages',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }
          },
          loading: () => const Loader(),
          error: (error, stackTrace) {
            return ErrorWidget(error);
          },
        );
  }
}

class PagesList extends ConsumerStatefulWidget {
  const PagesList({super.key});

  @override
  ConsumerState<PagesList> createState() => _PagesListState();
}

class _PagesListState extends ConsumerState<PagesList> {
  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(pagesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return Card(
            color: colorScheme.secondaryContainer,
            child: ListTile(
              // BOOK ICON
              leading: Text(
                page.icon,
                style: const TextStyle(fontSize: 30),
              ),
              // BOOK TITLE
              title: Text(
                page.title,
                style: TextStyle(
                  fontSize: 20,
                  color: colorScheme.onSecondaryContainer,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // BOOK DESCRIPTION
              subtitle: Text(
                page.updatedAt.toString(),
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 15,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
