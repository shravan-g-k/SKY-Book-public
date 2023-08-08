import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/common/common_text_styles.dart';
import 'package:journalbot/repository/auth_repo.dart';

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
