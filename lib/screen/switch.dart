import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liver_final/controller/login_controller.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/screen/home.dart';
import 'package:liver_final/screen/name.dart';
import 'package:liver_final/screen/outfit.dart';
import 'package:liver_final/service/database.dart';

class SwitchPage extends StatefulWidget {
  @override
  _SwitchPageState createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  final login = Get.put(LoginController());
  final player = Get.put(PlayerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        if(player.outfitDone.value && player.nameDone.value){ //Home
          return HomePage();
        }
        else if(!player.outfitDone.value && !player.nameDone.value){ //Outfit
          return OutfitPage();
        }
        else if(player.outfitDone.value && !player.nameDone.value){ //Name
          return NamePage();
        }
        else{
          return HomePage();
        }
      }),
    );
  }
}
