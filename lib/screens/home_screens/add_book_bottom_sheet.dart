import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controller/book_controller.dart';
import '../../repository/auth_repo.dart';

class AddNewBookBottomSheet extends ConsumerStatefulWidget {
  const AddNewBookBottomSheet({super.key});

  @override
  ConsumerState<AddNewBookBottomSheet> createState() =>
      _AddNewBookBottomSheetState();
}

class _AddNewBookBottomSheetState extends ConsumerState<AddNewBookBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _bookNameController; //Name of the book
  late final TextEditingController
      _bookDescriptionController; //Description of the book
  late final TextEditingController
      _bookIconController; //Icon of the book - actually its just text
  late final AnimationController
      _bottomSheetAnimationController; //bottom animation controller
  late final FocusNode _bookNameFocusNode; //Focus node for the book name
  @override
  void initState() {
    // Initialize the controllers with default values
    _bookNameController = TextEditingController(text: "Untitled");
    _bookDescriptionController = TextEditingController(text: "No description");
    _bookIconController = TextEditingController(text: "📒");
    _bottomSheetAnimationController = BottomSheet.createAnimationController(
        this); //This is why we used TickerProviderStateMixin
    _bookNameFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _bookNameController.dispose();
    _bookDescriptionController.dispose();
    _bookIconController.dispose();
    _bottomSheetAnimationController.dispose();
    _bookNameFocusNode.dispose();
    super.dispose();
  }

  void addBook() {
    final token = ref.read(userProvider)!.token;
    // Add the book to the database
    ref.read(bookControllerProvider).createBook(
          title: _bookNameController.text == ""
              ? "Untitled"
              : _bookNameController.text,
          description: _bookDescriptionController.text == ""
              ? "No description"
              : _bookDescriptionController.text,
          icon:
              _bookIconController.text == "" ? "📒" : _bookIconController.text,
          token: token,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BottomSheet(
      onClosing: () {
        // Reset the controllers when the bottom sheet is closed
        _bookDescriptionController.text = "No description";
        _bookNameController.text = "Untitled";
        _bookIconController.text = "📒";
      },
      enableDrag: true,
      showDragHandle: true,
      animationController:
          _bottomSheetAnimationController, //This is why we used TickerProviderStateMixin
      // We need to close the bottom sheet manually when the user drags it down
      onDragEnd: (details, {required isClosing}) {
        if (isClosing) {
          context.pop();
        }
      },
      builder: (context) {
        // For the small screen devices, we need to wrap the bottom sheet in a SingleChildScrollView
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ADD A NEW BOOK
                const Text(
                  "Add a new book",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                // ICON of the book - Stack is used to show the edit icon on top of the book icon
                // STACK -> BOOK ICON | EDIT ICON
                Stack(
                  children: [
                    // BOOK ICON
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 80,
                        child: TextField(
                          focusNode: _bookNameFocusNode,
                          controller: _bookIconController,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            counter: SizedBox.shrink(), // Hide the counter
                          ),
                          style: const TextStyle(
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                    // EDIT ICON
                    Positioned(
                      top: 50,
                      left: (MediaQuery.of(context).size.width /
                          2), // Center the icon
                      child: GestureDetector(
                        onTap: () {
                          _bookNameFocusNode.requestFocus();
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                // BOOK NAME text field
                TextField(
                  controller: _bookNameController,
                  decoration: InputDecoration(
                    hintText: "Book Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ), //defining 2 borders creates a nice effect
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                // SPACE
                const SizedBox(height: 12),
                // BOOK DESCRIPTION text field
                TextField(
                  controller: _bookDescriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                // SPACE
                const SizedBox(height: 12),
                // ADD BOOK button
                ElevatedButton(
                  onPressed: () {
                    // Add the book to the database
                    addBook();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    backgroundColor: colorScheme.primary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    "Add Book",
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
