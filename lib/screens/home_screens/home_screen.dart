import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:skybook/screens/home_screens/nav_public_page_screen.dart';
import 'package:skybook/screens/home_screens/nav_chat_screen.dart';
import 'package:skybook/screens/home_screens/nav_home_screen.dart';

// HomeScreen - This is the main screen of the app
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin // Used by the bottom sheet
{
  late AnimationController animationController;
  late Animation<double> rotationAnimation;
  late int navBarIndex;

  @override
  void initState() {
    navBarIndex = 1;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    rotationAnimation = Tween<double>(
      begin: 0,
      end: 180,
    ).animate(animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // SCAFFOLD
    return SafeArea(
      child: Scaffold(
        // SAFE AREA
        body: navBarIndex == 0
            ? const PublicContentScreenComponent()
            : navBarIndex == 1
                ? const HomeScreenComponent()
                : const ChatScreenComponent(),
        bottomNavigationBar: MoltenBottomNavigationBar(
          selectedIndex: navBarIndex,
          barColor: colorScheme.secondaryContainer,
          domeCircleColor: colorScheme.primary,
          onTabChange: (index) {
            setState(() {
              navBarIndex = index;
            });
          },
          tabs: [
            MoltenTab(
              icon: const Icon(Icons.book),
              selectedColor: colorScheme.onPrimary.withOpacity(0.7),
            ),
            MoltenTab(
              icon: const Icon(Icons.home_rounded),
              selectedColor: colorScheme.onPrimary.withOpacity(0.7),
            ),
            MoltenTab(
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              selectedColor: colorScheme.onPrimary.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
