import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool menuenabled;
  final bool notificationenabled;
  final VoidCallback? ontap;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.menuenabled = false,
    this.notificationenabled = false,
    this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),

      // 🔹 Menu button
      leading: menuenabled
          ? IconButton(
              color: Colors.black,
              onPressed: ontap,
              icon: Icon(Icons.menu),
            )
          : null,

      // 🔹 Notification icon
      actions: [
        if (notificationenabled)
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/notification.png",
                width: 30,
              ),
            ),
          ),
      ],

      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
