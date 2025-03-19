import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

const List<String> _productIds = ['mercuri_pro', 'mercuri_yearly'];

class SubscriptionHome extends StatefulWidget {
  const SubscriptionHome({super.key});

  @override
  State<SubscriptionHome> createState() => _SubscriptionHomeState();
}

class _SubscriptionHomeState extends State<SubscriptionHome> {
  // final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String notice = 'Nada';

  // Future<void> initStoreInfo() async {
  //   final bool isAvailable = await _inAppPurchase.isAvailable();
  //   setState(() {
  //     _isAvailable = isAvailable;
  //   });

  //   if (!_isAvailable) {
  //     print('not available');
  //     setState(() {
  //       notice = 'Store not available';
  //     });
  //     return;
  //   }
  //   setState(() {
  //     print('available');
  //     notice = 'Store available';
  //   });
  // }

  // @override
  // void initState() {
  //   initStoreInfo();
  //   super.initState();
  // }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  @override
  void initState() {
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        notice = 'not available';
      });
      return;
    } else {
      setState(() {
        _isAvailable = isAvailable;
        notice = '  available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors
              .transparent, //theme.isDarkMode ? Colors.black38 : Colors.white,
          centerTitle: true,
          title: Text(
            'Subscribe',
            style: TextStyle(
                color: theme.isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        body: Center(
            child: Text(
          notice,
          style: const TextStyle(color: Colors.grey),
        )),
      ),
    );
  }
}
