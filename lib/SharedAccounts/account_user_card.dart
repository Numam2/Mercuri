import 'package:flutter/material.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class AccountUserCard extends StatelessWidget {
  final ThemeProvider theme;
  const AccountUserCard(this.theme, {super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);
    if (userData == null) {
      return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: Colors.grey, strokeAlign: 0.5)),
      child: Text(
        userData.name!,
        style: TextStyle(
            fontSize: 11, color: theme.isDarkMode ? Colors.white : Colors.grey),
      ),
    );
  }
}
