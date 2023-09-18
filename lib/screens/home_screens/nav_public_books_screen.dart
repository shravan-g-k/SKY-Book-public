import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/repository/public_content_repo.dart';

import '../../model/public_book_model.dart';
import '../../model/public_page_model.dart';

class PublicBookScreenComponent extends StatefulWidget {
  const PublicBookScreenComponent({super.key});

  @override
  State<PublicBookScreenComponent> createState() =>
      _PublicBookScreenComponentState();
}

class _PublicBookScreenComponentState extends State<PublicBookScreenComponent> {
  late Future<List<dynamic>> futurePublicContent;
  List<bool> liked = [];
  @override
  void initState() {
    futurePublicContent = PublicContentRepository().getPagesAndBooks();
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
                final List<dynamic> publicContent =
                    snapshot.data as List<dynamic>;
                return Expanded(
                    child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: publicContent.length,
                  itemBuilder: (context, index) {
                    final item = publicContent[index];
                    liked.add(false);
                    if (item is PublicBook) {
                      return Card(
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
                                    item.description,
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
                                    PublicContentRepository().likePublicBook(
                                      publicBookId: item.id,
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
                      );
                    } else if (item is PublicPage) {
                      String data =
                          quill.Document.fromJson(jsonDecode(item.data))
                              .toPlainText();
                      return Card(
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
                                    PublicContentRepository().likePublicPage(
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
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ));
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
