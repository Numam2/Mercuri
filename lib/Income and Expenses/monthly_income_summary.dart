import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Models/stats.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class MonthlyIncomeSummary extends StatelessWidget {
  MonthlyIncomeSummary({super.key});

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<Stats>(context);
    final theme = Provider.of<ThemeProvider>(context);

    if (stats.monthlyIncome! <= 0) {
      return const SizedBox();
    }

    var keys = stats.incomeByCategory!.keys.toList();

    return Column(
      children: [
        //List
        Container(
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
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: keys.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Description/date
                      Expanded(
                        flex: 5,
                        child: Text(
                          stats.incomeByCategory!.keys
                              .firstWhere((element) => element == keys[i]),
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      const SizedBox(width: 10),
                      //Amount
                      Expanded(
                        flex: 5,
                        child: Text(
                          formatCurrency.format(
                            stats.incomeByCategory![keys[i]],
                          ),
                          textAlign: TextAlign.end,
                          style: GoogleFonts.eczar(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 21,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
        const SizedBox(height: 15),
        const Divider(
          color: Colors.grey,
          indent: 20,
          endIndent: 20,
          thickness: 0.5,
        ),
        const SizedBox(height: 15),
        //Total
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Total de ingresos:",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: (theme.isDarkMode) ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              formatCurrency.format(stats.monthlyIncome),
              style: GoogleFonts.eczar(
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.normal),
            ),
          ],
        )
      ],
    );
  }
}
