import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Settings/theme.dart';

class AccountDetailsList extends StatelessWidget {
  final ThemeProvider theme;
  final Map<String, dynamic>? transactionsMap;
  AccountDetailsList(this.theme, this.transactionsMap, {super.key});

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    var keys = transactionsMap!.keys.toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: keys.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Item
              Expanded(
                flex: 6,
                child: SizedBox(
                  child: Text(
                    transactionsMap!.keys
                        .firstWhere((element) => element == keys[i]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              //Amount
              Expanded(
                flex: 5,
                child: Text(
                  formatCurrency.format(
                    transactionsMap![keys[i]],
                  ),
                  textAlign: TextAlign.end,
                  style: GoogleFonts.eczar(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
