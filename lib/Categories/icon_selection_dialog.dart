import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class IconSelectionDialog extends StatefulWidget {
  final dynamic selectIcon;
  const IconSelectionDialog(this.selectIcon, {super.key});

  @override
  State<IconSelectionDialog> createState() => _IconSelectionDialogState();
}

class _IconSelectionDialogState extends State<IconSelectionDialog> {
  FixedExtentScrollController scrollController = FixedExtentScrollController();
  Map<String, dynamic> selectedIcon = {};

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.4,
          width: (MediaQuery.of(context).size.width > 650)
              ? MediaQuery.of(context).size.width * 0.35
              : MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(minHeight: 350, minWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Close
              Container(
                alignment: const Alignment(1.0, 0.0),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    iconSize: 20.0),
              ),
              const SizedBox(height: 15),
              //Selection
              Expanded(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: Center(
                    child: CupertinoPicker.builder(
                        scrollController: scrollController,
                        backgroundColor: Colors.transparent,
                        itemExtent: 100,
                        childCount: IconsMap().iconsMap.length,
                        onSelectedItemChanged: (i) {
                          setState(() {
                            selectedIcon = IconsMap().iconsMap[i];
                          });
                        },
                        itemBuilder: ((context, index) {
                          return Center(
                            child: Icon(
                              IconsMap().iconsMap[index]['Icon'],
                              size: 50,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          );
                        })),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              //Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(
                          color: theme.isDarkMode ? Colors.grey : Colors.grey)),
                  onPressed: () {
                    widget.selectIcon(selectedIcon['Index'],
                        selectedIcon['Icon'], selectedIcon['Code']);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                        fontSize: 18,
                        color: theme.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
