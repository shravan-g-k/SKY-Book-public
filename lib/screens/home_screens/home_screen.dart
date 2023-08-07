import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journalbot/common/common_text_styles.dart';
import 'package:journalbot/repository/auth_repo.dart';

import '../../utils/theme.dart';

// HomeScreen - This is the main screen of the app
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin // Used by the bottom sheet
{
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); //also used by the bottom sheet

  // newBookDialog - This is the bottom sheet that is shown when the user clicks on the add book button
  void newBookDialog() {
    // Show the bottom sheet
    scaffoldKey.currentState!.showBottomSheet(
      (context) {
        return const AddNewBookBottomSheet();
      },
    );
  }

  // Used to wish user based on time
  String wishUser() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning,";
    }
    if (hour < 17) {
      return "Good Afternoon,";
    }
    return "Good Evening,";
  }

  @override
  Widget build(BuildContext context) {
    MyTheme theme = ref.watch(themeProvider);
    final user = ref.read(userProvider);
    // SCAFFOLD
    return Scaffold(
      key: scaffoldKey, // key is req for the bottom sheet to work
      backgroundColor: theme.backgroundColor,
      // SAFE AREA
      body: SafeArea(
        // PADDING
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          // COLUMN
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GREETING
              Row(
                children: [
                  Text(
                    wishUser(),
                    style: titleTextStyle(theme, fontSize: 28),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.sunny),
                    onPressed: () {
                      setState(() {
                        ref.read(themeProvider).toggleTheme();
                      });
                    },
                  )
                ],
              ),
              // USER NAME
              Text(
                user!.name,
                style: titleTextStyle(theme, fontSize: 32),
                overflow: TextOverflow.ellipsis,
              ),
              // DIVIDER
              Divider(color: theme.primaryColor),
              // YOUR BOOKS
              Text(
                "Your Books",
                style: titleTextStyle(theme, fontSize: 30),
              ),
              // NEW BOOK BUTTON
              ElevatedButton(
                onPressed: () => newBookDialog(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  backgroundColor: theme.primaryColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  side: BorderSide(
                    color: theme.onBackgroundColor,
                    width: 0.5,
                  ),
                  splashFactory: InkRipple.splashFactory,
                ),
                child: Text(
                  '+ New Book',
                  style: titleTextStyle(theme, fontSize: 18)
                      .copyWith(color: theme.onPrimaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      _bottomSheetAnimationController; //Animation controller
  @override
  void initState() {
    // Initialize the controllers with default values
    _bookNameController = TextEditingController(text: "Untitled");
    _bookDescriptionController = TextEditingController(text: "No description");
    _bookIconController = TextEditingController(text: "📒");
    _bottomSheetAnimationController =
        BottomSheet.createAnimationController(this); //This is why we used TickerProviderStateMixin
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
      animationController: _bottomSheetAnimationController, //This is why we used TickerProviderStateMixin
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
                  onPressed: () {},
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
