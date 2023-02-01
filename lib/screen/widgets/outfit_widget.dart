import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liver_final/controller/login_controller.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/constants/image_path.dart';
import 'package:liver_final/constants/set_part.dart';
import 'package:liver_final/service/database.dart';

class OutfitWidget extends StatefulWidget {
  @override
  _OutfitWidgetState createState() => _OutfitWidgetState();
}

class _OutfitWidgetState extends State<OutfitWidget> {
  final login = Get.put(LoginController());
  final player = Get.put(PlayerController());
  PageController _pageController= PageController();
  @override
  void initState(){
    Database.getDataToController(login.googleAccount.value?.email.toString());
  }

  @override
  Widget build(BuildContext context) {
    print('//////////////////////');
    print(player.emailName.value);
    return Scaffold(
      backgroundColor: const Color(0xFF924101),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*(840/930),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(OutfitBackground),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(-55/930),
                      left: MediaQuery.of(context).size.width*(85/462),
                      child: Container(
                        margin: const EdgeInsets.only(top: 0, left: 30),
                        height: MediaQuery.of(context).size.height*(250/930),
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
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(230/930),
                      left: MediaQuery.of(context).size.width*(30/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(550/930),
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                              return Container(
                                child: getPageByIndex(index),
                              );
                            },
                            itemCount: 4,
                            controller: _pageController,
                          )
                      )
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*(820/930),
            right: MediaQuery.of(context).size.width*(140/462),
            child: Container(
              height: MediaQuery.of(context).size.height*(100/930),
              width: MediaQuery.of(context).size.width*(180/462),
              child: IconButton(
                icon: Image.asset(OkUI),
                onPressed: () async{
                  Database.updateSomething(emailName: player.emailName.value, target: 'initBackHairImg', data: player.backHairImg.value);
                  Database.updateSomething(emailName: player.emailName.value, target: 'initHeadBodyImg', data: player.headBodyImg.value);
                  Database.updateSomething(emailName: player.emailName.value, target: 'initEarsImg', data: player.earsImg.value);
                  Database.updateSomething(emailName: player.emailName.value, target: 'initEyesImg', data: player.eyesImg.value);
                  Database.updateSomething(emailName: player.emailName.value, target: 'initForeHairImg', data: player.foreHairImg.value);
                  Database.updateSomething(emailName: player.emailName.value, target: 'initPantsImg', data: player.pantsImg.value);
                  Database.updateSomething(emailName: player.emailName.value, target: 'initClothesImg', data: player.clothesImg.value);
                  Database.updateSomething(emailName: player.emailName.value, target: 'initMouthImg', data: player.mouthImg.value);
                  Database.updateSomething(emailName: player.emailName.value, target: 'initShoesImg', data: player.shoesImg.value);
                  await Database.updateSomething(emailName: player.emailName.value, target: 'OutfitDone', data: true);
                  Database.getDataToController(player.emailName.value);
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*(880/930),
            right: MediaQuery.of(context).size.width*(-5/462),
            child: Container(
              height: MediaQuery.of(context).size.height*(55/930),
              width: MediaQuery.of(context).size.width*(55/462),
              child: IconButton(
                icon: Image.asset(LogoutUI),
                onPressed: () {
                  Get.put(LoginController()).logout();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container getPageByIndex(int index) {
    switch(index){
      case 0:
        return Container(
          child: Stack(
            children: [
              Image.asset(SelectPage0),
              Positioned(
                  top: MediaQuery.of(context).size.width*(23/462),
                  left: MediaQuery.of(context).size.width*(15/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          _pageController.animateToPage(3, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(60/462),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*(213/462),),
                      IconButton(
                        onPressed: (){
                          _pageController.animateToPage(1, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(60/462),
                      )
                    ],
                  )
              ),
              Positioned(
                top: MediaQuery.of(context).size.width*(225/462),
                left: MediaQuery.of(context).size.width*(18/462),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'headBody', data: 0);
                        Database.updateSomething(emailName: player.emailName.value, target: 'HeadBodyImg', data: setHeadBodyImg(color: 0));
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 0);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 0));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_0,),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'headBody', data: 1);
                        Database.updateSomething(emailName: player.emailName.value, target: 'HeadBodyImg', data: setHeadBodyImg(color: 1));
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 1);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 1));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_1,),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'headBody', data: 2);
                        Database.updateSomething(emailName: player.emailName.value, target: 'HeadBodyImg', data: setHeadBodyImg(color: 2));
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 2);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 2));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_2,),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'headBody', data: 3);
                        Database.updateSomething(emailName: player.emailName.value, target: 'HeadBodyImg', data: setHeadBodyImg(color: 3));
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 3);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 3));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_3,),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'headBody', data: 4);
                        Database.updateSomething(emailName: player.emailName.value, target: 'HeadBodyImg', data: setHeadBodyImg(color: 4));
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 4);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 4));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_4,),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width*(340/462),
                  left: MediaQuery.of(context).size.width*(235/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(player.earsType.value==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'earsType', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: 1, color: player.ears.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else{
                            Database.updateSomething(emailName: player.emailName.value, target: 'earsType', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: 0, color: player.ears.value));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      ),
                      IconButton(
                        onPressed: (){
                          if(player.earsType.value==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'earsType', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: 1, color: player.ears.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else{
                            Database.updateSomething(emailName: player.emailName.value, target: 'earsType', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: 0, color: player.ears.value));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      )
                    ],
                  )
              ),
              Positioned(
                top: MediaQuery.of(context).size.width*(440/462),
                left: MediaQuery.of(context).size.width*(18/462),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 0);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 0));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_0),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 1);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 1));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_1),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 2);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 2));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_2),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 3);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 3));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_3),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'ears', data: 4);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: setEarsImg(type: player.earsType.value, color: 4));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(SkinBlock_4),iconSize: MediaQuery.of(context).size.width*(55/462),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 1:
        return Container(
          child: Stack(
            children: [
              Image.asset(SelectPage1),
              Positioned(
                  top: MediaQuery.of(context).size.width*(23/462),
                  left: MediaQuery.of(context).size.width*(15/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          _pageController.animateToPage(0, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(60/462),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*(213/462),),
                      IconButton(
                        onPressed: (){
                          _pageController.animateToPage(2, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(60/462),
                      )
                    ],
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width*(125/462),
                  left: MediaQuery.of(context).size.width*(235/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(player.eyesType.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'eyesType', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: 3, color: player.eyes.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.eyesType.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'eyesType', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: 0, color: player.eyes.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.eyesType.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'eyesType', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: 1, color: player.eyes.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.eyesType.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'eyesType', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: 2, color: player.eyes.value));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      ),
                      IconButton(
                        onPressed: (){
                          if(player.eyesType.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'eyesType', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: 1, color: player.eyes.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.eyesType.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'eyesType', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: 2, color: player.eyes.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.eyesType.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'eyesType', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: 3, color: player.eyes.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.eyesType.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'eyesType', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: 0, color: player.eyes.value));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      )
                    ],
                  )
              ),
              Positioned(
                top: MediaQuery.of(context).size.width*(198/462),
                left: MediaQuery.of(context).size.width*(23/462),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 0);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 0));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_0,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 1);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 1));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_1,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 2);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 2));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_2,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 3);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 3));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_3,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 4);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 4));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_4,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width*(257/462),
                left: MediaQuery.of(context).size.width*(23/462),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 5);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 5));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_5,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 6);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 6));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_6,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 7);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 7));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_7,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 8);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 8));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_8,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'eyes', data: 9);
                        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: setEyesImg(type: player.eyesType.value, color: 9));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(EyesBlock_9,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width*(340/462),
                  left: MediaQuery.of(context).size.width*(235/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(player.mouth.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 4);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 4));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.mouth.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 0));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.mouth.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 1));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.mouth.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 2));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.mouth.value ==4){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 3));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      ),
                      IconButton(
                        onPressed: (){
                          if(player.mouth.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 1));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.mouth.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 2));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.mouth.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 3));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.mouth.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 4);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 4));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.mouth.value ==4){
                            Database.updateSomething(emailName: player.emailName.value, target: 'mouth', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: setMouthImg(type: 0));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      )
                    ],
                  )
              ),
            ],
          ),
        );
      case 2:
        return Container(
          child: Stack(
            children: [
              Image.asset(SelectPage2),
              Positioned(
                  top: MediaQuery.of(context).size.width*(23/462),
                  left: MediaQuery.of(context).size.width*(15/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          _pageController.animateToPage(1, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(60/462),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*(213/462),),
                      IconButton(
                        onPressed: (){
                          _pageController.animateToPage(3, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(60/462),
                      )
                    ],
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width*(125/462),
                  left: MediaQuery.of(context).size.width*(235/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(player.backHairType.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'backHairType', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: 2, color: player.backHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.backHairType.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'backHairType', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: 0, color: player.backHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else{
                            Database.updateSomething(emailName: player.emailName.value, target: 'backHairType', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: 1, color: player.backHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      ),
                      IconButton(
                        onPressed: (){
                          if(player.backHairType.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'backHairType', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: 1, color: player.backHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.backHairType.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'backHairType', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: 2, color: player.backHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else{
                            Database.updateSomething(emailName: player.emailName.value, target: 'backHairType', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: 0, color: player.backHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      )
                    ],
                  )
              ), //backHair Type
              Positioned(
                top: MediaQuery.of(context).size.width*(198/462),
                left: MediaQuery.of(context).size.width*(23/462),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 0);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 0));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_0,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 1);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 1));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_1,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 2);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 2));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_2,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 3);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 3));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_3,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 4);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 4));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_4,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                  ],
                ),
              ), //backHair Color1
              Positioned(
                top: MediaQuery.of(context).size.width*(257/462),
                left: MediaQuery.of(context).size.width*(23/462),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 5);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 5));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_5,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 6);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 6));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_6,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 7);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 7));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_7,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'backHair', data: 8);
                        Database.updateSomething(emailName: player.emailName.value, target: 'BackHairImg', data: setBackHairImg(type: player.backHairType.value, color: 8));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_8,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                  ],
                ),
              ), //backHair Color2
              Positioned(
                  top: MediaQuery.of(context).size.width*(340/462),
                  left: MediaQuery.of(context).size.width*(235/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(player.foreHairType.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'foreHairType', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: 3, color: player.foreHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.foreHairType.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'foreHairType', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: 0, color: player.foreHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.foreHairType.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'foreHairType', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: 1, color: player.foreHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else{
                            Database.updateSomething(emailName: player.emailName.value, target: 'foreHairType', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: 2, color: player.foreHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      ),
                      IconButton(
                        onPressed: (){
                          if(player.foreHairType.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'foreHairType', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: 1, color: player.foreHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.foreHairType.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'foreHairType', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: 2, color: player.foreHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.foreHairType.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'foreHairType', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: 3, color: player.foreHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                          else{
                            Database.updateSomething(emailName: player.emailName.value, target: 'foreHairType', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: 0, color: player.foreHair.value));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      )
                    ],
                  )
              ), //foreHair Type
              Positioned(
                top: MediaQuery.of(context).size.width*(410/462),
                left: MediaQuery.of(context).size.width*(23/462),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 0);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 0));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_0,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 1);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 1));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_1,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 2);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 2));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_2,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 3);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 3));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_3,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 4);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 4));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_4,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                  ],
                ),
              ), //foreHair Color1
              Positioned(
                top: MediaQuery.of(context).size.width*(470/462),
                left: MediaQuery.of(context).size.width*(23/462),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 5);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 5));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_5,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 6);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 6));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_6,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 7);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 7));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_7,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                    IconButton(
                      onPressed: () {
                        Database.updateSomething(emailName: player.emailName.value, target: 'foreHair', data: 8);
                        Database.updateSomething(emailName: player.emailName.value, target: 'ForeHairImg', data: setForeHairImg(type: player.foreHairType.value, color: 8));
                        Database.getDataToController(player.emailName.value);
                      },
                      icon: Image.asset(HairBlock_8,scale: 0.5,),iconSize: MediaQuery.of(context).size.width*(50/462),
                    ),
                  ],
                ),
              ), //foreHair Color2
            ],
          ),
        );
      case 3:
        return Container(
          child: Stack(
            children: [
              Image.asset(SelectPage3),
              Positioned(
                  top: MediaQuery.of(context).size.width*(23/462),
                  left: MediaQuery.of(context).size.width*(15/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          _pageController.animateToPage(2, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(60/462),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*(213/462),),
                      IconButton(
                        onPressed: (){
                          _pageController.animateToPage(0, duration: Duration(milliseconds: 1), curve: Curves.easeOut);
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(60/462),
                      )
                    ],
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width*(125/462),
                  left: MediaQuery.of(context).size.width*(235/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(player.clothes.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 7);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 7));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 0));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 1));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 2));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==4){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 3));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==5){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 4);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 4));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==6){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 5);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 5));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==7){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 6);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 6));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      ),
                      IconButton(
                        onPressed: (){
                          if(player.clothes.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 1));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 2));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 3));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 4);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 4));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==4){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 5);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 5));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==5){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 6);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 6));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==6){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 7);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 7));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.clothes.value ==7){
                            Database.updateSomething(emailName: player.emailName.value, target: 'clothes', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: setClothesImg(color: 0));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      )
                    ],
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width*(238/462),
                  left: MediaQuery.of(context).size.width*(235/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(player.pants.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 11);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 11));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 0));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 1));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 2));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==4){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 3));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==5){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 4);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 4));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==6){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 5);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 5));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==7){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 6);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 6));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==8){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 7);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 7));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==9){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 8);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 8));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==10){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 9);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 9));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==11){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 10);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 10));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      ),
                      IconButton(
                        onPressed: (){
                          if(player.pants.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 1));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 2));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 3));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 4);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 4));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==4){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 5);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 5));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==5){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 6);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 6));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==6){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 7);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 7));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==7){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 8);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 8));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==8){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 9);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 9));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==9){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 10);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 10));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==10){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 11);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 11));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.pants.value ==11){
                            Database.updateSomething(emailName: player.emailName.value, target: 'pants', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: setPantsImg(color: 0));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      )
                    ],
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width*(345/462),
                  left: MediaQuery.of(context).size.width*(235/462),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(player.shoes.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 5);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 5));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 0));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 1));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 2));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==4){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 3));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==5){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 4);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 4));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(PrevButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      ),
                      IconButton(
                        onPressed: (){
                          if(player.shoes.value ==0){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 1);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 1));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==1){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 2);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 2));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==2){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 3);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 3));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==3){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 4);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 4));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==4){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 5);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 5));
                            Database.getDataToController(player.emailName.value);
                          }
                          else if(player.shoes.value ==5){
                            Database.updateSomething(emailName: player.emailName.value, target: 'shoes', data: 0);
                            Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: setShoesImg(color: 0));
                            Database.getDataToController(player.emailName.value);
                          }
                        },
                        icon: Image.asset(NextButtonUI),iconSize: MediaQuery.of(context).size.width*(55/462),
                      )
                    ],
                  )
              ),
            ],
          ),
        );
      default:
        return Container(
          child: Image.asset(SelectPage0),
        );
    }
  }
}

