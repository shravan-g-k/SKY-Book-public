import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skybook/model/public_page_model.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/repository/public_content_repo.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../page_screen/custom_image_embed.dart';

class PublicPageScreen extends StatefulWidget {
  const PublicPageScreen({super.key, required this.publicPage});
  final PublicPage publicPage;

  @override
  State<PublicPageScreen> createState() => _PublicPageScreenState();
}

class _PublicPageScreenState extends State<PublicPageScreen> {
  var _isLiked = false;
  late quill.QuillController controller;

  @override
  void initState() {
    controller = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(widget.publicPage.data)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final page = widget.publicPage;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    page.icon,
                    style: const TextStyle(fontSize: 50),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      page.title,
                      style: const TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "by ${page.creator}",
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, child) => IconButton(
                  onPressed: () {
                    if (_isLiked) return;
                    final token = ref.read(userProvider)!.token;
                    PublicPageRepository().likePublicPage(
                      publicPageId: page.id,
                      token: token,
                    );
                    setState(() {
                      _isLiked = true;
                      page.likes++;
                    });
                  },
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 5),
                      Text(page.likes.toString()),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        // curved corners
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      // QUILL EDITOR
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: quill.QuillEditor(
                          controller: controller,
                          // Custom embeds
                          embedBuilders: [
                            ImageBlockBuilder((node) {}),
                          ],
                          focusNode: FocusNode(),
                          scrollController: ScrollController(),
                          scrollable: true,
                          autoFocus: false,
                          readOnly: false,
                          padding: const EdgeInsets.all(8),
                          placeholder: 'Add your thoughts here...',
                          expands: false,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
