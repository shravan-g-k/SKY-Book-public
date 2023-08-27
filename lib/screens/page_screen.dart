import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/model/page_model.dart';

import '../controller/page_controller.dart';

// Page screen for editing a page data
class PageScreen extends ConsumerStatefulWidget {
  const PageScreen({super.key, required this.page});
  final PageModel page;

  @override
  ConsumerState<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends ConsumerState<PageScreen> {
  late TextEditingController titleController;
  late TextEditingController iconController;
  late quill.QuillController controller;
  late Timer timer; // Timer for autosaving
  @override
  void initState() {
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
          ),
        );
        return true;
      },
      // SCAFFOLD
      child: Scaffold(
        // BOTTOM NAVIGATION BAR - Quill toolbar
        bottomNavigationBar: Padding(
          // To avoid the keyboard overlapping the toolbar
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // Quill toolbar
          child: quill.QuillToolbar.basic(
            controller: controller,
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
                                  100, //constriant the width of the textfield
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
                      // CLOSE BUTTON
                      Positioned(
                        right: -5,
                        top: 10,
                        child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(
                                context,
                                PageModel(
                                  id: widget.page.id,
                                  title: titleController.text,
                                  icon: iconController.text,
                                  data: jsonEncode(
                                    controller.document.toDelta().toJson(),
                                  ),
                                  createdAt: widget.page.createdAt,
                                  updatedAt: DateTime.now(),
                                ),
                              );
                            }),
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
                  // UPDATED AT
                  Text(
                    'Updated :  ${widget.page.updatedAt.day}/${widget.page.updatedAt.month}/${widget.page.updatedAt.year}',
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
                      child: quill.QuillEditor.basic(
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
