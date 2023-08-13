import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/common/widgets/error_dialog.dart';
import 'package:journalbot/controller/book_controller.dart';

import '../model/book_model.dart';

// BookScreen is the screen where the user can edit the book
// create a new page
class BookScreen extends ConsumerStatefulWidget {
  const BookScreen({super.key, required this.book});
  final Book book;

  @override
  ConsumerState<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen> {
  // _isDescriptionVisible is used to toggle the visibility of the description
  late bool _isDescriptionVisible;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _iconController;

  @override
  void initState() {
    _isDescriptionVisible =
        false; // we initialize the _isDescriptionVisible to false
    _titleController = TextEditingController(text: widget.book.title);
    _descriptionController =
        TextEditingController(text: widget.book.description);
    _iconController = TextEditingController(text: widget.book.icon);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          // COLUMN - Icon, Title, Description, Pages
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ROW - Icon, Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // ICON
                  Hero(
                    tag: widget.book.id,
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            width: 100, //constriant the width of the textfield
                            child: TextField(
                              controller: _iconController,
                              maxLength: 1,
                              decoration: const InputDecoration(
                                counter: SizedBox.shrink(), //hide the counter
                              ),
                              style: const TextStyle(fontSize: 50),
                              onSubmitted: (value) {
                                // we check if the value is empty
                                if (value.isEmpty) {
                                  _iconController.text = widget.book
                                      .icon; //set the icon to the previous value
                                  errorDialog(
                                    context: context,
                                    title: "Enter Icon",
                                    content: "Icon cannot be empty",
                                  );
                                  // we check if the value is same as the previous value
                                } else if (value == widget.book.icon) {
                                  errorDialog(
                                    context: context,
                                    title: "Enter Icon",
                                    content: "Icon cannot be same as previous",
                                  );
                                  // if the value is not empty and not same as previous value
                                  // we update the book
                                } else {
                                  ref.read(bookControllerProvider).updateBook(
                                      context: context,
                                      book: widget.book.copyWith(icon: value));
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SIZED BOX
                  const SizedBox(height: 30),
                  // TITLE
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      textInputAction:
                          TextInputAction.done, //change the keyboard to done
                      maxLines: null, //allow multiple lines
                      onSubmitted: (value) {
                        // we check if the value is empty
                        if (value.isEmpty) {
                          _titleController.text = widget.book.title;
                          errorDialog(
                            context: context,
                            title: "Enter Title",
                            content: "Title cannot be empty",
                          );
                          // we check if the value is same as the previous value
                        } else if (value == widget.book.title) {
                          errorDialog(
                            context: context,
                            title: "Enter Title",
                            content: "Title cannot be same as previous",
                          );
                          // if the value is not empty and not same as previous value
                          // we update the book
                        } else {
                          ref.read(bookControllerProvider).updateBook(
                              context: context,
                              book: widget.book.copyWith(title: value));
                        }
                      },
                    ),
                  ),
                ],
              ),
              // HIDE/SHOW DESCRIPTION BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // we toggle the visibility of the description
                    setState(() {
                      _isDescriptionVisible = !_isDescriptionVisible;
                    });
                  },
                  icon: Icon(
                    _isDescriptionVisible
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_fill,
                  ),
                  label: Text(
                    _isDescriptionVisible
                        ? 'Hide Description'
                        : 'Show Description',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      const BorderSide(
                        color: Colors.transparent, //hide the border
                      ),
                    ),
                  ),
                ),
              ),
              // SIZED BOX
              const SizedBox(height: 10),
              // DESCRIPTION
              // show the description if _isDescriptionVisible is true
              if (_isDescriptionVisible)
                TextField(
                  controller: _descriptionController,
                  textInputAction:
                      TextInputAction.done, //change the keyboard to done
                  maxLines: null, //allow multiple lines
                  style: const TextStyle(fontSize: 16),
                  onSubmitted: (value) {
                    // we check if the value is empty
                    if (value.isEmpty) {
                      _descriptionController.text = widget.book.description;
                      errorDialog(
                        context: context,
                        title: "Enter Description",
                        content: "Description cannot be empty",
                      );
                      // we check if the value is same as the previous value
                    } else if (value == widget.book.description) {
                      errorDialog(
                        context: context,
                        title: "Enter Description",
                        content: "Description cannot be same as previous",
                      );
                      // if the value is not empty and not same as previous value
                    } else {
                      ref.read(bookControllerProvider).updateBook(
                          context: context,
                          book: widget.book.copyWith(description: value));
                    }
                  },
                ),
              // YOUR PAGES
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Pages",
                  style: TextStyle(
                    fontSize: 25,
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
