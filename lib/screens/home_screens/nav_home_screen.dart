import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const.dart';
import '../../controller/auth_controller.dart';
import '../../repository/auth_repo.dart';
import '../../utils/routes.dart';
import '../../utils/theme.dart';
import 'add_book_bottom_sheet.dart';
import 'books_list.dart';

class HomeScreenComponent extends ConsumerStatefulWidget {
  const HomeScreenComponent({super.key});

  @override
  ConsumerState<HomeScreenComponent> createState() =>
      _HomeScreenComponentState();
}

class _HomeScreenComponentState extends ConsumerState<HomeScreenComponent> {
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); //also used by the bottom sheet
  // newBookDialog - This is the bottom sheet that is shown when the user clicks on the add book button
  void newBookDialog() {
    // Show the bottom sheet
    showBottomSheet(
      context: context,
      builder: (context) {
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

  void toggleTheme(WidgetRef ref) {
    final brightness = ref.read(brightnessNotifierProvider);
    ref.read(brightnessNotifierProvider.notifier).toggle();
    SharedPreferences.getInstance().then((value) {
      value.setBool(darkModeKey, !(brightness == Brightness.dark));
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
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
                  // change theme
                  PopupMenuItem(
                    onTap: () {
                      toggleTheme(ref);
                    },
                    child: const Text("Change Theme"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      context.pushNamed(MyRouter.aboutUsRoute);
                    },
                    child: const Text("About Us"),
                  ),
                  PopupMenuItem(
                    child: const Text("Sign Out"),
                    onTap: () => ref
                        .read(authControllerProvider)
                        .signOut(context), // Sign out
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
          UserBooks()
        ],
      ),
    );
  }
}
