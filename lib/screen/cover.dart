import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liver_final/constants/image_path.dart';
import 'package:liver_final/controller/login_controller.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/screen/switch.dart';
import 'package:liver_final/service/database.dart';

class CoverPage extends StatefulWidget {
  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  final login = Get.put(LoginController());
  final player = Get.put(PlayerController());
  final monsterR = Get.put(MonsterRController());
  final monsterB = Get.put(MonsterBController());
  final monsterG = Get.put(MonsterGController());
  @override
  Widget build(BuildContext context) {
    player.refresh();
    return Scaffold(
      body: Obx((){
        if(login.googleAccount.value == null){
          return LoginButton();
        }
        else{
          Database.addUser(login.googleAccount.value?.email.toString());
          Database.getDataToController(login.googleAccount.value?.email.toString());
          monsterR.image.value ='';
          monsterB.image.value ='';
          monsterG.image.value ='';
          player.coin.value=0;
          print(player.emailName.value);
          print('--------${MediaQuery.of(context).size.height},${MediaQuery.of(context).size.width}');
          return SwitchPage();
        }
      })
    );
  }

  Container LoginButton(){
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(CoverBG),
            fit: BoxFit.fill,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height*(190/930),
              left: MediaQuery.of(context).size.width*(90/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(280/930),
                width: MediaQuery.of(context).size.width*(280/462),
                child: Image.asset(LogoUI),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(430/930),
              left: MediaQuery.of(context).size.width*(120/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(460/930),
                width: MediaQuery.of(context).size.width*(460/930),
                child: Stack(
                  children: [
                    Image.asset(LoginUI),
                    InkWell(
                      onTap: (){
                        login.login();
                      },
                    )
                  ],
                )
              )
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(570/930),
              left: MediaQuery.of(context).size.width*(320/462),
              child: Container(
                height: MediaQuery.of(context).size.width*(200/930),
                width: MediaQuery.of(context).size.width*(200/930),
                child: Image.asset(Liver_og),
              ),
            ),
          ],
        )
    );
  }
}

