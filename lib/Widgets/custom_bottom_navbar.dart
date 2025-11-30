import 'package:flutter/material.dart';
import '../models/model_warna.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const CustomBottomNavbar({
    Key? key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor ?? Warna().Ijo,
      selectedItemColor: selectedItemColor ?? Warna().Putih,
      unselectedItemColor: unselectedItemColor ?? Colors.white70,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.dashboard, 0),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.shopping_basket, 1),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.dashboard_customize, 2),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.description, 3),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.layers, 4),
          label: '',
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return Column(
      children: [
        Container(
          height: 3,
          width: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? (selectedItemColor ?? Warna().Putih)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(height: 8),
        Icon(icon),
      ],
    );
  }
}