import 'package:flutter/material.dart';
import 'package:mercuri/Backend/auth_service.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/SharedAccounts/invite_account.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String type = 'Gasto';
  List<String> typesList = ['Ingreso', 'Gasto'];
  List<Map> membersList = [];
  bool loading = false;

  Function addToMembersList(user) {
    setState(() {
      membersList.add(user);
    });

    return addToMembersList;
  }

  late Future<String?> uidF;
  String? uid;

  @override
  void initState() {
    AuthService().getcurrentUID().then((v) {
      setState(() {
        uid = v!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

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
          'Crear cuenta compartida',
          style: TextStyle(
              color: theme.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16),
        ),
        actions: [
          Container(
            width: 70,
            color: Colors.transparent,
          )
        ],
      ),
      body: uid == null
          ? const SizedBox()
          : Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        //Name
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            autofocus: false,
                            validator: (value) => (value == null || value == '')
                                ? 'Agrega un título'
                                : null,
                            style: TextStyle(
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16),
                            textAlign: TextAlign.left,
                            cursorColor: Colors.grey,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              label: const Text('Nombre de la cuenta'),
                              focusColor: Colors.black,
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1)),
                            ),
                            onChanged: (value) {
                              setState(() => name = value);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Type
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: DropdownButton(
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 21,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            hint: Text(
                              type,
                              style: TextStyle(
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16),
                            ),
                            items: typesList.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                type = value!.toString();
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Invite people
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Invitar',
                                style: TextStyle(
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16)),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => InviteAccountDialog(
                                          theme,
                                          name,
                                          name,
                                          type,
                                          addToMembersList,
                                          true));
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 21,
                                )),
                          ],
                        ),
                        //Members
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: membersList.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                        child: Text(
                                          membersList[i]['Name']
                                              .toString()
                                              .substring(0, 1),
                                          style: TextStyle(
                                              color: theme.isDarkMode
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
                                          membersList[i]['Name'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                        Text(
                                          membersList[i]['email'],
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                        const Spacer(),
                        //Button
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  String sharedAcctID = '${uid!} - $name';
                                  List<String> uidMembersList = [];
                                  for (var member in membersList) {
                                    uidMembersList.add(member['UID']);
                                    List accts =
                                        List.from(member['Accounts Invited']);
                                    accts.add(sharedAcctID);
                                    DatabaseService().sendShareAcctInvite(
                                        member['UID'], accts);
                                  }

                                  DatabaseService()
                                      .createSharedAcct(
                                          uid.toString(),
                                          sharedAcctID,
                                          name,
                                          type,
                                          uidMembersList)
                                      .then((v) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  'Crear',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            )),
                      ],
                    ),
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
    );
  }
}
