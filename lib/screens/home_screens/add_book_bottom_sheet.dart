import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/common_text_styles.dart';
import '../../controller/book_controller.dart';
import '../../repository/auth_repo.dart';
import '../../utils/theme.dart';

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
  @override
  void initState() {
    // Initialize the controllers with default values
    _bookNameController = TextEditingController(text: "Untitled");
    _bookDescriptionController = TextEditingController(text: "No description");
    _bookIconController = TextEditingController(text: "📒");
    _bottomSheetAnimationController = BottomSheet.createAnimationController(
        this); //This is why we used TickerProviderStateMixin
    super.initState();
  }

  @override
  void dispose() {
    _bookNameController.dispose();
    _bookDescriptionController.dispose();
    _bookIconController.dispose();
    _bottomSheetAnimationController.dispose();
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
    final theme = ref.watch(themeProvider);
    return BottomSheet(
      onClosing: () {
        // Reset the controllers when the bottom sheet is closed
        _bookDescriptionController.text = "No description";
        _bookNameController.text = "Untitled";
        _bookIconController.text = "📒";
      },
      backgroundColor: theme.backgroundColor,
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
                Text(
                  "Add a new book",
                  style: titleTextStyle(theme, fontSize: 24),
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
                          controller: _bookIconController,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counter: SizedBox.shrink(), // Hide the counter
                          ),
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // EDIT ICON
                    Positioned(
                      top: 50,
                      left: (MediaQuery.of(context).size.width /
                          2), // Center the icon
                      child: Icon(
                        Icons.edit,
                        color: theme.onBackgroundColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                // BOOK NAME text field
                TextField(
                  controller: _bookNameController,
                  style: titleTextStyle(theme, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Book Name",
                    hintStyle: titleTextStyle(theme, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ), //defining 2 borders creates a nice effect
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                ),
                // SPACE
                const SizedBox(height: 12),
                // BOOK DESCRIPTION text field
                TextField(
                  controller: _bookDescriptionController,
                  maxLines: 3,
                  style: titleTextStyle(theme, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: titleTextStyle(theme, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.primaryColor),
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
                    backgroundColor: theme.primaryColor,
                    minimumSize: const Size(double.infinity, 40),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    side:
                        BorderSide(color: theme.onBackgroundColor, width: 0.5),
                  ),
                  child: Text(
                    "Add Book",
                    style: titleTextStyle(theme, fontSize: 18).copyWith(
                      color: theme.onPrimaryColor,
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
