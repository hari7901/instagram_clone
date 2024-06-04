import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomMenu extends StatelessWidget {
  final List<MenuItem> menuItems;

  const CustomMenu({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: menuItems.map((item) {
          return ListTile(
            leading: FaIcon(item.icon, color: Colors.white),
            title: Text(
              item.title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              item.onTap();
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
