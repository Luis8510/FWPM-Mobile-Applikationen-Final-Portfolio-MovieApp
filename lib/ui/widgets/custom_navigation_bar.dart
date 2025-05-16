import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  int selectedIndex;
  Function onItemTapped;
  CustomNavigationBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
          left: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
          right: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
        ),
      ),
      child: NavigationBar(
        height: 72,
        selectedIndex: widget.selectedIndex,
        backgroundColor: Colors.transparent,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        indicatorColor: Colors.white.withOpacity(0.5),
        onDestinationSelected: (index) => widget.onItemTapped(index),
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            selectedIcon: Icon(
              Icons.home,
              color: Theme.of(context).iconTheme.color,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.movie_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            selectedIcon: Icon(
              Icons.movie,
              color: Theme.of(context).iconTheme.color,
            ),
            label: 'Your Movies',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            selectedIcon: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
