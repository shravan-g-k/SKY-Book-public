import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/common/widgets/error_dialog.dart';
import 'package:skybook/controller/book_controller.dart';
import 'package:skybook/screens/books_screens/create_page_dialog.dart';
import 'package:skybook/screens/books_screens/pages_list.dart';
import 'package:skybook/utils/routes.dart';

import '../../model/book_model.dart';

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

  void createANewPageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreatePageDialog(bookId: widget.book.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          // COLUMN - Icon, Title, Description, Pages
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ROW - Icon, Title
              Hero(
                tag: widget.book.id,
                child: Material(
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
                                      content:
                                          "Icon cannot be same as previous",
                                    );
                                    // if the value is not empty and not same as previous value
                                    // we update the book
                                  } else {
                                    ref.read(bookControllerProvider).updateBook(
                                        context: context,
                                        book:
                                            widget.book.copyWith(icon: value));
                                  }
                                },
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
                                controller: _titleController,
                                textInputAction: TextInputAction
                                    .done, //change the keyboard to done
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
                                      content:
                                          "Title cannot be same as previous",
                                    );
                                    // if the value is not empty and not same as previous value
                                    // we update the book
                                  } else {
                                    ref.read(bookControllerProvider).updateBook(
                                        context: context,
                                        book:
                                            widget.book.copyWith(title: value));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: -5,
                        top: 10,
                        child: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                padding: const EdgeInsets.all(0),
                                child: ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete'),
                                  onTap: () {
                                    ref.read(bookControllerProvider).deleteBook(
                                          context: context,
                                          bookId: widget.book.id,
                                        );
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                padding: const EdgeInsets.all(0),
                                child: ListTile(
                                  leading: const Icon(Icons.password_rounded),
                                  title: const Text('Password'),
                                  onTap: () {
                                    if (widget.book.password == null) {
                                      context.pushNamed(
                                        MyRouter.createUpdatePasswordRoute,
                                        extra: [widget.book, true],
                                      );
                                    } else {
                                      context.pushNamed(
                                        MyRouter.createUpdatePasswordRoute,
                                        extra: [widget.book, false],
                                      );
                                    }
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
                      fontSize: 12,
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
              // YOUR PAGES text
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Pages",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              // SIZED BOX
              const SizedBox(height: 10),
              // NEW PAGE BUTTON
              ElevatedButton(
                onPressed: () {
                  createANewPageDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  minimumSize: const Size(double.infinity, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: Text(
                  '+ New Page',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              // PAGES
              UserPages(widget.book.id)
            ],
          ),
        ),
      ),
    );
  }
}
