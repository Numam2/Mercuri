import 'package:flutter/material.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  final String uid;
  const Settings(this.uid, {super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool lightMode = true;

  Widget settingsButton(ThemeProvider theme, bool dark) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          side: BorderSide(
              width: (dark & theme.isDarkMode)
                  ? 3
                  : (!dark & !theme.isDarkMode)
                      ? 3
                      : 1,
              color: (theme.isDarkMode && dark)
                  ? Theme.of(context).colorScheme.primary
                  : (!theme.isDarkMode && !dark)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey)),
      onPressed: Provider.of<ThemeProvider>(context, listen: false).toggleTheme,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Icon(
          !dark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
          color: (theme.isDarkMode && dark)
              ? Theme.of(context).colorScheme.primary
              : (!theme.isDarkMode && !dark)
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
          size: 24,
        )),
      ),
    );
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
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Theme Mode
            Text(
              'Visualización',
              style: TextStyle(
                  color: theme.isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Light
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Text
                    settingsButton(theme, false),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Día',
                      style: TextStyle(
                          color:
                              theme.isDarkMode ? Colors.white : Colors.black),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                //Dark
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Text
                    settingsButton(theme, true),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Noche',
                      style: TextStyle(
                          color:
                              theme.isDarkMode ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            //UID
            Text(
              'UID: ${widget.uid}',
              style: TextStyle(
                  fontSize: 12,
                  color: theme.isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
