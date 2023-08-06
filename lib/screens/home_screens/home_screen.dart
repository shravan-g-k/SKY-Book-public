import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/common/common_text_styles.dart';
import 'package:journalbot/repository/auth_repo.dart';

import '../../controller/auth_controller.dart';
import '../../utils/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wishUser(),
                style: titleTextStyle(theme, fontSize: 28),
              ),
              Text(
                user!.name,
                style: titleTextStyle(theme, fontSize: 32),
                overflow: TextOverflow.ellipsis,
              ),
              Divider(color: theme.primaryColor),
              Text(
                "Your Books",
                style: titleTextStyle(theme, fontSize: 30),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    side: BorderSide(
                      color: theme.onBackgroundColor,
                      width: 0.5,
                    )),
                child: Text(
                  '+ Add Book',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    ref.read(themeProvider).toggleTheme();
                  });
                },
                child: const Text('theme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
