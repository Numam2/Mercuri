import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/SharedAccounts/account_user_card.dart';
import 'package:mercuri/SharedAccounts/add_account.dart';
import 'package:mercuri/SharedAccounts/invite_account.dart';
import 'package:mercuri/SharedAccounts/pending_account_users.dart';
import 'package:mercuri/SharedAccounts/shared_account_activity.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

class SharedAccountsPage extends StatelessWidget {
  final String uid;
  final String userName;
  const SharedAccountsPage(this.uid, this.userName, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final sharedAccounts = Provider.of<List<SharedAccounts>?>(context);

    if (sharedAccounts == null || sharedAccounts.isEmpty) {
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Text('No hay cuentas para mostrar'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.isDarkMode ? Colors.white : Colors.black,
            size: 21,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Cuentas compartidas',
          style: TextStyle(
              color: theme.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16),
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AddAccount();
                  })),
              icon: Icon(Icons.add,
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  size: 21)),
        ],
      ),
      body: ListView.builder(
          itemCount: sharedAccounts!.length,
          itemBuilder: (context, i) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: theme.isDarkMode ? Colors.black54 : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    boxShadow: theme.isDarkMode
                        ? []
                        : [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(-5, 5),
                                blurRadius: 20)
                          ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Data
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Name
                          Text(
                            sharedAccounts[i].accountName!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 21),
                          ),
                          const SizedBox(height: 8),
                          //Members
                          SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 5,
                                children: List.generate(
                                    sharedAccounts[i].members!.length, (x) {
                                  //MemberCard
                                  return StreamProvider<UserData?>.value(
                                      value: DatabaseService().userData(
                                          sharedAccounts[i].members![x]),
                                      initialData: null,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5.0, bottom: 5),
                                        child: AccountUserCard(theme),
                                      ));
                                }),
                              )),
                          //To Accept
                          sharedAccounts[i].pendingMembers!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: PendingAccountUsers(
                                      theme, sharedAccounts[i]),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    //Options
                    const SizedBox(width: 5),
                    PopupMenuButton<int>(
                      itemBuilder: (context) {
                        List<PopupMenuItem<int>> items = [];
                        if (sharedAccounts[i].createdBy! == userName) {
                          items = [
                            const PopupMenuItem<int>(
                                value: 0,
                                child: Row(
                                  children: [
                                    Icon(Icons.list,
                                        size: 21, color: Colors.black),
                                    SizedBox(width: 5),
                                    Text(
                                      'Actividad',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                )),
                            const PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.share,
                                        size: 21, color: Colors.black),
                                    SizedBox(width: 5),
                                    Text(
                                      'Invitar',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                )),
                            const PopupMenuItem<int>(
                                value: 3,
                                child: Row(
                                  children: [
                                    Icon(Icons.delete,
                                        size: 21, color: Colors.black),
                                    SizedBox(width: 5),
                                    Text(
                                      'Eliminar para todos',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                ))
                          ];
                        } else {
                          items = [
                            const PopupMenuItem<int>(
                                value: 0,
                                child: Row(
                                  children: [
                                    Icon(Icons.list,
                                        size: 21, color: Colors.black),
                                    SizedBox(width: 5),
                                    Text(
                                      'Actividad',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                )),
                            const PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.share,
                                        size: 21, color: Colors.black),
                                    SizedBox(width: 5),
                                    Text(
                                      'Invitar',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                )),
                            const PopupMenuItem<int>(
                                value: 2,
                                child: Row(
                                  children: [
                                    Icon(Icons.exit_to_app,
                                        size: 21, color: Colors.black),
                                    SizedBox(width: 5),
                                    Text(
                                      'Salir de la cuenta',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                )),
                          ];
                        }

                        return items;
                      },
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SharedAccountActivity(
                                  sharedAccounts[i].accountID!,
                                  sharedAccounts[i].accountName!);
                            }));
                            break;
                          case 1:
                            Function addToMembersList(user) {
                              //Add acct to user list
                              List accts = List.from(user['Accounts Invited']);
                              accts.add(sharedAccounts[i].accountID);
                              //Write to database
                              DatabaseService()
                                  .sendShareAcctInvite(user['UID'], accts);
                              return addToMembersList;
                            }

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return InviteAccountDialog(
                                    theme,
                                    userName,
                                    sharedAccounts[i].accountName!,
                                    sharedAccounts[i].accountType!,
                                    addToMembersList,
                                    false,
                                    sharedAccount: sharedAccounts[i],
                                  );
                                });
                            break;
                          case 2:
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return LeaveSharedAccountDialog(
                                    sharedAccounts[i].accountName!,
                                    theme,
                                    uid,
                                    sharedAccounts[i].accountID!,
                                    sharedAccounts[i].members!,
                                  );
                                });
                            break;
                          case 3:
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteSharedAcctDialog(
                                    sharedAccounts[i].accountName!,
                                    theme,
                                    uid,
                                    sharedAccounts[i],
                                  );
                                });
                            break;
                        }
                      },
                      child: Icon(
                        Icons.more_vert,
                        size: 21,
                        color: theme.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class LeaveSharedAccountDialog extends StatefulWidget {
  final String title;
  final ThemeProvider theme;
  final String uid;
  final String docID;
  final List membersList;
  const LeaveSharedAccountDialog(
      this.title, this.theme, this.uid, this.docID, this.membersList,
      {super.key});

  @override
  State<LeaveSharedAccountDialog> createState() =>
      _LeaveSharedAccountDialogState();
}

class _LeaveSharedAccountDialogState extends State<LeaveSharedAccountDialog> {
  bool loading = false;
  List newMembersList = [];

  @override
  void initState() {
    newMembersList = List.from(widget.membersList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: 200,
        width: 250,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: const Alignment(1.0, 0.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        iconSize: 20.0),
                  ),
                  //Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Salirme de la cuenta: ${widget.title}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.theme.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  //Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                                newMembersList.removeWhere(
                                    (member) => member == widget.uid);
                              });

                              DatabaseService()
                                  .leaveSharedAcct(widget.docID, newMembersList)
                                  .then((v) => Navigator.of(context).pop());
                            },
                            child: const Text(
                              'Salir',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                    color: widget.theme.isDarkMode
                                        ? Colors.grey
                                        : Colors.grey)),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Volver',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: widget.theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
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

