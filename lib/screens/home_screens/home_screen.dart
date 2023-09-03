import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:SkyBook/controller/auth_controller.dart';
import 'package:SkyBook/repository/auth_repo.dart';
import 'package:SkyBook/screens/home_screens/books_list.dart';

import '../../utils/theme.dart';
import 'add_book_bottom_sheet.dart';

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
      return "Good Morning";
    }
    if (hour < 17) {
      return "Good Afternoon";
    }
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final colorScheme = Theme.of(context).colorScheme;
    // SCAFFOLD
    return Scaffold(
      key: scaffoldKey, // key is req for the bottom sheet to work
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
                    style: const TextStyle(fontSize: 30),
                  ),
                  const Spacer(),
                  // POpUP MENU BUTTON
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text("Sign Out"),
                        onTap: () => ref
                            .read(authControllerProvider)
                            .signOut(context), // Sign out
                      ),
                      // change theme
                      PopupMenuItem(
                        child: const Text("Change Theme"),
                        onTap: () {
                          ref
                              .read(brightnessNotifierProvider.notifier)
                              .toggle();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // USER NAME
              Text(
                user!.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
              // DIVIDER
              Divider(color: colorScheme.primary),
              // YOUR BOOKS
              const Text(
                "Your Books",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              // NEW BOOK BUTTON
              ElevatedButton(
                onPressed: () => newBookDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  minimumSize: const Size(double.infinity, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  side: const BorderSide(
                    width: 0.5,
                  ),
                  splashFactory: InkRipple.splashFactory,
                ),
                child: Text(
                  '+ New Book',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const UserBooks()
            ],
          ),
        ),
      ),
    );
  }
}
