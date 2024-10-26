import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_controller.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeController>(context);

    return Drawer(
      child: CupertinoSwitch(
        value: themeProvider.isDarkTheme(),
        onChanged: (onChanged) {
          themeProvider.toggleTheme();
        },
      ),
    );
  }
}