////// Delete
class DeleteSharedAcctDialog extends StatefulWidget {
  final String title;
  final ThemeProvider theme;
  final String uid;
  final SharedAccounts sharedAcct;
  const DeleteSharedAcctDialog(
      this.title, this.theme, this.uid, this.sharedAcct,
      {super.key});

  @override
  State<DeleteSharedAcctDialog> createState() => _DeleteSharedAcctDialogState();
}

class _DeleteSharedAcctDialogState extends State<DeleteSharedAcctDialog> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: 200,
        width: 250,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: const Alignment(1.0, 0.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        iconSize: 20.0),
                  ),
                  //Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Eliminar -${widget.title}- como cuenta compartida para todos los miembros",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.theme.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  //Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
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
                              for (var x = 0;
                                  x < widget.sharedAcct.pendingMembers!.length;
                                  x++) {
                                final doc = await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(widget.sharedAcct.pendingMembers![x])
                                    .get();
                                try {
                                  List<String> newList =
                                      List.from(doc['Invited Shared Accounts']);
                                  newList.remove(widget.sharedAcct.accountID);
                                  await DatabaseService()
                                      .removeInvitedAcctonUser(
                                          widget.sharedAcct.pendingMembers![x],
                                          newList);
                                } catch (e) {
                                  //do nothing
                                }
                              }
                              DatabaseService()
                                  .deleteSharedAcct(
                                      widget.sharedAcct.accountID!)
                                  .then((v) {
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text(
                              'Eliminar',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                    color: widget.theme.isDarkMode
                                        ? Colors.grey
                                        : Colors.grey)),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Volver',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: widget.theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
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
