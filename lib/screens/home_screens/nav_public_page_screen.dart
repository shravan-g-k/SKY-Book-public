import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/common/widgets/loading.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/repository/public_content_repo.dart';
import 'package:skybook/utils/routes.dart';

import '../../model/public_page_model.dart';

class PublicContentScreenComponent extends StatefulWidget {
  const PublicContentScreenComponent({super.key});

  @override
  State<PublicContentScreenComponent> createState() =>
      _PublicContentScreenComponentState();
}

class _PublicContentScreenComponentState
    extends State<PublicContentScreenComponent> {
  late Future<List<dynamic>> futurePublicContent;
  List<bool> liked = [];
  //make a scroll controller and check if it has scroller till the end and then load more
  //also add a refresh indicator

  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    futurePublicContent = PublicPageRepository().getPublicPages();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        int length = liked.length;
        //load more
        PublicPageRepository().getPublicPages(next: length).then((value) {
          if (value.length == liked.length) {}
          setState(() {
            futurePublicContent = Future.value(value);
            liked.addAll(List.generate(value.length, (index) => false));
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Featured Books and Pages'),
          ),
          FutureBuilder(
            future: futurePublicContent,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<PublicPage> publicContent =
                    snapshot.data as List<PublicPage>;
                return Expanded(
                    child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: publicContent.length,
                  itemBuilder: (context, index) {
                    final item = publicContent[index];
                    liked.add(false);

                    String data = quill.Document.fromJson(jsonDecode(item.data))
                        .toPlainText();
                    return Card(
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(
                            MyRouter.publicPageRoute,
                            extra: item,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${item.icon} ${item.title}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Flexible(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    data,
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              Consumer(
                                builder: (context, ref, child) => InkWell(
                                  onTap: () {
                                    if (liked[index]) return;
                                    PublicPageRepository().likePublicPage(
                                      publicPageId: item.id,
                                      token: ref.read(userProvider)!.token,
                                    );
                                    setState(() {
                                      item.likes += 1;
                                      liked[index] = true;
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        liked[index]
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      Text(item.likes.toString()),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "by ${item.creator}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ));
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  'Something went wrong',
                ));
              } else {
                return const Center(
                  child: Loader(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
