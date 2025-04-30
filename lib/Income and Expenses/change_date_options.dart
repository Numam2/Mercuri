import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeDateOptions extends StatefulWidget {
  final dynamic changeDate;
  final DateTime selectedDate;
  const ChangeDateOptions(this.changeDate, this.selectedDate, {super.key});

  @override
  State<ChangeDateOptions> createState() => _ChangeDateOptionsState();
}

class _ChangeDateOptionsState extends State<ChangeDateOptions> {
  late DateTime selectedDate;
  List months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  List years = [2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030];
  int changeMonth = 1;
  int changeYear = 2024;

  FixedExtentScrollController monthScrollController =
      FixedExtentScrollController();

  FixedExtentScrollController yearScrollController =
      FixedExtentScrollController();

  @override
  void initState() {
    selectedDate = widget.selectedDate;
    changeMonth = selectedDate.month - 1;
    monthScrollController = FixedExtentScrollController(
      initialItem: changeMonth,
    );
    changeYear = selectedDate.year;
    yearScrollController = FixedExtentScrollController(
      initialItem: years.indexWhere((element) => element == changeYear),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Title
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Selecciona la fecha",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
            thickness: 0.5,
          ),
          const SizedBox(height: 15),
          //Selected date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Month
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Text
                  const Text(
                    "Mes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  //Selected
                  SizedBox(
                    height: 90,
                    width: 175,
                    child: Center(
                      child: CupertinoPicker.builder(
                          scrollController: monthScrollController,
                          backgroundColor: Colors.transparent,
                          itemExtent: 75,
                          childCount: months.length,
                          onSelectedItemChanged: (i) {
                            setState(() {
                              changeMonth = i + 1;
                            });
                          },
                          itemBuilder: ((context, index) {
                            return Center(
                              child: Text(months[index]),
                            );
                          })),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              //Year
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Text
                  const Text(
                    "Año",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  //Selected
                  SizedBox(
                    height: 90,
                    width: 100,
                    child: Center(
                      child: CupertinoPicker.builder(
                          backgroundColor: Colors.transparent,
                          itemExtent: 75,
                          childCount: years.length,
                          scrollController: yearScrollController,
                          onSelectedItemChanged: (i) {
                            setState(() {
                              changeYear = years[i];
                            });
                          },
                          itemBuilder: ((context, index) {
                            return Center(
                              child: Text('${years[index]}'),
                            );
                          })),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      widget.changeDate(changeYear, changeMonth);
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
