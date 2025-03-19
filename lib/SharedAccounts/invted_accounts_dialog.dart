import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

class InvitedAccountsDialog extends StatefulWidget {
  final String uid;
  final List invitedAccounts;
  final ThemeProvider theme;
  const InvitedAccountsDialog(this.uid, this.invitedAccounts, this.theme,
      {super.key});

  @override
  State<InvitedAccountsDialog> createState() => _InvitedAccountsDialogState();
}

class _InvitedAccountsDialogState extends State<InvitedAccountsDialog> {
  List invitedAccounts = [];
  bool loading = false;

  Function startLoading() {
    setState(() {
      loading = true;
    });
    return startLoading;
  }

  Function stopLoading(accountID) {
    invitedAccounts.remove(accountID);
    setState(() {
      loading = false;
    });

    return stopLoading;
  }

  @override
  void initState() {
    invitedAccounts = List.from(widget.invitedAccounts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: 400,
        width: 400,
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Te han invitado a compartir las siguientes cuentas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      indent: 10,
                      endIndent: 10,
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  //Accounts
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: invitedAccounts.length,
                        itemBuilder: (context, i) {
                          return StreamProvider<SharedAccounts?>.value(
                              value: DatabaseService()
                                  .sharedAcct(invitedAccounts[i]),
                              initialData: null,
                              child: SharedAccountCard(widget.uid, widget.theme,
                                  startLoading, stopLoading, invitedAccounts));
                        }),
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

class SharedAccountCard extends StatelessWidget {
  final String uid;
  final ThemeProvider theme;
  final Function startLoading;
  final Function stopLoading;
  final List userInvitedAccounts;
  const SharedAccountCard(this.uid, this.theme, this.startLoading,
      this.stopLoading, this.userInvitedAccounts,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final sharedAcct = Provider.of<SharedAccounts?>(context);
    if (sharedAcct == null) {
      return const SizedBox();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Name and data
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                sharedAcct.accountName!,
                style: TextStyle(
                    fontSize: 14,
                    color: theme.isDarkMode ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 2),
              Text(
                '${sharedAcct.accountType!} / Creada por ${sharedAcct.createdBy!}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        IconButton(
            onPressed: () async {
              startLoading();
              //Add UID to shared accounts list of members
              List<String> newMembersList = List.from(sharedAcct.members!);
              newMembersList.add(uid);
              await DatabaseService()
                  .addUsertoSharedAcct(sharedAcct.accountID!, newMembersList);
              //Remove from pending members}
              List<String> newPendingsList =
                  List.from(sharedAcct.pendingMembers!);
              newPendingsList.remove(uid);
              await DatabaseService().removeUserFromSharedAcct(
                  sharedAcct.accountID!, newPendingsList);
              //Remove account on user profile
              List<String> userAccts = List.from(userInvitedAccounts);
              userAccts.remove(sharedAcct.accountID!);
              await DatabaseService().removeInvitedAcctonUser(uid, userAccts);
              stopLoading(sharedAcct.accountID!);
            },
            icon: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
              size: 21,
            )),
        IconButton(
            onPressed: () async {
              startLoading();
              //Remove from pending members
              List<String> newPendingsList =
                  List.from(sharedAcct.pendingMembers!);
              newPendingsList.remove(uid);
              await DatabaseService().removeUserFromSharedAcct(
                  sharedAcct.accountID!, newPendingsList);
              //Remove account on user profile
              List<String> userAccts = List.from(userInvitedAccounts);
              userAccts.remove(sharedAcct.accountID!);
              await DatabaseService().removeInvitedAcctonUser(uid, userAccts);
              stopLoading(sharedAcct.accountID!);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 21,
            ))
      ],
    );
  }
}
