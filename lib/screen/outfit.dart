import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/screen/widgets/outfit_widget.dart';

class OutfitPage extends StatefulWidget {
  @override
  _OutfitPageState createState() => _OutfitPageState();
}

class _OutfitPageState extends State<OutfitPage> {
  final player = Get.put(PlayerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OutfitWidget(),
    );
  }
}


