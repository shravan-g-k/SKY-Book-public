import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skybook/controller/public_content_controller.dart';
import 'package:skybook/model/page_model.dart';

import '../../common/widgets/error_dialog.dart';
import '../../controller/page_controller.dart';
import 'ai_dialog.dart';
import 'custom_image_embed.dart';

// Page screen for editing a page data
class PageScreen extends ConsumerStatefulWidget {
  const PageScreen({required this.bookId, super.key, required this.page});
  final PageModel page;
  final String bookId;

  @override
  ConsumerState<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends ConsumerState<PageScreen> {
  late TextEditingController titleController;
  late TextEditingController iconController;
  late quill.QuillController controller;
  late Timer timer; // Timer for autosaving
  late String? publicPageId;
  int? likesCount = 0;
  @override
  void initState() {
    publicPageId = widget.page.publicPageId;
    if (publicPageId != null) {
      ref
          .read(publicContentControllerProvider)
          .getPageLikes(publicPageId!)
          .then((value) {
        setState(() {
          likesCount = value;
        });
      });
    }
    // Initialize the controllers with the intitial page data
    titleController = TextEditingController(text: widget.page.title);
    iconController = TextEditingController(text: widget.page.icon);
    // Initialize the quill controller with the initial page data
    if (widget.page.data.isEmpty) {
      controller = quill.QuillController.basic();
    } else {
      controller = quill.QuillController(
        document: quill.Document.fromJson(jsonDecode(widget.page.data)),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    timer =
        autosave(); // Start the timer and assign so that it can be cancelled later
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer and dispose the controllers
    timer.cancel();
    titleController.dispose();
    iconController.dispose();
    controller.dispose();
    super.dispose();
  }

  // Autosave the page data every 40 seconds
  Timer autosave() {
    return Timer.periodic(
      const Duration(seconds: 40),
      (timer) {
        PageModel pageModel = PageModel(
          id: widget.page.id,
          title:
              titleController.text.isEmpty ? 'Untitled' : titleController.text,
          icon: iconController.text.isEmpty ? '📄' : iconController.text,
          data: jsonEncode(controller.document
              .toDelta()
              .toJson()), // Convert the quill document to json
          createdAt: widget.page.createdAt,
          updatedAt: widget.page
              .updatedAt, //updatedAt is not updated bcz we want to check if the data has changed or not
          publicPageId: publicPageId,
        );
        // Only update the page if the data has changed
        if (pageModel.data != widget.page.data) {
          pageModel = pageModel.copyWith(
              updatedAt:
                  DateTime.now()); //updatedAt is updated to the current time
          ref.read(pageControllerProvider).updatePage(
                pageModel: pageModel,
                context: context,
              );
        }
      },
    );
  }

  void deletePage() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Page'),
          content: const Text('Are you sure you want to delete this page?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(pageControllerProvider).deletePage(
                      pageId: widget.page.id,
                      bookId: widget.bookId,
                      context: context,
                    );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void publishPage() {
    if (controller.document.isEmpty()) {
      errorDialog(
        context: context,
        title: "Empty Book",
        content: "You cannot make an empty book public",
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Once you make this page public, you cannot make it private again.',
              style: TextStyle(
                fontSize: 12,
              )),
          actions: [
            TextButton(
              onPressed: () {
                ref
                    .read(publicContentControllerProvider)
                    .createPublicPage(
                      page: widget.page.copyWith(
                        title: titleController.text.isEmpty
                            ? 'Untitled'
                            : titleController.text,
                        icon: iconController.text.isEmpty
                            ? '📄'
                            : iconController.text,
                        data: jsonEncode(controller.document
                            .toDelta()
                            .toJson()), // Convert the quill document to json
                      ),
                      context: context,
                    )
                    .then((value) {
                  if (value != null) {
                    publicPageId = value.id;
                  }
                });
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

// Add image to the quill editor
  void addImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    // Create a new image block embed
    final image = ImageBlockEmbed(
      'image',
      imageFile!.path,
    );
    // Insert the image block embed to the editor
    controller.document.insert(
      controller.document.length - 1,
      image,
    );
    // Insert a few new line after the image bcz the image is inserted at the end of the editor
    // and it gets difficult to add text after the image
    controller.document.insert(controller.document.length - 1, '\n \n \n');
  }

  @override
  Widget build(BuildContext context) {
    // WILL POP SCOPE - to return the pagemodel when the user presses the back button
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the previous screen
        Navigator.pop(
          context,
          PageModel(
            id: widget.page.id,
            title: titleController.text.isEmpty
                ? 'Untitled'
                : titleController.text,
            icon: iconController.text.isEmpty ? '📄' : iconController.text,
            data: jsonEncode(controller.document.toDelta().toJson()),
            createdAt: widget.page.createdAt,
            updatedAt: DateTime.now(),
            publicPageId: publicPageId,
          ),
        );
        return true;
      },
      // SCAFFOLD
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AiDialog(
                  onAddText: (text) {
                    controller.document
                        .insert(controller.document.length - 1, text);
                  },
                );
              },
            );
          },
          child: Image.asset(
            'assets/sky-chat-fb-button.png',
            height: 80,
          ),
        ),
        // BOTTOM NAVIGATION BAR - Quill toolbar
        bottomNavigationBar: Padding(
          // To avoid the keyboard overlapping the toolbar
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // Quill toolbar
          child: quill.QuillToolbar.basic(
            controller: controller,
            customButtons: [
              quill.QuillCustomButton(icon: Icons.image, onTap: addImage)
            ],
            iconTheme: quill.QuillIconTheme(
              iconSelectedColor: Theme.of(context).colorScheme.primary,
              iconUnselectedColor: Theme.of(context).colorScheme.primary,
              iconSelectedFillColor: Theme.of(context).colorScheme.onSecondary,
            ),
            toolbarIconSize: 22,
            multiRowsDisplay: false, // Display the toolbar in a single row
          ),
        ),
        // COLUMN - Icon, title, 2 date and quill editor
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // PADDING - Icon and title and close button
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
              // HERO - to animate the icon and title and close button
              child: Hero(
                tag: widget.page.id,
                child: Material(
                  // Material to avoid the hero animation error
                  // STACK - Icon title and close button
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // ICON
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width:
                                  100, //constraint the width of the textfield
                              child: TextField(
                                controller: iconController,
                                maxLength: 1,
                                decoration: const InputDecoration(
                                  counter: SizedBox.shrink(), //hide the counter
                                ),
                                style: const TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                          // SIZED BOX
                          const SizedBox(width: 5),
                          // TITLE
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: TextField(
                                controller: titleController,
                                textInputAction: TextInputAction
                                    .done, //change the keyboard to done
                                maxLines: null, //allow multiple lines
                              ),
                            ),
                          ),
                        ],
                      ),
                      // MENU BUTTON
                      Positioned(
                        right: -5,
                        top: 10,
                        child: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete'),
                                  onTap: deletePage,
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(Icons.public),
                                  title: const Text('Public'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    publishPage();
                                  },
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // PADDING - 2 dates
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              // ROW - 2 dates
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CREATED AT
                  Text(
                    'Created : ${widget.page.createdAt.day}/${widget.page.createdAt.month}/${widget.page.createdAt.year}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  if (widget.page.publicPageId != null)
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        Text(likesCount.toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ))
                      ],
                    ),
                  // UPDATED AT
                  Text(
                    'Updated : ${widget.page.updatedAt.day}/${widget.page.updatedAt.month}/${widget.page.updatedAt.year}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // SIZED BOX
            const SizedBox(height: 10),
            // EXPANDED - Quill editor
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      // curved corners
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    // QUILL EDITOR
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: quill.QuillEditor(
                        // Custom embeds
                        embedBuilders: [
                          ImageBlockBuilder((node) {
                            // Delete the image from the editor
                            // when the delete button is pressed
                            controller.document.delete(
                              node.documentOffset,
                              node.length,
                            );
                          }),
                        ],
                        focusNode: FocusNode(),
                        scrollController: ScrollController(),
                        scrollable: true,
                        autoFocus: false,
                        controller: controller,
                        readOnly: false,
                        padding: const EdgeInsets.all(8),
                        placeholder: 'Add your thoughts here...',
                        expands: false,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
