import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/SharedAccounts/search_users.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

class InviteAccountDialog extends StatefulWidget {
  final ThemeProvider theme;
  final String userName;
  final String name;
  final String type;
  final Function addToMembersList;
  final bool newAcct;
  final SharedAccounts? sharedAccount;
  const InviteAccountDialog(this.theme, this.userName, this.name, this.type,
      this.addToMembersList, this.newAcct,
      {this.sharedAccount, super.key});

  @override
  State<InviteAccountDialog> createState() => _InviteAccountDialogState();
}

class _InviteAccountDialogState extends State<InviteAccountDialog> {
  bool loading = false;
  String searchName = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  List<Map> invitedUsers = [];

  bool _isFocused = false;

  Function resetControllers(user) {
    invitedUsers.add(user);
    setState(() {
      searchName = '';
      searchNode.unfocus();
      searchController.text = '';
    });
    return user;
  }

  @override
  void initState() {
    super.initState();
    searchNode.addListener(() {
      setState(() {
        _isFocused = searchNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: 400,
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Search Name
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      autofocus: false,
                      controller: searchController,
                      focusNode: searchNode,
                      style: TextStyle(
                          color: widget.theme.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16),
                      textAlign: TextAlign.left,
                      cursorColor: Colors.grey,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: widget.theme.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          size: 21,
                        ),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              searchController.text = '';
                              searchNode.unfocus();
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                        hintText: 'Nombre o email',
                        focusColor: Colors.black,
                        border: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1)),
                      ),
                      onTap: () {
                        setState(() {
                          searchNode.requestFocus();
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          searchName = value;
                          searchNode.requestFocus();
                        });
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  _isFocused
                      ? const SizedBox()
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 5,
                                children:
                                    List.generate(invitedUsers.length, (i) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Center(
                                          child: Text(
                                            invitedUsers[i]['Name']
                                                .toString()
                                                .substring(0, 1),
                                            style: TextStyle(
                                                color: widget.theme.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            invitedUsers[i]['Name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: widget.theme.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          Text(
                                            invitedUsers[i]['email'],
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                  _isFocused && searchName.length > 2
                      ? StreamProvider<List<UserData>?>.value(
                          value: DatabaseService()
                              .usersList(searchName.toLowerCase()),
                          initialData: null,
                          child: SearchUsers(resetControllers, widget.theme))
                      : const SizedBox(),
                  //Button
                  _isFocused
                      ? const SizedBox()
                      : SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              for (var x = 0; x < invitedUsers.length; x++) {
                                widget.addToMembersList(invitedUsers[x]);
                              }
                              if (!widget.newAcct) {
                                //Add user to pending list
                                List<String> users = List.from(
                                    widget.sharedAccount!.pendingMembers!);
                                for (var x = 0; x < invitedUsers.length; x++) {
                                  users.add(invitedUsers[x]['UID']);
                                }
                                DatabaseService().inviteSharedAcct(
                                    widget.sharedAccount!.accountID!, users);
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Invitar',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            (loading)
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                    child: const Loading(),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
