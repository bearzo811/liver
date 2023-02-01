import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liver_final/constants/image_path.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/service/database.dart';

class NameWidget extends StatefulWidget {
  @override
  _NameWidgetState createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  final player = Get.put(PlayerController());
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF924101),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children:[
              SizedBox(height: 250,),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Stack(
                  children: [
                    Image.asset(NameBackground),
                    Positioned(
                        top: MediaQuery.of(context).size.height*(-80/930),
                        left: MediaQuery.of(context).size.width*(-60/462),
                        child: Container(
                          margin: const EdgeInsets.only(top: 0, left: 30),
                          height:  MediaQuery.of(context).size.height*(250/930),
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Obx(()=>Image.asset(player.backHairImg.value)), //backHair
                              Obx(()=>Image.asset(player.headBodyImg.value)), //headBody
                              Obx(()=>Image.asset(player.earsImg.value)), //ears
                              Obx(()=>Image.asset(player.eyesImg.value)), //eyes
                              Obx(()=>Image.asset(player.foreHairImg.value)), //foreHair
                              Obx(()=>Image.asset(player.pantsImg.value)), //pants
                              Obx(()=>Image.asset(player.clothesImg.value)), //clothes
                              Obx(()=>Image.asset(player.mouthImg.value)), //mouth
                              Obx(()=>Image.asset(player.shoesImg.value)), //shoes
                            ],
                          ),
                        )
                    ),
                    Image.asset(NameWindow),
                    Positioned(
                        top: MediaQuery.of(context).size.height*(60/930),
                        left: MediaQuery.of(context).size.width*(176/462),
                        child: Container(
                          width: MediaQuery.of(context).size.width*(210/462),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(NameTextBar)
                            )
                          ),
                          child: TextField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black,
                            controller: nameController,
                            decoration: InputDecoration(border: InputBorder.none),
                          ),
                        )
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(125/930),
                      left: MediaQuery.of(context).size.width*(180/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(100/930),
                        width: MediaQuery.of(context).size.width*(100/462),
                        child: Stack(
                          children: [
                            Image.asset(NameOkUI),
                            InkWell(
                              onTap: ()async{
                                if(nameController.text.isNotEmpty){
                                  await Database.delExistArmors(emailName: player.emailName.value);
                                  await Database.updateSomething(emailName: player.emailName.value, target: 'PlayerName', data: nameController.text.trim().toString());
                                  await Database.getDataToController(player.emailName.value);
                                  await Database.updateSomething(emailName: player.emailName.value, target: 'NameDone', data: true);
                                }
                              },
                            )
                          ],
                        )
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(125/930),
                      right: MediaQuery.of(context).size.width*(10/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(100/930),
                          width: MediaQuery.of(context).size.width*(100/462),
                          child: Stack(
                            children: [
                              Image.asset(NameBackUI),
                              InkWell(
                                onTap: ()async{
                                  if(nameController.text.isNotEmpty){
                                    await Database.updateSomething(emailName: player.emailName.value, target: 'OutfitDone', data: false);
                                    await Database.getDataToController(player.emailName.value);
                                  }
                                },
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}
