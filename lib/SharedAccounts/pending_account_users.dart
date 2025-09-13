import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class PendingAccountUsers extends StatelessWidget {
  final ThemeProvider theme;
  final SharedAccounts sharedAccount;
  const PendingAccountUsers(this.theme, this.sharedAccount, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Por aceptar:  ',
              style: TextStyle(
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12),
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                children:
                    List.generate(sharedAccount.pendingMembers!.length, (x) {
                  //MemberCard
                  return StreamProvider<UserData?>.value(
                      value: DatabaseService()
                          .userData(sharedAccount.pendingMembers![x]),
                      initialData: null,
                      child: PendingUserCard(
                          theme, x, sharedAccount.pendingMembers!.length));
                }),
              ),
            ),
          ],
        ));
  }
}

class PendingUserCard extends StatelessWidget {
  final ThemeProvider theme;
  final int itemIndex;
  final int length;
  const PendingUserCard(this.theme, this.itemIndex, this.length, {super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);
    if (userData == null) {
      return const SizedBox();
    }
    return Text(
      itemIndex < length - 1 ? '${userData.name!},' : userData.name!,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}
