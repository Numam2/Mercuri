import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/create_transaction.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

class CreateBudget extends StatefulWidget {
  final String uid;
  final String type;
  final List<dynamic> expenseCategories;
  final List? budgetCategories;
  const CreateBudget(
      this.uid, this.type, this.expenseCategories, this.budgetCategories,
      {super.key});

  @override
  State<CreateBudget> createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String category = 'Categoría a presupuestar';
  num amount = 0;
  IconData selectedIcon = Icons.category;
  List budgetCategories = [];
  bool loading = false;

  @override
  void initState() {
    if (widget.budgetCategories != null) {
      budgetCategories = widget.budgetCategories!;
    }
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
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Crear ${widget.type}',
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //Title/Category
                  widget.type == 'Presupuesto'
                      ? SizedBox(
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
                            hint: Row(
                              children: [
                                Icon(
                                  selectedIcon,
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  category,
                                  style: TextStyle(
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            items: widget.expenseCategories.map((item) {
                              var iconIndex = IconsMap()
                                  .iconsMap
                                  .indexWhere((x) => x['Code'] == item['Icon']);
                              return DropdownMenuItem(
                                value: item['Category'],
                                child: Row(
                                  children: [
                                    Icon(
                                      IconsMap().iconsMap[iconIndex]['Icon'],
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['Category'],
                                      style: TextStyle(
                                          color: theme.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                title = value!.toString();
                                category = value.toString();
                              });
                            },
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            autofocus: false,
                            validator: (value) =>
                                (widget.type != 'Presupuesto' &&
                                        (value == null || value == ''))
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
                              label: const Text('Título'),
                              focusColor: Colors.black,
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1)),
                            ),
                            onChanged: (value) {
                              setState(() => title = value);
                            },
                          ),
                        ),
                  const SizedBox(height: 40),
                  //Amount
                  Row(
                    children: [
                      Text(
                        widget.type == 'Presupuesto'
                            ? 'Presupuesto mensual'
                            : 'Monto objetivo',
                        style: TextStyle(
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      autofocus: false,
                      style: GoogleFonts.eczar(
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 45),
                      textAlign: TextAlign.center,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      cursorColor: Colors.grey,
                      inputFormatters: [
                        CurrencyInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText: '\$0.00',
                        hintStyle:
                            GoogleFonts.eczar(color: Colors.grey, fontSize: 45),
                        focusColor: Colors.black,
                        errorStyle: TextStyle(
                            color: Colors.redAccent[700], fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Remove formatting characters (dots and commas)
                        String rawValue = value.replaceAll(RegExp(r'[,]'), '');
                        setState(() {
                          amount = double.parse(rawValue);
                        });
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const Spacer(),
                  //SaveButton
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          DatabaseService()
                              .createBudget(
                                  widget.uid,
                                  DateTime.now().toString(),
                                  DateTime.now(),
                                  widget.type,
                                  title,
                                  amount,
                                  0)
                              .then((val) {
                            if (widget.type == 'Presupuesto') {
                              budgetCategories.add(category);
                              DatabaseService().updateBudgetCategories(
                                  widget.uid, budgetCategories);
                            }
                          }).then((v) => Navigator.of(context).pop());
                        }
                      },
                      child: const Text(
                        'Crear',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
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
