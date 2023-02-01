import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/screen/widgets/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:liver_final/service/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = Get.put(PlayerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeWidget(),
    );
  }
}
