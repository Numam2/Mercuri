import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mercuri/Backend/auth_service.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/home.dart';
import 'package:mercuri/loading.dart';
import 'package:mercuri/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionHome extends StatefulWidget {
  final String uid;
  const SubscriptionHome(this.uid, {super.key});

  @override
  State<SubscriptionHome> createState() => _SubscriptionHomeState();
}

class _SubscriptionHomeState extends State<SubscriptionHome> {
  //Login to revenuecat databases using firestore UID
  Future loginUsertoRC(userID) async {
    LogInResult result = await Purchases.logIn(userID);
    return result;
  }

  Future<bool> isUserSubscribed() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // access latest customerInfo
      if (customerInfo.entitlements.all['pro']!.isActive) {
        // Grant user "pro" access
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      setState(() {
        errorMessage = e.toString();
        showConnectionerror = true;
      });

      return false;
      // Error fetching customer info
    }
  }

  getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        // Display packages for sale
        setState(() {
          monthlyProduct = offerings.current!.monthly!.storeProduct;
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        errorMessage = e.toString();
        showConnectionerror = true;
      });
      // optional error handling
    }
  }

  StoreProduct? monthlyProduct;
  StoreProduct? yearlyProduct;

  bool subscribed = false;

  //Error handling
  Widget reloadPageButton() {
    return OutlinedButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Wrapper())),
        child: const Text(
          'Volver a cargar',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ));
  }

  bool showConnectionerror = false;
  String errorMessage = '';
  String purchaseError = '';

  //Widget Items
  Widget featureItem(IconData icon, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              softWrap: true,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    loginUsertoRC(widget.uid).then((v) async {
      subscribed = await isUserSubscribed();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);

    if (userData == null) {
      return const Loading();
    } else {
      if (userData.freeUser != null && userData.freeUser!) {
        return MultiProvider(providers: [
          StreamProvider<UserData?>.value(
            value: DatabaseService().userData(widget.uid),
            initialData: null,
          ),
        ], child: Home(widget.uid));
      }
      if (showConnectionerror) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Message
                const Icon(
                  Icons.error_outline,
                  size: 45,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ups... Al parecer hubo un error de conexión',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                //Button
                reloadPageButton()
              ],
            ),
          ),
        );
      } else if (subscribed) {
        return MultiProvider(providers: [
          StreamProvider<UserData?>.value(
            value: DatabaseService().userData(widget.uid),
            initialData: null,
          ),
        ], child: Home(widget.uid));
      } else {
        getOfferings();
        if (monthlyProduct == null) {
          return const Loading();
        } else {
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Restore /  Close
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            try {
                              CustomerInfo customerInfo =
                                  await Purchases.restorePurchases();
                              // ... check restored purchaserInfo to see if entitlement is now active
                              if (customerInfo.entitlements.all["pro"] ==
                                  null) {
                                setState(() {
                                  errorMessage =
                                      'No se encontraron compras para recuperar';
                                  showConnectionerror = true;
                                });
                              } else if (customerInfo
                                  .entitlements.all["pro"]!.isActive) {
                                // Unlock that great "pro" content
                                if (context.mounted) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Wrapper();
                                  }));
                                }
                              }
                            } on PlatformException catch (e) {
                              // Error restoring purchases
                              setState(() {
                                errorMessage = e.toString();
                                showConnectionerror = true;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              side: BorderSide(color: Colors.grey.shade300)),
                          child: const Text(
                            'Recuperar',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              AuthService().signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Wrapper()));
                            },
                            icon: const Icon(Icons.close),
                            iconSize: 20.0),
                      ],
                    ),
                    const SizedBox(height: 10),
                    //Logo
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mercuri',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    //Title of paywall
                    const Text(
                      'Empieza tu prueba GRATIS',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Tu aliado para controlar tus finanzas personales',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Divider(
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    //List of features
                    Expanded(
                      child: ListView(
                        children: [
                          //Registra ingresos y gastos
                          featureItem(Icons.account_balance_outlined,
                              'Registra tus ingresos y gastos'),
                          //Presupuestos
                          featureItem(Icons.wallet,
                              'Crea y controla tus presupuestos mensuales'),
                          //Categoriza
                          featureItem(Icons.category,
                              'Organiza tus transacciones con categorías'),
                          //Compartidas
                          featureItem(Icons.share,
                              'Crea cuentas compartidas con otros usuarios'),
                          //Recurrentes
                          featureItem(Icons.timelapse,
                              'Recordatorios de gastos recurrentes'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    //Buttons
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        child: Text(
                          'Después de la prueba gratis de 30 días, la suscripción se renueva automaticamente hasta que la canceles',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ),
                    ),
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
                          try {
                            Offerings offerings =
                                await Purchases.getOfferings();
                            CustomerInfo customerInfo =
                                await Purchases.purchasePackage(
                                    offerings.current!.monthly!);
                            if (customerInfo
                                .entitlements.all["pro"]!.isActive) {
                              // Unlock that great "pro" content
                              if (context.mounted) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const Wrapper();
                                }));
                              }
                            }
                          } on PlatformException catch (e) {
                            var errorCode =
                                PurchasesErrorHelper.getErrorCode(e);
                            if (errorCode !=
                                PurchasesErrorCode.purchaseCancelledError) {
                              setState(() {
                                purchaseError = errorCode.toString();
                              });
                            }
                          }
                        },
                        child: const Text(
                          'Empieza Gratis',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    (purchaseError != '')
                        ? Text(
                            'Ocurrió un error en la compra ($purchaseError)',
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 12),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
  }
}
