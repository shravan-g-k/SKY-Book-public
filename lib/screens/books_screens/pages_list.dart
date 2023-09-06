import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/common/pages/error_screen.dart';
import 'package:skybook/common/widgets/loading.dart';
import 'package:skybook/controller/page_controller.dart';
import 'package:skybook/repository/page_repo.dart';

import '../../model/page_model.dart';
import '../../utils/routes.dart';

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
            return PagesList(widget.bookId);
          },
          loading: () => const Loader(),
          error: (error, stackTrace) {
            return const MyErrorWidget();
          },
        );
  }
}

class PagesList extends ConsumerStatefulWidget {
  const PagesList(this.bookId, {super.key});
  final String bookId;

  @override
  ConsumerState<PagesList> createState() => _PagesListState();
}

class _PagesListState extends ConsumerState<PagesList> {
  late ScrollController scrollController;
  late bool isLoading;
  late bool hasNoMore;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollListner);
    isLoading = false;
    hasNoMore = false;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListner() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      // Prevents multiple requests ie if the user scrolls fast
      if (isLoading) return;
      if (hasNoMore) return; // We know there is no more pages
      setState(() {
        // Set the loading to true and rebuild the widget
        isLoading = true;
      });
      // Get the current pages used to get the length of the pages we have
      final pages = ref.watch(pagesProvider);
      // Get the pages from the server
      ref
          .read(pageControllerProvider)
          .getPages(widget.bookId, from: pages.length)
          .then((value) {
        // If the value is false then there are no more pages
        if (value == false) {
          hasNoMore = true; // Set hasNoMore to true
        }
        setState(() {
          // Pages are loaded so set isLoading to false
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(pagesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    // If there are no pages return a create page illustration
    if (pages.isEmpty) {
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
              'Create a page to talk to SKY \n:)',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    // show a list of pages with a loading indicator at the end
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        // Add 1 to the length of the pages to show the loading indicator
        itemCount: pages.length + 1,
        itemBuilder: (context, index) {
          // check if the index is the last one
          if (index == pages.length) {
            if (hasNoMore) {
              // If there are no more pages
              return const Center(child: Text('No more pages'));
            } else if (isLoading) {
              // If the pages are loading
              return const Center(child: CircularProgressIndicator());
            } else {
              // If the pages are not loading and there are no more pages
              return const SizedBox();
            }
          }
          final page = pages[index]; // Get the page
          // Return a card with the page icon, title and updatedAt
          // CARD
          // detector to navigate to the page
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                MyRouter.pageRoute,
                extra: [page, widget.bookId],
              ).then((value) {
                if (value != null) {
                  ref.read(pageControllerProvider).updatePage(
                        pageModel: value as PageModel,
                        context: context,
                      );
                }
              });
            },
            // hero to animate to the page
            child: Hero(
              tag: page.id,
              child: Card(
                color: colorScheme.secondaryContainer,
                // LIST TILE
                child: ListTile(
                  // PAGE ICON
                  leading: Text(
                    page.icon,
                    style: const TextStyle(fontSize: 30),
                  ),
                  // PAGE TITLE
                  title: Text(
                    page.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: colorScheme.onSecondaryContainer,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // PAGE UPDATED AT
                  subtitle: Text(
                    "${page.updatedAt.day}/${page.updatedAt.month}/${page.updatedAt.year}",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
