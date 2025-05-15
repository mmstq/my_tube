import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:my_tube/core/util/helper_functions.dart';
import 'package:my_tube/presentation/pages/reels.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  const BottomBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (i) {
          if (i == 1) {
            navigateTo(context, const Reels());
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        iconSize: 26,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedHome09),
            activeIcon: Icon(HugeIcons.strokeRoundedHome09),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedPlayList),
            activeIcon: Icon(HugeIcons.strokeRoundedPlayList),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedPlusSignCircle),
            activeIcon: Icon(HugeIcons.strokeRoundedPlusSignCircle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedMortarboard02),
            activeIcon: Icon(HugeIcons.strokeRoundedMortarboard02),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedUser02),
            activeIcon: Icon(HugeIcons.strokeRoundedUser02),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
