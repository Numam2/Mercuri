import 'package:flutter/material.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class SearchUsers extends StatelessWidget {
  final Function resetControllers;
  final ThemeProvider theme;

  const SearchUsers(this.resetControllers, this.theme, {super.key});

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>?>(context);

    if (users == null || users.isEmpty) {
      return const SizedBox();
    }

    return Expanded(
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  InkWell(
                    onTap: () => resetControllers({
                      'UID': users[i].uid,
                      'Name': users[i].name,
                      'email': users[i].email,
                      'Accounts Invited': users[i].invitedSharedAccount
                    }),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            users[i].name!,
                            style: TextStyle(
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            users[i].email!,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey,
                  )
                ],
              );
            }));
  }
}
