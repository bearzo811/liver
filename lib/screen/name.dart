import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/screen/widgets/name_widget.dart';
import 'package:liver_final/service/database.dart';
import 'package:liver_final/constants/image_path.dart';

class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final player = Get.put(PlayerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NameWidget()
    );
  }
}
