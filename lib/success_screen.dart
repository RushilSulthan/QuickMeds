import 'dart:async';

import 'package:appinterface/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FirstPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.purple,
      child: Center(
        child: Lottie.asset('assets/animations/Sucsses.json'),
      ),
    );
  }
}
