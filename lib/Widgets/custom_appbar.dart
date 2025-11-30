import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model_warna.dart';
import '../providers/auth_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showActions;
  final bool showBackButton;
  final VoidCallback? onPersonTap;
  final VoidCallback? onSettingsTap;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showActions = true,
    this.showBackButton = false,
    this.onPersonTap,
    this.onSettingsTap,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isAdmin = user?.role == 'admin';

    return AppBar(
      automaticallyImplyLeading: showBackButton,
      backgroundColor: Warna().bgUtama,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              title,
              style: TextStyle(
                color: titleColor ?? Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'CircularStd',
              ),
            ),
          ),
          SizedBox(height: 1),
        ],
      ),
      actions: showActions
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 9),
                child: Row(
                  children: [
                    // Show person icon only for admin users
                    if (isAdmin)
                      GestureDetector(
                        onTap: onPersonTap,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          shadowColor: Colors.transparent,
                          color: Warna().Ijo,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.people,
                              size: 25,
                              color: iconColor ?? Colors.white,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 2),
                    GestureDetector(
                      onTap: onSettingsTap,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        shadowColor: Colors.transparent,
                        color: Warna().Ijo,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.settings,
                            size: 25,
                            color: iconColor ?? Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
