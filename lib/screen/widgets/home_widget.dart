import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liver_final/constants/image_path.dart';
import 'package:liver_final/controller/login_controller.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/screen/add_interest.dart';
import 'package:liver_final/screen/add_monster.dart';
import 'package:liver_final/service/database.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final player = Get.put(PlayerController());
  final monsterR = Get.put(MonsterRController());
  final monsterB = Get.put(MonsterBController());
  final monsterG = Get.put(MonsterGController());
  final STR_Easy = Get.put(Skill_STR_Easy());
  final STR_Mid = Get.put(Skill_STR_Mid());
  final STR_Hard = Get.put(Skill_STR_Hard());
  final INT_Easy = Get.put(Skill_INT_Easy());
  final INT_Mid = Get.put(Skill_INT_Mid());
  final INT_Hard = Get.put(Skill_INT_Hard());
  final VIT_Easy = Get.put(Skill_VIT_Easy());
  final VIT_Mid = Get.put(Skill_VIT_Mid());
  final VIT_Hard = Get.put(Skill_VIT_Hard());
  final login = Get.put(LoginController());
  PageController _pageController= PageController().obs();
  PageController _monsterPageController= PageController();
  PageController _bagPageController=PageController();
  PageController _shopPageController = PageController();
  PageController _skillPageController = PageController();
  TextEditingController task=TextEditingController();
  TextEditingController _interestNameController = TextEditingController();
  String UpperUIButton = CharacterStatus_Info_Button;
  int nowPageIndex =0;
  DateTime now=DateTime.now();
  RxInt purchase_account =0.obs;
  RxString itemImg1 = NoImg.obs;
  RxString itemImg2 = ''.obs;
  RxString itemImg3 = ''.obs;
  RxInt itemSTR = 0.obs;
  RxInt itemINT = 0.obs;
  RxInt itemVIT = 0.obs;
  RxInt itemMP = 0.obs;
  RxInt itemEXP = 0.obs;
  RxString itemContent =''.obs;
  RxInt itemCoin = 0.obs;
  RxInt itemIndex = 0.obs;
  RxString itemId = ''.obs;
  RxString itemType = ''.obs;
  RxString itemMark = ''.obs;
  RxBool itemOwned = false.obs;
  RxBool itemEquiped = false.obs;
  String nowTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool playerAlive=true;
  double damage=0.0;
  double getExp = 0.0;
  double getCoin = 0.0;
  int nowLV =0;
  int nowMonsterRCount=0;
  int nowMonsterBCount=0;
  int nowMonsterGCount=0;
  Random random = new Random();
  int randomNumber =0;

  String getUpperUIButton(int index){
    if(index!=0){
      return CharacterStatus_Home_Button;
    }
    else{
      return CharacterStatus_Info_Button;
    }
  }

  String getNumberImage(int number){
    switch(number){
      case 0: return Number_0;
      case 1: return Number_1;
      case 2: return Number_2;
      case 3: return Number_3;
      case 4: return Number_4;
      case 5: return Number_5;
      case 6: return Number_6;
      case 7: return Number_7;
      case 8: return Number_8;
      case 9: return Number_9;
      default: return Number_0;
    }
  }

  @override
  Widget build(BuildContext context) {
    player.setHpRatio();
    player.setMpRatio();
    player.setExpRatio();
    Database.getDataToMonsterR(player.emailName.value);
    Database.getDataToMonsterB(player.emailName.value);
    Database.getDataToMonsterG(player.emailName.value);
    monsterR.setHpRatio();
    monsterB.setHpRatio();
    monsterG.setHpRatio();

    Database.getDataToSTR_Easy();
    Database.getDataToSTR_Mid();
    Database.getDataToSTR_Hard();

    Database.getDataToINT_Easy();
    Database.getDataToINT_Mid();
    Database.getDataToINT_Hard();

    Database.getDataToVIT_Easy();
    Database.getDataToVIT_Mid();
    Database.getDataToVIT_Hard();

    //跨日刷新
    if(player.latestDate.value!=nowTime){ //change day
      playerAlive=true;
      Database.addLog(player.emailName.value, nowTime, '', 0, player.LogCount.value);
      player.LogCount.value+=1;
      player.log_date_done.value=true;
      player.latestDate.value=nowTime;
      Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
      Database.updateSomething(emailName: player.emailName.value, target: 'log_date_done', data: player.log_date_done.value);
      Database.updateSomething(emailName: player.emailName.value, target: 'latestDate', data: player.latestDate .value);
      player.mp.value+=(player.maxMp.value-player.mp.value)*0.5;
      Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
      setState(() {

      });
      if(monsterR.image.value!=''){
        print('in');
        if(monsterR.canBeAttack.value && playerAlive){
          if(!STR_Hard.use.value){
            Database.addLog(player.emailName.value, '${player.playerName.value} 受到 ${monsterR.name.value}的攻擊' , '造成了 999 點傷害 玩家死亡', 3 ,player.LogCount.value);
            player.LogCount.value+=1;
            Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
            monsterR.killCount.value+=1;
            Database.updateMonster(emailName: player.emailName.value, type: 'Exercise', target: 'KillCount', data: monsterR.killCount.value);
            if(!INT_Hard.use.value){
              Database.addLog(player.emailName.value, '${player.playerName.value} 損失了' , '${(player.exp.value).toInt()}點經驗，${(player.coin.value*0.5).toInt()}點金幣,${(player.STR.value*0.2).toInt()}點STR值', 3 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              player.exp.value=0;
              player.coin.value*=0.5;
              player.STR.value*=0.8;
              Database.updateSomething(emailName: player.emailName.value, target: 'Exp', data: player.exp.value);
              Database.updateSomething(emailName: player.emailName.value, target: 'Coin', data: player.coin.value);
              Database.updateSomething(emailName: player.emailName.value, target: 'STR', data: player.STR.value);
              player.mp.value=0;
              Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
            }
            else{
              Database.addLog(player.emailName.value, '${player.playerName.value}減免了 死亡懲罰' , '', 1 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              INT_Hard.use.value=false;
              Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard', target: 'Use', data: false);
            }
            playerAlive=false;
          }
          else{
            Database.addLog(player.emailName.value, '${player.playerName.value} 格檔了 ${monsterR.name.value}的攻擊' , '', 1 ,player.LogCount.value);
            player.LogCount.value+=1;
            Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
            STR_Hard.use.value=false;
            Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard', target: 'Use', data: false);
          }
        }
        monsterR.canBeAttack.value = true;
        Database.updateMonster(emailName: player.emailName.value, type: 'Exercise', target: 'CanBeAttack', data: true);
      }
      if(monsterB.image.value!=''){
        print('in');
        if(monsterB.canBeAttack.value && playerAlive){
          if(!STR_Hard.use.value){
            Database.addLog(player.emailName.value, '${player.playerName.value} 受到 ${monsterB.name.value}的攻擊' , '造成了 999 點傷害 玩家死亡', 3 ,player.LogCount.value);
            player.LogCount.value+=1;
            Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
            monsterB.killCount.value+=1;
            Database.updateMonster(emailName: player.emailName.value, type: 'Learning', target: 'KillCount', data: monsterB.killCount.value);
            if(!INT_Hard.use.value){
              Database.addLog(player.emailName.value, '${player.playerName.value} 損失了' , '${(player.exp.value).toInt()}點經驗，${(player.coin.value*0.5).toInt()}點金幣,${(player.INT.value*0.2).toInt()}點INT值', 3 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              player.exp.value=0;
              player.coin.value*=0.5;
              player.INT.value*=0.8;
              Database.updateSomething(emailName: player.emailName.value, target: 'Exp', data: player.exp.value);
              Database.updateSomething(emailName: player.emailName.value, target: 'Coin', data: player.coin.value);
              Database.updateSomething(emailName: player.emailName.value, target: 'INT', data: player.INT.value);
              player.mp.value=0;
              Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
            }
            else{
              Database.addLog(player.emailName.value, '${player.playerName.value}減免了 死亡懲罰' , '', 1 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              INT_Hard.use.value=false;
              Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard', target: 'Use', data: false);
            }
            playerAlive=false;
          }
          else{
            Database.addLog(player.emailName.value, '${player.playerName.value} 格檔了 ${monsterB.name.value}的攻擊' , '', 1 ,player.LogCount.value);
            player.LogCount.value+=1;
            Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
            STR_Hard.use.value=false;
            Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard', target: 'Use', data: false);
          }
        }
        monsterB.canBeAttack.value = true;
        Database.updateMonster(emailName: player.emailName.value, type: 'Learning', target: 'CanBeAttack', data: true);
      }
      if(monsterG.image.value!=''){
        print('in');
        if(monsterG.canBeAttack.value && playerAlive){
          if(!STR_Hard.use.value){
            Database.addLog(player.emailName.value, '${player.playerName.value} 受到 ${monsterG.name.value}的攻擊' , '造成了 999 點傷害 玩家死亡', 3 ,player.LogCount.value);
            player.LogCount.value+=1;
            Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
            monsterG.killCount.value+=1;
            Database.updateMonster(emailName: player.emailName.value, type: 'Life', target: 'KillCount', data: monsterG.killCount.value);
            if(!INT_Hard.use.value){
              Database.addLog(player.emailName.value, '${player.playerName.value} 損失了' , '${(player.exp.value).toInt()}點經驗，${(player.coin.value*0.5).toInt()}點金幣,${(player.VIT.value*0.2).toInt()}點VIT值', 3 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              player.exp.value=0;
              player.coin.value*=0.5;
              player.VIT.value*=0.8;
              Database.updateSomething(emailName: player.emailName.value, target: 'Exp', data: player.exp.value);
              Database.updateSomething(emailName: player.emailName.value, target: 'Coin', data: player.coin.value);
              Database.updateSomething(emailName: player.emailName.value, target: 'VIT', data: player.VIT.value);
              player.mp.value=0;
              Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
            }
            else{
              Database.addLog(player.emailName.value, '${player.playerName.value}減免了 死亡懲罰' , '', 1 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              INT_Hard.use.value=false;
              Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard', target: 'Use', data: false);
            }
            playerAlive=false;
          }
          else{
            Database.addLog(player.emailName.value, '${player.playerName.value} 格檔了 ${monsterG.name.value}的攻擊' , '', 1 ,player.LogCount.value);
            player.LogCount.value+=1;
            Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
            STR_Hard.use.value=false;
            Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard', target: 'Use', data: false);
          }
        }
        monsterG.canBeAttack.value = true;
        Database.updateMonster(emailName: player.emailName.value, type: 'Life', target: 'CanBeAttack', data: true);
      }
    }
    else{ //still same day
      playerAlive=true;
      if(!player.log_date_done.value){
        Database.addLog(player.emailName.value, nowTime, '', 0, player.LogCount.value);
        player.LogCount.value+=1;
        player.log_date_done.value=true;
        player.latestDate.value=nowTime;
        Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
        Database.updateSomething(emailName: player.emailName.value, target: 'log_date_done', data: player.log_date_done.value);
        Database.updateSomething(emailName: player.emailName.value, target: 'latestDate', data: player.latestDate .value);
        player.mp.value+=(player.maxMp.value-player.mp.value)*0.5;
        Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
        setState(() {

        });
        if(monsterR.image.value!=''){
          print('in');
          if(monsterR.canBeAttack.value && playerAlive){
            if(!STR_Hard.use.value){
              Database.addLog(player.emailName.value, '${player.playerName.value} 受到 ${monsterR.name.value}的攻擊' , '造成了 999 點傷害 玩家死亡', 3 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              monsterR.killCount.value+=1;
              Database.updateMonster(emailName: player.emailName.value, type: 'Exercise', target: 'KillCount', data: monsterR.killCount.value);
              if(!INT_Hard.use.value){
                Database.addLog(player.emailName.value, '${player.playerName.value} 損失了' , '${(player.exp.value).toInt()}點經驗，${(player.coin.value*0.5).toInt()}點金幣,${(player.STR.value*0.2).toInt()}點STR值', 3 ,player.LogCount.value);
                player.LogCount.value+=1;
                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                player.exp.value=0;
                player.coin.value*=0.5;
                player.STR.value*=0.8;
                Database.updateSomething(emailName: player.emailName.value, target: 'Exp', data: player.exp.value);
                Database.updateSomething(emailName: player.emailName.value, target: 'Coin', data: player.coin.value);
                Database.updateSomething(emailName: player.emailName.value, target: 'STR', data: player.STR.value);
                player.mp.value=0;
                Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
              }
              else{
                Database.addLog(player.emailName.value, '${player.playerName.value}減免了 死亡懲罰' , '', 1 ,player.LogCount.value);
                player.LogCount.value+=1;
                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                INT_Hard.use.value=false;
                Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard', target: 'Use', data: false);
              }
              playerAlive=false;
            }
            else{
              Database.addLog(player.emailName.value, '${player.playerName.value} 格檔了 ${monsterR.name.value}的攻擊' , '', 1 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              STR_Hard.use.value=false;
              Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard', target: 'Use', data: false);
            }
          }
          monsterR.canBeAttack.value = true;
          Database.updateMonster(emailName: player.emailName.value, type: 'Exercise', target: 'CanBeAttack', data: true);
        }
        if(monsterB.image.value!=''){
          print('in');
          if(monsterB.canBeAttack.value && playerAlive){
            if(!STR_Hard.use.value){
              Database.addLog(player.emailName.value, '${player.playerName.value} 受到 ${monsterB.name.value}的攻擊' , '造成了 999 點傷害 玩家死亡', 3 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              monsterB.killCount.value+=1;
              Database.updateMonster(emailName: player.emailName.value, type: 'Learning', target: 'KillCount', data: monsterB.killCount.value);
              if(!INT_Hard.use.value){
                Database.addLog(player.emailName.value, '${player.playerName.value} 損失了' , '${(player.exp.value).toInt()}點經驗，${(player.coin.value*0.5).toInt()}點金幣,${(player.INT.value*0.2).toInt()}點INT值', 3 ,player.LogCount.value);
                player.LogCount.value+=1;
                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                player.exp.value=0;
                player.coin.value*=0.5;
                player.INT.value*=0.8;
                Database.updateSomething(emailName: player.emailName.value, target: 'Exp', data: player.exp.value);
                Database.updateSomething(emailName: player.emailName.value, target: 'Coin', data: player.coin.value);
                Database.updateSomething(emailName: player.emailName.value, target: 'INT', data: player.INT.value);
                player.mp.value=0;
                Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
              }
              else{
                Database.addLog(player.emailName.value, '${player.playerName.value}減免了 死亡懲罰' , '', 1 ,player.LogCount.value);
                player.LogCount.value+=1;
                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                INT_Hard.use.value=false;
                Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard', target: 'Use', data: false);
              }
              playerAlive=false;
            }
            else{
              Database.addLog(player.emailName.value, '${player.playerName.value} 格檔了 ${monsterB.name.value}的攻擊' , '', 1 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              STR_Hard.use.value=false;
              Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard', target: 'Use', data: false);

            }
          }
          monsterB.canBeAttack.value = true;
          Database.updateMonster(emailName: player.emailName.value, type: 'Learning', target: 'CanBeAttack', data: true);
        }
        if(monsterG.image.value!=''){
          print('in');
          if(monsterG.canBeAttack.value && playerAlive){
            if(!STR_Hard.use.value){
              Database.addLog(player.emailName.value, '${player.playerName.value} 受到 ${monsterG.name.value}的攻擊' , '造成了 999 點傷害 玩家死亡', 3 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              monsterG.killCount.value+=1;
              Database.updateMonster(emailName: player.emailName.value, type: 'Life', target: 'KillCount', data: monsterG.killCount.value);
              if(!INT_Hard.use.value){
                Database.addLog(player.emailName.value, '${player.playerName.value} 損失了' , '${(player.exp.value).toInt()}點經驗，${(player.coin.value*0.5).toInt()}點金幣,${(player.VIT.value*0.2).toInt()}點VIT值', 3 ,player.LogCount.value);
                player.LogCount.value+=1;
                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                player.exp.value=0;
                player.coin.value*=0.5;
                player.VIT.value*=0.8;
                Database.updateSomething(emailName: player.emailName.value, target: 'Exp', data: player.exp.value);
                Database.updateSomething(emailName: player.emailName.value, target: 'Coin', data: player.coin.value);
                Database.updateSomething(emailName: player.emailName.value, target: 'VIT', data: player.VIT.value);
                player.mp.value=0;
                Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
              }
              else{
                Database.addLog(player.emailName.value, '${player.playerName.value}減免了 死亡懲罰' , '', 1 ,player.LogCount.value);
                player.LogCount.value+=1;
                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                INT_Hard.use.value=false;
                Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard', target: 'Use', data: false);

              }
              playerAlive=false;
            }
            else{
              Database.addLog(player.emailName.value, '${player.playerName.value} 格檔了 ${monsterG.name.value}的攻擊' , '', 1 ,player.LogCount.value);
              player.LogCount.value+=1;
              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
              STR_Hard.use.value=false;
              Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard', target: 'Use', data: false);

            }
          }
          monsterG.canBeAttack.value = true;
          Database.updateMonster(emailName: player.emailName.value, type: 'Life', target: 'CanBeAttack', data: true);
        }
        
      }
    }

    Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {});
    });

    return Scaffold(
        backgroundColor: const Color(0xFFaa5410),
        resizeToAvoidBottomInset:false,
        body: Column(
          children: [
            const SizedBox(
              height: 28,
            ),
            Container(
              child: Stack(
                children: [
                  Image.asset(CharacterStatus_BG),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(-55/930),
                    left: MediaQuery.of(context).size.width*(-25/462),
                    child: Container(
                      margin: const EdgeInsets.only(top: 0, left: 30),
                      height:  MediaQuery.of(context).size.height*(200/930),
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Obx(()=>Image.asset(player.backHairImg.value)), //backHair
                          Obx(()=>Image.asset(player.backItemImg.value)),
                          Obx(()=>Image.asset(player.headBodyImg.value)), //headBody
                          Obx(()=>Image.asset(player.earsImg.value)), //ears
                          Obx(()=>Image.asset(player.eyesImg.value)), //eyes
                          Obx(()=>Image.asset(player.eyeDecorationImg.value)),
                          Obx(()=>Image.asset(player.foreHairImg.value)), //foreHair
                          Obx(()=>Image.asset(player.pantsImg.value)), //pants
                          Obx(()=>Image.asset(player.clothesImg.value)), //clothes
                          Obx(()=>Image.asset(player.mouthImg.value)), //mouth
                          Obx(()=>Image.asset(player.shoesImg.value)), //shoes
                        ],
                      ),
                    ),
                  ),
                  Image.asset(CharacterStatus_UI),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(125/930),
                    left: MediaQuery.of(context).size.width*(38/462),
                    child: Image.asset(CharacterStatus_NameMid),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(123/930),
                    left: MediaQuery.of(context).size.width*(52/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(30/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: Center(
                        child: Text(player.playerName.value,textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(10/930),
                    left: MediaQuery.of(context).size.width*(200/462),
                    child: Image.asset(CharacterStatus_LV_Text,scale: 1.5,),
                  ),
                  Positioned(
                    //十分位
                    top: MediaQuery.of(context).size.height*(8/930),
                    left: MediaQuery.of(context).size.width*(345/462),
                    child: Image.asset(getNumberImage(player.lv.value~/10),height: MediaQuery.of(context).size.height*(30/930),width: MediaQuery.of(context).size.width*(30/462),),
                  ),
                  Positioned(
                    //個位
                    top: MediaQuery.of(context).size.height*(8/930),
                    left: MediaQuery.of(context).size.width*(370/462),
                    child: Image.asset(getNumberImage(player.lv.value%10),height: MediaQuery.of(context).size.height*(30/930),width: MediaQuery.of(context).size.width*(30/462),),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(48/930),
                    left: MediaQuery.of(context).size.width*(200/462),
                    child: Image.asset(CharacterStatus_MP_Text,scale: 1.5,),
                  ),
                  // MP BAR
                  Positioned(
                    top: MediaQuery.of(context).size.height*(43/930),
                    left: MediaQuery.of(context).size.width*(260/462),
                    child: Image.asset(CharacterStatus_MP_BarGroove),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(52/930),
                    left: MediaQuery.of(context).size.width*(264/462),
                    child: Image.asset(CharacterStatus_MP_BarBegin),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(50/930),
                      left: MediaQuery.of(context).size.width*(269/462),
                      child: SizedBox(
                        height: 14,
                        width: 120,
                        child: LinearProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF00AEFF)),
                          backgroundColor: const Color(0xFF005292),
                          value: player.mpRatio.value,
                        ),
                      )
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(47/930),
                      left: MediaQuery.of(context).size.width*(269/462),
                      child: SizedBox(
                        height: 3,
                        width: 120,
                        child: LinearProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF75D3FF)),
                          backgroundColor: const Color(0xFF005292),
                          value: player.mpRatio.value,
                        ),
                      )
                  ),
                  //
                  Positioned(
                    top: MediaQuery.of(context).size.height*(85/930),
                    left: MediaQuery.of(context).size.width*(200/462),
                    child: Image.asset(CharacterStatus_EXP_Text,scale: 1.5,),
                  ),
                  // EXP BAR
                  Positioned(
                    top: MediaQuery.of(context).size.height*(82/930),
                    left: MediaQuery.of(context).size.width*(260/462),
                    child: Image.asset(CharacterStatus_EXP_BarGroove),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(91/930),
                    left: MediaQuery.of(context).size.width*(264/462),
                    child: Image.asset(CharacterStatus_EXP_BarBegin),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(88/930),
                      left: MediaQuery.of(context).size.width*(268/462),
                      child: SizedBox(
                        height: 14,
                        width: 120,
                        child: LinearProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF13FF00)),
                          backgroundColor: const Color(0xFF009000),
                          value: player.expRatio.value,
                        ),
                      )
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(85/930),
                      left: MediaQuery.of(context).size.width*(268/462),
                      child: SizedBox(
                        height: 3,
                        width: 120,
                        child: LinearProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation(Color(0xFFACFFA5)),
                          backgroundColor: const Color(0xFF009000),
                          value: player.expRatio.value,
                        ),
                      )
                  ),
                  //
                  Positioned(
                    top: MediaQuery.of(context).size.height*(120/930),
                    left: MediaQuery.of(context).size.width*(200/462),
                    child: Image.asset(CharacterStatus_Coin,scale: 1.5,),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(120/930),
                    left: MediaQuery.of(context).size.width*(270/462),
                    child: Image.asset(getNumberImage(player.coin.value~/10000%10),height: MediaQuery.of(context).size.height*(30/930),width: MediaQuery.of(context).size.width*(30/462),),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(120/930),
                    left: MediaQuery.of(context).size.width*(295/462),
                    child: Image.asset(getNumberImage(player.coin.value~/1000%10),height: MediaQuery.of(context).size.height*(30/930),width: MediaQuery.of(context).size.width*(30/462),),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(120/930),
                    left: MediaQuery.of(context).size.width*(320/462),
                    child: Image.asset(getNumberImage(player.coin.value~/100%10),height: MediaQuery.of(context).size.height*(30/930),width: MediaQuery.of(context).size.width*(30/462),),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(120/930),
                    left: MediaQuery.of(context).size.width*(345/462),
                    child: Image.asset(getNumberImage(player.coin.value~/10%10),height: MediaQuery.of(context).size.height*(30/930),width: MediaQuery.of(context).size.width*(30/462),),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(120/930),
                    left: MediaQuery.of(context).size.width*(370/462),
                    child: Image.asset(getNumberImage(player.coin.value.toInt()%10),height: MediaQuery.of(context).size.height*(30/930),width: MediaQuery.of(context).size.width*(30/462),),
                  ),
                  //
                  Positioned(
                    top: MediaQuery.of(context).size.height*(105/930),
                    left: MediaQuery.of(context).size.width*(410/462),
                    child: Container(
                        height: MediaQuery.of(context).size.height*(60/930),
                        width: MediaQuery.of(context).size.width*(60/462),
                        child: Stack(
                          children: [
                            Image.asset(UpperUIButton,scale: 1.2,),
                            InkWell(
                              onTap: (){
                                if(UpperUIButton==CharacterStatus_Home_Button){
                                  _pageController.jumpToPage(0);
                                }
                                else{
                                  _pageController.jumpToPage(5);
                                }
                              },
                            ),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height-28)*(730/930)+24,
              color: Colors.black12,
              child: Stack(
                children: [
                  PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      return Container(
                        child: getPageByIndex(index),
                      );
                    },
                    itemCount: 8,
                    controller: _pageController,
                    onPageChanged: (int index){
                      setState(() {
                        UpperUIButton=getUpperUIButton(index);
                      });
                    },
                  ),
                ],
              )
            ),
          ],
        )
    );
  }

  Container getPageByIndex(int index) { // 0: battle 1: interest 2:skill 3:shop 4:log 5:status 6:bag 7: achievement
    switch(index){
      //0 battle
      case 0 : return Container(
        child: Stack(
          children: [
            PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                return Container(
                  child: monsterPage(index),
                );
              },
              itemCount: 3,
              controller: _monsterPageController,
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(270/930),
                left: MediaQuery.of(context).size.width*(-10/462),
                child: Container(
                  height: MediaQuery.of(context).size.height*(130/930),
                  width: MediaQuery.of(context).size.width*(130/462),
                  child: IconButton(
                    icon: Image.asset(Battle_Left_Arrow,scale: 1.4,),
                    onPressed: (){
                      if(_monsterPageController.page==0){
                        _monsterPageController.jumpToPage(2);
                      }
                      else if(_monsterPageController.page==1){
                        _monsterPageController.jumpToPage(0);
                      }
                      else if(_monsterPageController.page==2){
                        _monsterPageController.jumpToPage(1);
                      }
                    },
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(270/930),
                left: MediaQuery.of(context).size.width*(340/462),
                child: Container(
                  height: MediaQuery.of(context).size.height*(130/930),
                  width: MediaQuery.of(context).size.width*(130/462),
                  child: IconButton(
                    icon: Image.asset(Battle_Right_Arrow,scale: 1.4,),
                    onPressed: (){
                      if(_monsterPageController.page==0){
                        _monsterPageController.jumpToPage(1);
                      }
                      else if(_monsterPageController.page==1){
                        _monsterPageController.jumpToPage(2);
                      }
                      else if(_monsterPageController.page==2){
                        _monsterPageController.jumpToPage(0);
                      }
                    },
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(630/930),
                left: MediaQuery.of(context).size.width*(370/462),
                child: Container(
                  height: MediaQuery.of(context).size.height*(80/930),
                  width: MediaQuery.of(context).size.width*(80/462),
                  child: IconButton(
                    icon: Image.asset(Menu_Button,scale: 1.4,),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  Image.asset(Menu_UI),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(98/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Battle,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(0);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(178/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Train,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(1);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(258/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Skill,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(2);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(338/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Shop,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(3);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(418/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Log,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(4);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(498/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Logout,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  login.logout();
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                )
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(5/930),
              left: MediaQuery.of(context).size.width*(5/462),
              child: Obx(()=>getSTR_Easy()),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(5/930),
              left: MediaQuery.of(context).size.width*(60/462),
              child: Obx(()=>getSTR_Mid()),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(5/930),
              left: MediaQuery.of(context).size.width*(115/462),
              child: Obx(()=>getSTR_Hard()),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(60/930),
              left: MediaQuery.of(context).size.width*(5/462),
              child: Obx(()=>getINT_Easy()),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(60/930),
              left: MediaQuery.of(context).size.width*(60/462),
              child: Obx(()=>getINT_Mid()),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(60/930),
              left: MediaQuery.of(context).size.width*(115/462),
              child: Obx(()=>getINT_Hard()),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(115/930),
              left: MediaQuery.of(context).size.width*(5/462),
              child: Obx(()=>getVIT_Easy()),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(115/930),
              left: MediaQuery.of(context).size.width*(60/462),
              child: Obx(()=>getVIT_Mid()),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(115/930),
              left: MediaQuery.of(context).size.width*(115/462),
              child: Obx(()=>getVIT_Hard()),
            ),
          ],
        ),
      );
      //1 train
      case 1 : return Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height-28)*(730/930)+24,
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Container(
                height: MediaQuery.of(context).size.height*(705/930),
                width: MediaQuery.of(context).size.width,
                child: Stack(
                    children: [
                      Image.asset(Train_UI),
                      Positioned(
                        top: MediaQuery.of(context).size.height*(10/930),
                        left: MediaQuery.of(context).size.width*(330/462),
                        child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Stack(
                            children: [
                              Image.asset(Train_Add_Button),
                              InkWell(
                                onTap: (){
                                  Get.to(AddInterest());
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('train').snapshots(),
                        builder: (context,snapshot){
                          if(!snapshot.hasData) return LinearProgressIndicator();
                          return Positioned(
                            top: MediaQuery.of(context).size.height*(65/930),
                            left: MediaQuery.of(context).size.width*(40/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(455/930),
                              width: MediaQuery.of(context).size.width*(420/462),
                              child: ListView.separated(
                                separatorBuilder: (context,index){
                                  return SizedBox(height: 10,);
                                },
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context,index){
                                  final doc=snapshot.data!.docs[index];
                                  return Container(
                                    height: MediaQuery.of(context).size.height*(80/930),
                                    width: MediaQuery.of(context).size.width*(400/462),
                                    child: Stack(
                                      children: [
                                        Image.asset(Train_Item_UI),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(12/930),
                                            left: MediaQuery.of(context).size.width*(10/462),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height*(50/930),
                                            width: MediaQuery.of(context).size.width*(180/462),
                                            child: AutoSizeText(doc['TrainName'],textAlign:TextAlign.center,style: TextStyle(
                                              color: Color(0xffe3a16d),
                                              fontFamily: 'DotGothic16',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 25,
                                            ),maxLines: 1,),
                                          )
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context).size.height*(15/930),
                                          left: MediaQuery.of(context).size.width*(202/462),
                                          child: getAttribute(doc['Attribute']),
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context).size.height*(16/930),
                                          left: MediaQuery.of(context).size.width*(272/462),
                                          child: Container(
                                              height: MediaQuery.of(context).size.height*(50/930),
                                              width: MediaQuery.of(context).size.width*(50/462),
                                            child: AutoSizeText(doc['Counter'].toString(),textAlign:TextAlign.center,style: TextStyle(
                                              color: Color(0xff5e0e00),
                                              fontFamily: 'DotGothic16',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 27,
                                            ),)
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            if(doc['Counter']<=10){
                                              if(!INT_Easy.use.value){
                                                getExp=doc['Exp'].toDouble();
                                              }
                                              else{
                                                getExp=doc['Exp'].toDouble()*(1+(INT_Easy.value.value/100));
                                                INT_Easy.use.value=false;
                                                Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Easy', target: 'Use', data: false);
                                              }
                                              if(!VIT_Easy.use.value){
                                                getCoin=doc['Coin'].toDouble();
                                              }
                                              else{
                                                getCoin=doc['Coin'].toDouble()*(1+(INT_Easy.value.value/100));
                                                VIT_Easy.use.value=false;
                                                Database.updateSkill(emailName: player.emailName.value, skillName: 'VIT-Easy', target: 'Use', data: false);
                                              }
                                              if(doc['Attribute']==0){
                                                player.STR.value=player.STR.value+0.5;
                                                Database.updateSomething(emailName: player.emailName.value, target: 'STR', data: player.STR.value);
                                                Database.addLog(player.emailName.value, '${player.playerName.value} 完成了 ${doc['TrainName'].toString()} ' , '獲得 EXP:${(getExp).toInt()}、Coin:${(getCoin).toInt()}、STR:0.5點', 2 ,player.LogCount.value);
                                                player.LogCount.value+=1;
                                                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                                              }
                                              else if(doc['Attribute']==1){
                                                player.INT.value=player.INT.value+0.5;
                                                Database.updateSomething(emailName: player.emailName.value, target: 'INT', data: player.INT.value);
                                                Database.addLog(player.emailName.value, '${player.playerName.value} 完成了 ${doc['TrainName'].toString()} ' , '獲得 EXP:${(getExp).toInt()}、Coin:${(getCoin).toInt()}、INT:0.5點', 2 ,player.LogCount.value);
                                                player.LogCount.value+=1;
                                                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                                              }
                                              else if(doc['Attribute']==2){
                                                player.VIT.value=player.VIT.value+0.5;
                                                Database.updateSomething(emailName: player.emailName.value, target: 'VIT', data: player.VIT.value);
                                                Database.addLog(player.emailName.value, '${player.playerName.value} 完成了 ${doc['TrainName'].toString()} ' , '獲得 EXP:${(getExp).toInt()}、Coin:${(getCoin).toInt()}、VIT:0.5點', 2 ,player.LogCount.value);
                                                player.LogCount.value+=1;
                                                Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);
                                              }
                                              Database.addCounter(emailName: player.emailName.value, docId: doc.id, nowCounter: doc['Counter']);
                                              nowLV=player.lv.value;
                                              player.playergetEXPCoin(getCoin, getExp);
                                              if(player.lv.value>=10 && nowLV<10){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return Dialog(
                                                        backgroundColor: Colors.transparent,
                                                        child: Stack(
                                                          children: [
                                                            Image.asset(Achievement_window),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(50/930),
                                                              left: MediaQuery.of(context).size.width*(30/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(150/930),
                                                                width: MediaQuery.of(context).size.width*(330/462),
                                                                child: AutoSizeText('已完成 達成十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                                                  fontFamily: 'DotGothic16',
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 23,
                                                                  color: Color(0xffe3a06d),
                                                                ),),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(165/930),
                                                              left: MediaQuery.of(context).size.width*(290/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(80/930),
                                                                width: MediaQuery.of(context).size.width*(80/462),
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(Achievement_ok_Button),
                                                                    InkWell(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }
                                              if(player.lv.value>=20 && nowLV<20){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return Dialog(
                                                        backgroundColor: Colors.transparent,
                                                        child: Stack(
                                                          children: [
                                                            Image.asset(Achievement_window),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(50/930),
                                                              left: MediaQuery.of(context).size.width*(30/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(150/930),
                                                                width: MediaQuery.of(context).size.width*(330/462),
                                                                child: Text('已完成 達成二十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                                                  fontFamily: 'DotGothic16',
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 23,
                                                                  color: Color(0xffe3a06d),
                                                                ),),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(165/930),
                                                              left: MediaQuery.of(context).size.width*(290/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(80/930),
                                                                width: MediaQuery.of(context).size.width*(80/462),
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(Achievement_ok_Button),
                                                                    InkWell(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }
                                              setState(() {
                                              });
                                            }
                                            if(doc['Counter']<30 && doc['Counter']>10){
                                              if(!INT_Easy.use.value){
                                                getExp=doc['Exp'].toDouble();
                                              }
                                              else{
                                                getExp=doc['Exp'].toDouble()*(1+(INT_Easy.value.value/100));
                                                INT_Easy.use.value=false;
                                                Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Easy', target: 'Use', data: false);
                                              }
                                              if(!VIT_Easy.use.value){
                                                getCoin=doc['Coin'].toDouble();
                                              }
                                              else{
                                                getCoin=doc['Coin'].toDouble()*(1+(INT_Easy.value.value/100));
                                                VIT_Easy.use.value=false;
                                                Database.updateSkill(emailName: player.emailName.value, skillName: 'VIT-Easy', target: 'Use', data: false);
                                              }

                                              Database.addLog(player.emailName.value, '${player.playerName.value} 完成了 ${doc['TrainName'].toString()} ' , '獲得 EXP: ${(getExp).toInt()}、Coin: ${(getCoin).toInt()}', 2 ,player.LogCount.value);
                                              player.LogCount.value+=1;
                                              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);

                                              Database.addCounter(emailName: player.emailName.value, docId: doc.id, nowCounter: doc['Counter']);
                                              nowLV=player.lv.value;
                                              player.playergetEXPCoin(getCoin, getExp);
                                              if(player.lv.value>=10 && nowLV<10){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return Dialog(
                                                        backgroundColor: Colors.transparent,
                                                        child: Stack(
                                                          children: [
                                                            Image.asset(Achievement_window),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(50/930),
                                                              left: MediaQuery.of(context).size.width*(30/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(150/930),
                                                                width: MediaQuery.of(context).size.width*(330/462),
                                                                child: Text('已完成 達成十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                                                  fontFamily: 'DotGothic16',
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 23,
                                                                  color: Color(0xffe3a06d),
                                                                ),),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(165/930),
                                                              left: MediaQuery.of(context).size.width*(290/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(80/930),
                                                                width: MediaQuery.of(context).size.width*(80/462),
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(Achievement_ok_Button),
                                                                    InkWell(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }
                                              if(player.lv.value>=20 && nowLV<20){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return Dialog(
                                                        backgroundColor: Colors.transparent,
                                                        child: Stack(
                                                          children: [
                                                            Image.asset(Achievement_window),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(50/930),
                                                              left: MediaQuery.of(context).size.width*(30/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(150/930),
                                                                width: MediaQuery.of(context).size.width*(330/462),
                                                                child: Text('已完成 達成二十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                                                  fontFamily: 'DotGothic16',
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 23,
                                                                  color: Color(0xffe3a06d),
                                                                ),),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(165/930),
                                                              left: MediaQuery.of(context).size.width*(290/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(80/930),
                                                                width: MediaQuery.of(context).size.width*(80/462),
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(Achievement_ok_Button),
                                                                    InkWell(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }
                                              setState(() {
                                              });
                                            }
                                            if(doc['Counter']>=30){
                                              if(!VIT_Easy.use.value){
                                                getCoin=doc['Coin'].toDouble();
                                              }
                                              else{
                                                getCoin=doc['Coin'].toDouble()*(1+(INT_Easy.value.value/100));
                                                VIT_Easy.use.value=false;
                                                Database.updateSkill(emailName: player.emailName.value, skillName: 'VIT-Easy', target: 'Use', data: false);
                                              }

                                              Database.addLog(player.emailName.value, '${player.playerName.value} 完成了 ${doc['TrainName'].toString()} ' , '獲得 Coin: ${(getCoin).toInt()}', 2 ,player.LogCount.value);
                                              player.LogCount.value+=1;
                                              Database.updateSomething(emailName: player.emailName.value, target: 'LogCount', data: player.LogCount.value);

                                              Database.addCounter(emailName: player.emailName.value, docId: doc.id, nowCounter: doc['Counter']);
                                              nowLV=player.lv.value;
                                              player.playergetEXPCoin(getCoin, 0);
                                              if(player.lv.value>=10 && nowLV<10){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return Dialog(
                                                        backgroundColor: Colors.transparent,
                                                        child: Stack(
                                                          children: [
                                                            Image.asset(Achievement_window),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(50/930),
                                                              left: MediaQuery.of(context).size.width*(30/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(150/930),
                                                                width: MediaQuery.of(context).size.width*(330/462),
                                                                child: Text('已完成 達成十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                                                  fontFamily: 'DotGothic16',
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 23,
                                                                  color: Color(0xffe3a06d),
                                                                ),),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(165/930),
                                                              left: MediaQuery.of(context).size.width*(290/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(80/930),
                                                                width: MediaQuery.of(context).size.width*(80/462),
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(Achievement_ok_Button),
                                                                    InkWell(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }
                                              if(player.lv.value>=20 && nowLV<20){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return Dialog(
                                                        backgroundColor: Colors.transparent,
                                                        child: Stack(
                                                          children: [
                                                            Image.asset(Achievement_window),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(50/930),
                                                              left: MediaQuery.of(context).size.width*(30/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(150/930),
                                                                width: MediaQuery.of(context).size.width*(330/462),
                                                                child: Text('已完成 達成二十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                                                  fontFamily: 'DotGothic16',
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 23,
                                                                  color: Color(0xffe3a06d),
                                                                ),),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: MediaQuery.of(context).size.height*(165/930),
                                                              left: MediaQuery.of(context).size.width*(290/462),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height*(80/930),
                                                                width: MediaQuery.of(context).size.width*(80/462),
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(Achievement_ok_Button),
                                                                    InkWell(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }
                                              setState(() {
                                              });
                                            }

                                          },
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context).size.height*(15/930),
                                          left: MediaQuery.of(context).size.width*(325/462),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height*(50/930),
                                            width: MediaQuery.of(context).size.width*(50/462),
                                            child: Stack(
                                              children: [
                                                Image.asset(Train_Item_Delete_Button),
                                                InkWell(
                                                  onTap: (){
                                                    Database.delTrain(player.emailName.value, doc.id);
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height*(603/930),
                          left: MediaQuery.of(context).size.width*(370/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(80/930),
                            width: MediaQuery.of(context).size.width*(80/462),
                            child: IconButton(
                              icon: Image.asset(Menu_Button,scale: 1.4,),
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Stack(
                                          children: [
                                            Image.asset(Menu_UI),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(98/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Battle,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(0);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(178/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Train,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(1);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(258/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Skill,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(2);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(338/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Shop,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(3);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(418/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Log,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(4);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(498/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Logout,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            login.logout();
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                          )
                      ),
                    ]
                ),
              )
            ],
          )
      );
      //2 skill
      case 2 : return Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height-28)*(730/930)+24,
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*(705/930),
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        return Container(
                          child: skillPage(index),
                        );
                      },
                      itemCount: 3,
                      controller: _skillPageController,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(13/930),
                    left: MediaQuery.of(context).size.width*(140/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(50/930),
                      width: MediaQuery.of(context).size.width*(50/462),
                      child: Stack(
                        children: [
                          Image.asset(Skill_LeftArrow_Button),
                          InkWell(
                            onTap: (){
                              if(_skillPageController.page==0){
                                _skillPageController.jumpToPage(2);
                              }
                              else if(_skillPageController.page==1){
                                _skillPageController.jumpToPage(0);
                              }
                              else if(_skillPageController.page==2){
                                _skillPageController.jumpToPage(1);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(13/930),
                    left: MediaQuery.of(context).size.width*(280/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(50/930),
                      width: MediaQuery.of(context).size.width*(50/462),
                      child: Stack(
                        children: [
                          Image.asset(Skill_RightArrow_Button),
                          InkWell(
                            onTap: (){
                              if(_skillPageController.page==0){
                                _skillPageController.jumpToPage(1);
                              }
                              else if(_skillPageController.page==1){
                                _skillPageController.jumpToPage(2);
                              }
                              else if(_skillPageController.page==2){
                                _skillPageController.jumpToPage(0);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(10/930),
                    left: MediaQuery.of(context).size.width*(385/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(50/930),
                      width: MediaQuery.of(context).size.width*(80/462),
                      child: Stack(
                        children: [
                          Image.asset(Skill_Sp_TextBox),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(-2/930),
                            left: MediaQuery.of(context).size.width*(-5/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(50/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Obx(()=>Text(player.sp.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(603/930),
                      left: MediaQuery.of(context).size.width*(370/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(80/930),
                        width: MediaQuery.of(context).size.width*(80/462),
                        child: IconButton(
                          icon: Image.asset(Menu_Button,scale: 1.4,),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Stack(
                                      children: [
                                        Image.asset(Menu_UI),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(98/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Battle,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(0);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(178/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Train,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(1);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(258/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Skill,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(2);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(338/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Shop,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(3);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(418/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Log,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(4);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(498/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Logout,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        login.logout();
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        ),
                      )
                  ),
                ],
              ),
            ],
          )
      );
      //3 shop
      case 3 : return Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height-28)*(730/930)+24,
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*(705/930),
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        return Container(
                          child: shopPage(index),
                        );
                      },
                      itemCount: 5,
                      controller: _shopPageController,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _shopPageController.jumpToPage(0);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemContent.value = '';
                          itemCoin.value=0;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*(100/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _shopPageController.jumpToPage(1);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemContent.value = '';
                          itemCoin.value=0;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*(200/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _shopPageController.jumpToPage(2);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemContent.value = '';
                          itemCoin.value=0;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*(300/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _shopPageController.jumpToPage(3);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemContent.value = '';
                          itemCoin.value=0;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*(400/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          print('##########${player.coin.value}');
                          _shopPageController.jumpToPage(4);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemContent.value = '';
                          itemCoin.value=0;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(603/930),
                      left: MediaQuery.of(context).size.width*(370/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(80/930),
                        width: MediaQuery.of(context).size.width*(80/462),
                        child: IconButton(
                          icon: Image.asset(Menu_Button,scale: 1.4,),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Stack(
                                      children: [
                                        Image.asset(Menu_UI),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(98/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Battle,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(0);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(178/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Train,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(1);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(258/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Skill,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(2);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(338/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Shop,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(3);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(418/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Log,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        _pageController.jumpToPage(4);
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: MediaQuery.of(context).size.height*(498/930),
                                            left: MediaQuery.of(context).size.width*(30/462),
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*(80/930),
                                                width: MediaQuery.of(context).size.width*(320/462),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(Menu_Logout,scale: 0.1,),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                        login.logout();
                                                      },
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        ),
                      )
                  ),
                ],
              ),
            ],
          )
      );
      //4 log
      case 4 : return Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height-28)*(730/930)+24,
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Container(
                height: MediaQuery.of(context).size.height*(705/930),
                width: MediaQuery.of(context).size.width,
                child: Stack(
                    children: [
                      Image.asset(Log_UI),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('log').orderBy('Index',descending: false).snapshots(),
                        builder: (context,snapshot){
                          if(!snapshot.hasData) return LinearProgressIndicator();
                          return Positioned(
                            top: MediaQuery.of(context).size.height*(65/930),
                            left: MediaQuery.of(context).size.width*(22/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(455/930),
                              width: MediaQuery.of(context).size.width*(420/462),
                              child: ListView.separated(
                                separatorBuilder: (context,index){
                                  return SizedBox(height: 25,);
                                },
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context,index){
                                  final doc=snapshot.data!.docs[index];
                                  return getLogItem(doc['Type'],doc['Content1'],doc['Content2']);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height*(603/930),
                          left: MediaQuery.of(context).size.width*(280/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(80/930),
                            width: MediaQuery.of(context).size.width*(80/462),
                            child: IconButton(
                              icon: Image.asset(Log_toAchievement_Button,scale: 1.4,),
                              onPressed: (){
                                _pageController.jumpToPage(7);
                              },
                            ),
                          )
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height*(603/930),
                          left: MediaQuery.of(context).size.width*(370/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(80/930),
                            width: MediaQuery.of(context).size.width*(80/462),
                            child: IconButton(
                              icon: Image.asset(Menu_Button,scale: 1.4,),
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Stack(
                                          children: [
                                            Image.asset(Menu_UI),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(98/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Battle,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(0);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(178/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Train,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(1);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(258/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Skill,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(2);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(338/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Shop,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(3);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(418/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Log,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            _pageController.jumpToPage(4);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context).size.height*(498/930),
                                                left: MediaQuery.of(context).size.width*(30/462),
                                                child: Container(
                                                    height: MediaQuery.of(context).size.height*(80/930),
                                                    width: MediaQuery.of(context).size.width*(320/462),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(Menu_Logout,scale: 0.1,),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            login.logout();
                                                          },
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                          )
                      ),
                    ]
                ),
              )

            ],
          )
      );
      //5 status
      case 5 : return Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height-28)*(730/930)+24,
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Stack(
              children: [
                Image.asset(Info_UI),
                Positioned(
                  top: MediaQuery.of(context).size.height*(25/930),
                  left: MediaQuery.of(context).size.width*(65/462),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 150),
                    height: MediaQuery.of(context).size.height*(260/930),
                    width: MediaQuery.of(context).size.width*(230/462),
                    child: Stack(
                      children: [
                        Obx(()=>Image.asset(player.backHairImg.value)), //backHair
                        Obx(()=>Image.asset(player.heavyWeaponHandleImg.value)), //heavyWeaponHandle
                        Obx(()=>Image.asset(player.heavyWeaponHeadImg.value)), //heavyWeaponHead
                        Obx(()=>Image.asset(player.backItemImg.value)),
                        Obx(()=>Image.asset(player.headBodyImg.value)), //headBody
                        Obx(()=>Image.asset(player.earsImg.value)), //ears
                        Obx(()=>Image.asset(player.eyesImg.value)), //eyes
                        Obx(()=>Image.asset(player.eyeDecorationImg.value)),
                        Obx(()=>Image.asset(player.foreHairImg.value)), //foreHair
                        Obx(()=>Image.asset(player.pantsImg.value)), //pants
                        Obx(()=>Image.asset(player.clothesImg.value)), //clothes
                        Obx(()=>Image.asset(player.mouthImg.value)), //mouth
                        Obx(()=>Image.asset(player.shoesImg.value)), //shoes
                        Obx(()=>Image.asset(player.lightWeaponImg.value)), //lightWeapon
                        Positioned(
                          top: MediaQuery.of(context).size.height*(40/930),
                          left: MediaQuery.of(context).size.width*(130/462),
                          child: Obx(()=>Image.asset(player.liverImg.value,scale: 2.2,)), //liver
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(130/930),
                  left: MediaQuery.of(context).size.width*(80/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>Text(player.playerName.value,textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(188/930),
                  left: MediaQuery.of(context).size.width*(170/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>Text(player.lv.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(248/930),
                  left: MediaQuery.of(context).size.width*(170/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Text('1',textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(248/930),
                  left: MediaQuery.of(context).size.width*(90/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Text('1',textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(310/930),
                  left: MediaQuery.of(context).size.width*(170/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>Text(player.maxMp.value.toInt().toString(),textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(310/930),
                  left: MediaQuery.of(context).size.width*(90/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>Text(player.mp.value.toInt().toString(),textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(372/930),
                  left: MediaQuery.of(context).size.width*(170/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>Text(player.maxExp.value.toInt().toString(),textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(372/930),
                  left: MediaQuery.of(context).size.width*(90/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>Text(player.exp.value.toInt().toString(),textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(434/930),
                  left: MediaQuery.of(context).size.width*(170/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>AutoSizeText(player.STR.value.toStringAsFixed(1),textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(496/930),
                  left: MediaQuery.of(context).size.width*(170/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>AutoSizeText(player.INT.value.toStringAsFixed(1),textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*(558/930),
                  left: MediaQuery.of(context).size.width*(170/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(50/930),
                    width: MediaQuery.of(context).size.width*(110/462),
                    child: Center(
                      child: Obx(()=>AutoSizeText(player.VIT.value.toStringAsFixed(1),textAlign:TextAlign.center,style: TextStyle(
                          fontFamily: 'DotGothic16',
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                      ),)),
                    ),
                  ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height*(530/930),
                    left: MediaQuery.of(context).size.width*(350/462),
                    child: Container(
                        height: MediaQuery.of(context).size.height*(80/930),
                        width: MediaQuery.of(context).size.width*(80/462),
                        child: Stack(
                          children: [
                            Image.asset(Info_toBag_Button,scale: 0.1,),
                            InkWell(
                              onTap: (){
                                _pageController.jumpToPage(6);
                              },
                            )
                          ],
                        )
                    )
                ),
              ],
            )
          ],
        )
      );
      //6bag
      case 6 : return Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height-28)*(730/930)+24,
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*(660/930),
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        return Container(
                          child: bagPage(index),
                        );
                      },
                      itemCount: 5,
                      controller: _bagPageController,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _bagPageController.jumpToPage(0);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemCoin.value=0;
                          itemContent.value = '';
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*(100/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _bagPageController.jumpToPage(1);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemCoin.value=0;
                          itemContent.value = '';
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*(200/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _bagPageController.jumpToPage(2);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemCoin.value=0;
                          itemContent.value = '';
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*(300/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _bagPageController.jumpToPage(3);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemCoin.value=0;
                          itemContent.value = '';
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*(400/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(40/930),
                      width: MediaQuery.of(context).size.width*(100/462),
                      child: InkWell(
                        onTap: (){
                          _bagPageController.jumpToPage(4);
                          itemId.value='';
                          itemImg1.value=NoImg;
                          itemSTR.value=0;
                          itemINT.value=0;
                          itemVIT.value=0;
                          itemCoin.value=0;
                          itemContent.value = '';
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height*(530/930),
                      left: MediaQuery.of(context).size.width*(350/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(80/930),
                          width: MediaQuery.of(context).size.width*(80/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_toInfo_Button,scale: 0.1,),
                              InkWell(
                                onTap: (){
                                  _pageController.jumpToPage(5);
                                },
                              )
                            ],
                          )
                      )
                  ),
                ],
              ),
            ],
          )
      );
      //7achievement
      case 7 : return Container(
        height: MediaQuery.of(context).size.height*(730/930),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Achievement_BG),
            fit: BoxFit.fill
          )
        ),
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('achievement').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Container(
                  height: MediaQuery.of(context).size.height*(630/930),
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.6,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      final doc=snapshot.data!.docs[index];
                      return getAchievement(doc['Type'],doc['Name'],doc['Date']);
                    },
                  ),
                );
              },
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(630/930),
                left: MediaQuery.of(context).size.width*(280/462),
                child: Container(
                  height: MediaQuery.of(context).size.height*(80/930),
                  width: MediaQuery.of(context).size.width*(80/462),
                  child: IconButton(
                    icon: Image.asset(Achievement_toLog_Button,scale: 1.4,),
                    onPressed: (){
                      _pageController.jumpToPage(4);
                    },
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(630/930),
                left: MediaQuery.of(context).size.width*(370/462),
                child: Container(
                  height: MediaQuery.of(context).size.height*(80/930),
                  width: MediaQuery.of(context).size.width*(80/462),
                  child: IconButton(
                    icon: Image.asset(Menu_Button,scale: 1.4,),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  Image.asset(Menu_UI),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(98/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Battle,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(0);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(178/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Train,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(1);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(258/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Skill,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(2);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(338/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Shop,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(3);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(418/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Log,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  _pageController.jumpToPage(4);
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.height*(498/930),
                                      left: MediaQuery.of(context).size.width*(30/462),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*(80/930),
                                          width: MediaQuery.of(context).size.width*(320/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Menu_Logout,scale: 0.1,),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  login.logout();
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                )
            ),
          ],
        ),
      );
      default: return Container();
    }
  }

  // BATTLE
  Container monsterPage(int index) {
    switch(index){
      case 0: return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Battle_BG_R),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height*(130/930),
              left: MediaQuery.of(context).size.width*(30/462),
              child: Obx(()=>getMonsterR(!(monsterR.image.value==''))),
            )
          ],
        ),
      );
      case 1: return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Battle_BG_B),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height*(130/930),
              left: MediaQuery.of(context).size.width*(30/462),
              child: Obx(()=>getMonsterB(!(monsterB.image.value==''))),
            )
          ],
        ),
      );
      case 2: return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Battle_BG_G),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: MediaQuery.of(context).size.height*(130/930),
                left: MediaQuery.of(context).size.width*(30/462),
                child: Obx(()=>getMonsterG(!(monsterG.image.value=='')))
            )
          ],
        ),
      );
      default: return Container();
    }
  }

  Container getMonsterR(bool hasMonster){
    if(hasMonster){
      return Container(
          height: MediaQuery.of(context).size.height*(600/930),
          width: MediaQuery.of(context).size.width*(400/462),
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height*(140/930),
                left: MediaQuery.of(context).size.width*(55/462),
                child: Image.asset(monsterR.image.value,scale: 2.0,),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(50/930),
                left: MediaQuery.of(context).size.width*(110/462),
                child: Container(
                  height: MediaQuery.of(context).size.height*(50/930),
                  width: MediaQuery.of(context).size.width*(180/462),
                  child: Obx(()=>AutoSizeText(monsterR.name.value,textAlign:TextAlign.center,style: TextStyle(
                      fontFamily: 'DotGothic16',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                  ),)),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(95/930),
                left: MediaQuery.of(context).size.width*(100/462),
                child: Image.asset(CharacterStatus_HP_BarGroove,scale: 0.65,),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(107/930),
                left: MediaQuery.of(context).size.width*(106/462),
                child: Image.asset(CharacterStatus_HP_BarBegin,scale: 0.65,),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*(107/930),
                  left: MediaQuery.of(context).size.width*(112/462),
                  child: SizedBox(
                    height: 19,
                    width: 185,
                    child: LinearProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation(Color(0xFFFF0000)),
                      backgroundColor: const Color(0xFF750000),
                      value: monsterR.hpRatio.value,
                    ),
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*(101/930),
                  left: MediaQuery.of(context).size.width*(112/462),
                  child: SizedBox(
                    height: 6,
                    width: 185,
                    child: LinearProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6a6a)),
                      backgroundColor: const Color(0xFF750000),
                      value: monsterR.hpRatio.value,
                    ),
                  )
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(470/930),
                left: MediaQuery.of(context).size.width*(135/462),
                child: Obx(()=>getAttackButtonR(monsterR.canBeAttack.value)),
              ),
            ],
          )
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height*(400/930),
        width: MediaQuery.of(context).size.width*(400/462),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height*(195/930),
              left: MediaQuery.of(context).size.width*(170/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(80/930),
                width: MediaQuery.of(context).size.width*(80/462),
                child: Stack(
                  children: [
                    Image.asset(Train_Add_Button),
                    InkWell(
                      onTap: (){
                        Get.to(AddMonster(),arguments: 0);
                        Database.getDataToMonsterR(player.emailName.value);
                        setState(() {

                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Container getMonsterB(bool hasMonster){
    if(hasMonster){
      return Container(
          height: MediaQuery.of(context).size.height*(600/930),
          width: MediaQuery.of(context).size.width*(400/462),
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height*(110/930),
                left: MediaQuery.of(context).size.width*(50/462),
                child: Image.asset(monsterB.image.value,scale: 1.9,),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(50/930),
                left: MediaQuery.of(context).size.width*(110/462),
                child: Container(
                  height: MediaQuery.of(context).size.height*(50/930),
                  width: MediaQuery.of(context).size.width*(180/462),
                  child: Obx(()=>AutoSizeText(monsterB.name.value,textAlign:TextAlign.center,style: TextStyle(
                    fontFamily: 'DotGothic16',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),)),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(95/930),
                left: MediaQuery.of(context).size.width*(100/462),
                child: Image.asset(CharacterStatus_HP_BarGroove,scale: 0.65,),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(107/930),
                left: MediaQuery.of(context).size.width*(106/462),
                child: Image.asset(CharacterStatus_HP_BarBegin,scale: 0.65,),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*(107/930),
                  left: MediaQuery.of(context).size.width*(112/462),
                  child: SizedBox(
                    height: 19,
                    width: 185,
                    child: LinearProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation(Color(0xFFFF0000)),
                      backgroundColor: const Color(0xFF750000),
                      value: monsterB.hpRatio.value,
                    ),
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*(101/930),
                  left: MediaQuery.of(context).size.width*(112/462),
                  child: SizedBox(
                    height: 6,
                    width: 185,
                    child: LinearProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6a6a)),
                      backgroundColor: const Color(0xFF750000),
                      value: monsterB.hpRatio.value,
                    ),
                  )
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(470/930),
                left: MediaQuery.of(context).size.width*(135/462),
                child: Obx(()=>getAttackButtonB(monsterB.canBeAttack.value)),
              ),
            ],
          )
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height*(400/930),
        width: MediaQuery.of(context).size.width*(400/462),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height*(195/930),
              left: MediaQuery.of(context).size.width*(170/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(80/930),
                width: MediaQuery.of(context).size.width*(80/462),
                child: Stack(
                  children: [
                    Image.asset(Train_Add_Button),
                    InkWell(
                      onTap: (){
                        Get.to(AddMonster(),arguments: 1);
                        Database.getDataToMonsterB(player.emailName.value);
                        setState(() {

                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Container getMonsterG(bool hasMonster){
    if(hasMonster){
      return Container(
          height: MediaQuery.of(context).size.height*(600/930),
          width: MediaQuery.of(context).size.width*(400/462),
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height*(110/930),
                left: MediaQuery.of(context).size.width*(50/462),
                child: Image.asset(monsterG.image.value,scale: 1.9,),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(50/930),
                left: MediaQuery.of(context).size.width*(110/462),
                child: Container(
                  height: MediaQuery.of(context).size.height*(50/930),
                  width: MediaQuery.of(context).size.width*(180/462),
                  child: Obx(()=>AutoSizeText(monsterG.name.value,textAlign:TextAlign.center,style: TextStyle(
                    fontFamily: 'DotGothic16',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),)),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(95/930),
                left: MediaQuery.of(context).size.width*(100/462),
                child: Image.asset(CharacterStatus_HP_BarGroove,scale: 0.65,),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(107/930),
                left: MediaQuery.of(context).size.width*(106/462),
                child: Image.asset(CharacterStatus_HP_BarBegin,scale: 0.65,),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*(107/930),
                  left: MediaQuery.of(context).size.width*(112/462),
                  child: SizedBox(
                    height: 19,
                    width: 185,
                    child: LinearProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation(Color(0xFFFF0000)),
                      backgroundColor: const Color(0xFF750000),
                      value: monsterG.hpRatio.value,
                    ),
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*(101/930),
                  left: MediaQuery.of(context).size.width*(112/462),
                  child: SizedBox(
                    height: 6,
                    width: 185,
                    child: LinearProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6a6a)),
                      backgroundColor: const Color(0xFF750000),
                      value: monsterG.hpRatio.value,
                    ),
                  )
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*(470/930),
                left: MediaQuery.of(context).size.width*(135/462),
                child: Obx(()=>getAttackButtonG(monsterG.canBeAttack.value)),
              ),
            ],
          )
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height*(400/930),
        width: MediaQuery.of(context).size.width*(400/462),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height*(195/930),
              left: MediaQuery.of(context).size.width*(170/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(80/930),
                width: MediaQuery.of(context).size.width*(80/462),
                child: Stack(
                  children: [
                    Image.asset(Train_Add_Button),
                    InkWell(
                      onTap: (){
                        Get.to(AddMonster(),arguments: 2);
                        Database.getDataToMonsterG(player.emailName.value);
                        setState(() {

                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Container getSTR_Easy() {
    if(STR_Easy.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_STR_0),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getSTR_Mid() {
    if(STR_Mid.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_STR_1),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getSTR_Hard() {
    if(STR_Hard.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_STR_2),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getINT_Easy() {
    if(INT_Easy.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_INT_0),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getINT_Mid() {
    if(INT_Mid.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_INT_1),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getINT_Hard() {
    if(INT_Hard.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_INT_2),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getVIT_Easy() {
    if(VIT_Easy.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_VIT_0),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getVIT_Mid() {
    if(VIT_Mid.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_VIT_1),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getVIT_Hard() {
    if(VIT_Hard.use.value){
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Skill_Mark_VIT_2),
          ),
        ),
      );
    }
    else{
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
      );
    }
  }

  Container getAttackButtonR(bool canBeAttack){
    if(canBeAttack || VIT_Hard.use.value){
      return Container(
        height: 130,
        width: 130,
        child: IconButton(
          icon: Image.asset(Battle_Attack_Button,scale: 1.4,),
          onPressed: (){
            nowMonsterRCount=player.monsterRCount.value;
            nowLV=player.lv.value;
            player.getWeapon.value=false;
            player.getItems.value=false;
            player.getAccessories.value=false;
            player.attackMonster('monsterR');
            setState(() {

            });
            if(player.getWeapon.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機武器\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getWeapon.value=false;
            }
            if(player.getItems.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機道具\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getItems.value=false;
            }
            if(player.getAccessories.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機飾品\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getAccessories.value=false;
            }

            if(monsterR.hp.value<=0){
              if(monsterR.killCount.value==0){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterR.name.value}\n途中都沒有中斷\n請繼續保持！\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
              else if(monsterR.killCount.value>0 && monsterR.killCount.value<=5){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterR.name.value}\n中途有幾天沒有完成\n推薦您在生活中顯眼的位置\n放置會讓您想起習慣的物品\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
              else if(monsterR.killCount.value>5){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterR.name.value}\n有過多天數未完成習慣\n推薦您將生活中\n達成習慣的次數大幅增加\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            }
            if(player.lv.value>=10 && nowLV<10){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 達成十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            if(player.lv.value>=20 && nowLV<20){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 達成二十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            if(player.monsterRCount.value>=10 && nowMonsterRCount<10){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 擊敗十隻藍魔物!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          },
        ),
      );
    }
    else{
      return Container(
        height: 130,
        width: 130,
        child: Image.asset(Battle_Attack_Unuse,scale: 1.4,),
      );
    }
  }

  Container getAttackButtonB(bool canBeAttack){
    if(canBeAttack || VIT_Hard.use.value){
      return Container(
        height: 130,
        width: 130,
        child: IconButton(
          icon: Image.asset(Battle_Attack_Button,scale: 1.4,),
          onPressed: (){
            nowMonsterBCount=player.monsterBCount.value;
            nowLV=player.lv.value;
            player.getWeapon.value=false;
            player.getItems.value=false;
            player.getAccessories.value=false;
            player.attackMonster('monsterB');
            setState(() {

            });
            if(player.getWeapon.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機武器\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getWeapon.value=false;
            }
            if(player.getItems.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機道具\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getItems.value=false;
            }
            if(player.getAccessories.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機飾品\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getAccessories.value=false;
            }

            if(monsterB.hp.value<=0){
              if(monsterB.killCount.value==0){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterB.name.value}\n途中都沒有中斷\n請繼續保持！\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
              else if(monsterB.killCount.value>0 && monsterB.killCount.value<=5){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterB.name.value}\n中途有幾天沒有完成\n推薦您在生活中顯眼的位置\n放置會讓您想起習慣的物品\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
              else if(monsterB.killCount.value>5){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterB.name.value}\n有過多天數未完成習慣\n推薦您將生活中\n達成習慣的次數大幅增加\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            }
            if(player.lv.value>=10 && nowLV<10){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 達成十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            if(player.lv.value>=20 && nowLV<20){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 達成二十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            if(player.monsterBCount.value>=10 && nowMonsterBCount<10){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 擊敗十隻藍魔物!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          },
        ),
      );
    }
    else{
      return Container(
        height: 130,
        width: 130,
        child: Image.asset(Battle_Attack_Unuse,scale: 1.4,),
      );
    }
  }

  Container getAttackButtonG(bool canBeAttack){
    if(canBeAttack || VIT_Hard.use.value){
      return Container(
        height: 130,
        width: 130,
        child: IconButton(
          icon: Image.asset(Battle_Attack_Button,scale: 1.4,),
          onPressed: (){
            nowMonsterGCount=player.monsterGCount.value;
            nowLV=player.lv.value;
            player.getWeapon.value=false;
            player.getItems.value=false;
            player.getAccessories.value=false;
            player.attackMonster('monsterG');
            setState(() {

            });
            if(player.getWeapon.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機武器\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getWeapon.value=false;
            }
            if(player.getItems.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機道具\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getItems.value=false;
            }
            if(player.getAccessories.value){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('恭喜! 獲得一個隨機飾品\n快去背包看看吧!',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              player.getAccessories.value=false;
            }

            if(monsterG.hp.value<=0){
              if(monsterG.killCount.value==0){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterG.name.value}\n途中都沒有中斷\n請繼續保持！\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
              else if(monsterG.killCount.value>0 && monsterG.killCount.value<=5){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterG.name.value}\n中途有幾天沒有完成\n推薦您在生活中顯眼的位置\n放置會讓您想起習慣的物品\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
              else if(monsterG.killCount.value>5){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Image.asset(Achievement_window),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(50/930),
                              left: MediaQuery.of(context).size.width*(30/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(150/930),
                                width: MediaQuery.of(context).size.width*(330/462),
                                child: AutoSizeText('已完成 ${monsterG.name.value}\n有過多天數未完成習慣\n推薦您將生活中\n達成習慣的次數大幅增加\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'DotGothic16',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xffe3a06d),
                                ),),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*(165/930),
                              left: MediaQuery.of(context).size.width*(290/462),
                              child: Container(
                                height: MediaQuery.of(context).size.height*(80/930),
                                width: MediaQuery.of(context).size.width*(80/462),
                                child: Stack(
                                  children: [
                                    Image.asset(Achievement_ok_Button),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            }
            if(player.lv.value>=10 && nowLV<10){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 達成十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            if(player.lv.value>=20 && nowLV<20){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 達成二十級!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            if(player.monsterGCount.value>=10 && nowMonsterGCount<10){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Image.asset(Achievement_window),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(50/930),
                            left: MediaQuery.of(context).size.width*(30/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(150/930),
                              width: MediaQuery.of(context).size.width*(330/462),
                              child: Text('已完成 擊敗十隻綠魔物!\n${DateFormat('yyyy-MM-dd').format(DateTime.now())}',textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'DotGothic16',
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                                color: Color(0xffe3a06d),
                              ),),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height*(165/930),
                            left: MediaQuery.of(context).size.width*(290/462),
                            child: Container(
                              height: MediaQuery.of(context).size.height*(80/930),
                              width: MediaQuery.of(context).size.width*(80/462),
                              child: Stack(
                                children: [
                                  Image.asset(Achievement_ok_Button),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          },
        ),
      );
    }
    else{
      return Container(
        height: 130,
        width: 130,
        child: Image.asset(Battle_Attack_Unuse,scale: 1.4,),
      );
    }
  }
  //

  //weapon armors accessories body items
  Container bagPage(int index) {
    switch(index){
      case 0: return Container(
        child: Stack(
          children: [
            Image.asset(Bag_Weapons),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('bag').doc('Weapon').collection('Weapon').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(530/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(25/930),
                                left: MediaQuery.of(context).size.width*(25/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(40/930),
                                  width: MediaQuery.of(context).size.width*(40/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getEquipOrNot(doc['PlayerEquipped']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemEquiped.value=doc['PlayerEquipped'];
                                  itemId.value=doc.id;
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(20/930),
                      left: MediaQuery.of(context).size.width*(45/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(90/930),
                        width: MediaQuery.of(context).size.width*(90/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(120/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemSTR.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(180/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemINT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(235/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemVIT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Obx(()=>getEquipButton(itemEquiped.value, 'Weapon')),
            ),
          ],
        ),
      );
      case 1: return Container(
        child: Stack(
          children: [
            Image.asset(Bag_Armors),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('bag').doc('Armors').collection('Armors').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(530/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(25/930),
                                left: MediaQuery.of(context).size.width*(25/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(40/930),
                                  width: MediaQuery.of(context).size.width*(40/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getEquipOrNot(doc['PlayerEquipped']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemEquiped.value=doc['PlayerEquipped'];
                                  itemId.value=doc.id;
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(20/930),
                      left: MediaQuery.of(context).size.width*(45/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(90/930),
                        width: MediaQuery.of(context).size.width*(90/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(120/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemSTR.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(180/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemINT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(235/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemVIT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Obx(()=>getEquipButton(itemEquiped.value, 'Armors')),
            ),
          ],
        ),
      );
      case 2: return Container(
        child: Stack(
          children: [
            Image.asset(Bag_Accessories),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('bag').doc('Accessories').collection('Accessories').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(530/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(25/930),
                                left: MediaQuery.of(context).size.width*(25/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(40/930),
                                  width: MediaQuery.of(context).size.width*(40/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getEquipOrNot(doc['PlayerEquipped']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemEquiped.value=doc['PlayerEquipped'];
                                  itemId.value=doc.id;
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(20/930),
                      left: MediaQuery.of(context).size.width*(45/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(90/930),
                        width: MediaQuery.of(context).size.width*(90/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(120/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemSTR.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(180/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemINT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(235/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemVIT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Obx(()=>getEquipButton(itemEquiped.value, 'Accessories')),
            ),
          ],
        ),
      );
      case 3: return Container(
        child: Stack(
          children: [
            Image.asset(Bag_Body),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('bag').doc('Body').collection('Body').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(530/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(25/930),
                                left: MediaQuery.of(context).size.width*(25/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(40/930),
                                  width: MediaQuery.of(context).size.width*(40/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getEquipOrNot(doc['PlayerEquipped']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemEquiped.value=doc['PlayerEquipped'];
                                  itemId.value=doc.id;
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI_forItems),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(20/930),
                      left: MediaQuery.of(context).size.width*(45/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(90/930),
                        width: MediaQuery.of(context).size.width*(90/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(47/930),
                      left: MediaQuery.of(context).size.width*(-25/462),
                      child: Obx(()=>getShopTryOn(itemType.value, itemImg2.value)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Obx(()=>getEquipButton(itemEquiped.value, 'Body')),
            ),
          ],
        ),
      );
      case 4: return Container(
        child: Stack(
          children: [
            Image.asset(Bag_Items),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('bag').doc('Items').collection('Items').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(530/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(18/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(50/930),
                                  width: MediaQuery.of(context).size.width*(50/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getEquipOrNot(doc['PlayerEquipped']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemContent.value=doc['Content'];
                                  itemMP.value=doc['MP'];
                                  itemEXP.value=doc['EXP'];
                                  itemId.value=doc.id;
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI_forItems),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(10/930),
                      left: MediaQuery.of(context).size.width*(38/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(140/930),
                      left: MediaQuery.of(context).size.width*(30/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(130/930),
                          width: MediaQuery.of(context).size.width*(130/462),
                          child: Obx(()=>AutoSizeText(itemContent.value,textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff000000),
                          ),))
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(185/930),
                width: MediaQuery.of(context).size.width*(185/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_Use_Button),
                    InkWell(
                      onTap: (){
                        Database.useItem(emailName: player.emailName.value, docId: itemId.value, imagePath1: itemImg1.value, imagePath2: itemImg2.value, imagePath3: itemImg3.value, type: itemType.value, STR: itemSTR.value, INT: itemINT.value, VIT: itemVIT.value,MP:itemMP.value,EXP:itemEXP.value,mark: 'Items');
                        itemSTR.value=0;
                        itemINT.value=0;
                        itemVIT.value=0;
                        itemImg1.value=NoImg;
                        itemImg2.value='';
                        itemImg3.value='';
                        itemCoin.value=0;
                        itemType.value='';
                        itemContent.value='';
                        itemMP.value=0;
                        itemEXP.value=0;
                        itemId.value='';
                        setState(() {

                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      default: return Container();
    }
  }

  Container shopPage(int index) {
    switch(index){
      case 0: return Container (
        child: Stack(
          children: [
            Image.asset(Shop_Weapons),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('shop').doc('Weapon').collection('Weapon').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(430/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(25/930),
                                left: MediaQuery.of(context).size.width*(25/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(40/930),
                                  width: MediaQuery.of(context).size.width*(40/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getOwnedOrCoin(doc['PlayerOwned'],doc['Coin']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemId.value=doc.id;
                                  itemIndex.value=doc['Index'];
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(10/930),
                      left: MediaQuery.of(context).size.width*(38/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                          child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(120/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemSTR.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(180/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemINT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(235/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemVIT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Obx(()=>getBuyButton(player.coin.value>=itemCoin.value,'Weapon',itemId.value)),
            ),
          ],
        ),
      );
      case 1: return Container(
        child: Stack(
          children: [
            Image.asset(Shop_Armors),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('shop').doc('Armors').collection('Armors').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(430/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(25/930),
                                left: MediaQuery.of(context).size.width*(25/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(40/930),
                                  width: MediaQuery.of(context).size.width*(40/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getOwnedOrCoin(doc['PlayerOwned'],doc['Coin']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemId.value=doc.id;
                                  itemIndex.value= doc['Index'];
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(10/930),
                      left: MediaQuery.of(context).size.width*(38/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(120/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemSTR.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(180/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemINT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(235/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemVIT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Obx(()=>getBuyButton(player.coin.value>=itemCoin.value,'Armors',itemId.value)),
            ),
          ],
        ),
      );
      case 2: return Container(
        child: Stack(
          children: [
            Image.asset(Shop_Accessories),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('shop').doc('Accessories').collection('Accessories').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(430/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(25/930),
                                left: MediaQuery.of(context).size.width*(25/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(40/930),
                                  width: MediaQuery.of(context).size.width*(40/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getOwnedOrCoin(doc['PlayerOwned'],doc['Coin']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemId.value=doc.id;
                                  itemIndex.value= doc['Index'];
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(10/930),
                      left: MediaQuery.of(context).size.width*(38/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(120/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemSTR.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(180/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemINT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(235/930),
                      left: MediaQuery.of(context).size.width*(110/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(50/930),
                          width: MediaQuery.of(context).size.width*(50/462),
                          child: Obx(()=>Text(itemVIT.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xffe3a16d),
                          ),))
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Obx(()=>getBuyButton(player.coin.value>=itemCoin.value,'Accessories',itemId.value)),
            ),
          ],
        ),
      );
      case 3: return Container(
        child: Stack(
          children: [
            Image.asset(Shop_Body),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('shop').doc('Body').collection('Body').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(430/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(25/930),
                                left: MediaQuery.of(context).size.width*(25/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(40/930),
                                  width: MediaQuery.of(context).size.width*(40/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: getOwnedOrCoin(doc['PlayerOwned'],doc['Coin']),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemId.value=doc.id;
                                  itemIndex.value= doc['Index'];
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI_forItems),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(10/930),
                      left: MediaQuery.of(context).size.width*(38/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(47/930),
                      left: MediaQuery.of(context).size.width*(-25/462),
                      child: Obx(()=>getShopTryOn(itemType.value, itemImg2.value)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Obx(()=>getBuyButton(player.coin.value>=itemCoin.value,'Body',itemId.value)),
            ),
          ],
        ),
      );
      case 4: return Container(
        child: Stack(
          children: [
            Image.asset(Shop_Items),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').doc(player.emailName.value).collection('shop').doc('Items').collection('Items').orderBy('Index',descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Positioned(
                  top: MediaQuery.of(context).size.height*(95/930),
                  left: MediaQuery.of(context).size.width*(23/462),
                  child: Container(
                    height: MediaQuery.of(context).size.height*(430/930),
                    width: MediaQuery.of(context).size.width*(220/462),
                    child: ListView.separated(
                      separatorBuilder: (context,index){
                        return SizedBox(height: 10,);
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                        return Container(
                          height: MediaQuery.of(context).size.height*(150/930),
                          width: MediaQuery.of(context).size.width*(250/462),
                          child: Stack(
                            children: [
                              Image.asset(Bag_Item_BG),
                              Image.asset(Bag_Item_ForeUI),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(18/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(50/930),
                                  width: MediaQuery.of(context).size.width*(50/462),
                                  child: Image.asset(doc['Image1']),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(18/930),
                                left: MediaQuery.of(context).size.width*(80/462),
                                child: Container(
                                  height: MediaQuery.of(context).size.height*(50/930),
                                  width: MediaQuery.of(context).size.width*(130/462),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 30,),
                                      Image.asset(CharacterStatus_Coin,scale: 1.3,),
                                      SizedBox(width: 10,),
                                      Text(doc['Coin'].toString(),textAlign:TextAlign.center,style: TextStyle(
                                        fontFamily: 'DotGothic16',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Color(0xffe3a16d),
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  itemSTR.value=doc['STR'];
                                  itemINT.value=doc['INT'];
                                  itemVIT.value=doc['VIT'];
                                  itemImg1.value=doc['Image1'];
                                  itemImg2.value=doc['Image2'];
                                  itemImg3.value=doc['Image3'];
                                  itemCoin.value=doc['Coin'];
                                  itemType.value=doc['Type'];
                                  itemContent.value=doc['Content'];
                                  itemMP.value=doc['MP'];
                                  itemEXP.value=doc['EXP'];
                                  itemId.value=doc.id;
                                  print('@@@@@@${itemCoin.value}');
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(100/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(300/930),
                width: MediaQuery.of(context).size.width*(300/462),
                child: Stack(
                  children: [
                    Image.asset(Bag_ItemInfo_BG),
                    Image.asset(Bag_ItemInfo_ForeUI_forItems),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(10/930),
                      left: MediaQuery.of(context).size.width*(38/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Obx(()=>Image.asset(itemImg1.value)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(140/930),
                      left: MediaQuery.of(context).size.width*(30/462),
                      child: Container(
                          height: MediaQuery.of(context).size.height*(130/930),
                          width: MediaQuery.of(context).size.width*(130/462),
                          child: Obx(()=>AutoSizeText(itemContent.value,textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'DotGothic16',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff000000),
                          ),))
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(425/930),
              left: MediaQuery.of(context).size.width*(250/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(90/930),
                width: MediaQuery.of(context).size.width*(185/462),
                child: Stack(
                  children: [
                    Image.asset(Shop_Buy_Button),
                    InkWell(
                      onTap: (){
                        purchase_account.value =0;
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Image.asset(Shop_Purchase_BG),
                                      Positioned(
                                        top: MediaQuery.of(context).size.height*(50/930),
                                        left: MediaQuery.of(context).size.width*(170/462),
                                        child: Container(
                                            height: MediaQuery.of(context).size.height*(100/930),
                                            width: MediaQuery.of(context).size.width*(100/462),
                                            child: Stack(
                                              children: [
                                                Image.asset(Shop_Purchase_TextBox),
                                                Positioned(
                                                  top: MediaQuery.of(context).size.height*(12/930),
                                                  left: MediaQuery.of(context).size.width*(12/462),
                                                  child: Obx(()=>Text(purchase_account.value.toString(),textAlign:TextAlign.center,style: TextStyle(
                                                    fontFamily: 'DotGothic16',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 40,
                                                  ),)),
                                                ),

                                              ],
                                            )
                                        ),
                                      ),
                                      Positioned(
                                        top: MediaQuery.of(context).size.height*(53/930),
                                        left: MediaQuery.of(context).size.width*(250/462),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height*(40/930),
                                          width: MediaQuery.of(context).size.width*(40/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Shop_Purchase_Add_Button),
                                              InkWell(
                                                onTap: (){
                                                  if(purchase_account.value<99 && (purchase_account.value+1)*itemCoin.value<=player.coin.value){
                                                    purchase_account.value+=1;
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: MediaQuery.of(context).size.height*(100/930),
                                        left: MediaQuery.of(context).size.width*(250/462),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height*(40/930),
                                          width: MediaQuery.of(context).size.width*(40/462),
                                          child: Stack(
                                            children: [
                                              Image.asset(Shop_Purchase_Sub_Button),
                                              InkWell(
                                                onTap: (){
                                                  if(purchase_account.value>0){
                                                    purchase_account.value-=1;
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: MediaQuery.of(context).size.height*(100/930),
                                        left: MediaQuery.of(context).size.width*(300/462),
                                        child: Container(
                                            height: MediaQuery.of(context).size.height*(40/930),
                                            width: MediaQuery.of(context).size.width*(70/462),
                                            child: Stack(
                                              children: [
                                                Image.asset(Shop_Purchase_Ok_Button),
                                                InkWell(
                                                  onTap: (){
                                                    player.coin.value-=itemCoin.value*purchase_account.value;
                                                    Database.updateSomething(emailName: player.emailName.value, target: 'Coin', data: player.coin.value);
                                                    for(int i=0;i<purchase_account.value;i++){
                                                      if(itemMP.value == 5){
                                                        Database.addBagItem(emailName: player.emailName.value, imagePath1: itemImg1.value, imagePath2: itemImg2.value,imagePath3: itemImg3.value,content: itemContent.value, type: itemType.value, STR: itemSTR.value, INT: itemINT.value, VIT: itemVIT.value,MP: itemMP.value,EXP: itemEXP.value, coin: itemCoin.value,index: 0, playerEquipped: false,mark: 'Items');
                                                      }
                                                      else {
                                                        Database.addBagItem(emailName: player.emailName.value, imagePath1: itemImg1.value, imagePath2: itemImg2.value,imagePath3: itemImg3.value,content: itemContent.value, type: itemType.value, STR: itemSTR.value, INT: itemINT.value, VIT: itemVIT.value,MP: itemMP.value,EXP: itemEXP.value, coin: itemCoin.value,index: 1, playerEquipped: false,mark: 'Items');
                                                      }
                                                      
                                                    }
                                                    itemImg1 = NoImg.obs;
                                                    itemImg2 = ''.obs;
                                                    itemImg3 = ''.obs;
                                                    itemSTR = 0.obs;
                                                    itemINT = 0.obs;
                                                    itemVIT = 0.obs;
                                                    itemCoin = 0.obs;
                                                    itemId = ''.obs;
                                                    itemType = ''.obs;
                                                    itemMark = ''.obs;
                                                    itemContent.value='';
                                                    itemMP.value=0;
                                                    itemEXP.value=0;
                                                    itemOwned = false.obs;
                                                    setState(() {
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            )
                                        ),
                                      ),
                                      Positioned(
                                        top: MediaQuery.of(context).size.height*(13/930),
                                        left: MediaQuery.of(context).size.width*(340/462),
                                        child: Container(
                                            height: MediaQuery.of(context).size.height*(40/930),
                                            width: MediaQuery.of(context).size.width*(70/462),
                                            child: Stack(
                                              children: [
                                                Image.asset(Shop_Purchase_Close_Button),
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      default: return Container();
    }
  }

  Container skillPage(int index) {
    switch(index){
      case 0: return Container(
        child: Stack(
          children: [
            Image.asset(Skill_STR_UI),
            Positioned(
              top: MediaQuery.of(context).size.height*(70/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_STR_0),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(62/930),
                            width: MediaQuery.of(context).size.width*(250/462),
                            child: Text('消耗 ${STR_Easy.mp.value}點 MP\n下次攻擊傷害+ ${STR_Easy.value.value} %\n升級所需點數： ${STR_Easy.sp.value} SP',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(STR_Easy.status.value,'STR-Easy',STR_Easy.lv.value,STR_Easy.sp.value,STR_Easy.mp.value,3,STR_Easy.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(227/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_STR_1),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(62/930),
                            width: MediaQuery.of(context).size.width*(250/462),
                            child: Text('消耗 ${STR_Mid.mp.value}點 MP\n下次攻擊以 ${STR_Mid.value.value} % 機率獲得隨機武器\n升級所需點數： ${STR_Mid.sp.value} SP',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(STR_Mid.status.value,'STR-Mid',STR_Mid.lv.value,STR_Mid.sp.value,STR_Mid.mp.value,0,STR_Mid.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(385/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_STR_2),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(62/930),
                            width: MediaQuery.of(context).size.width*(250/462),
                            child: Text('消耗 ${STR_Hard.mp.value}點 MP\n格檔一次魔物的傷害\n',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(STR_Hard.status.value,'STR-Hard',STR_Hard.lv.value,STR_Hard.sp.value,STR_Hard.mp.value,1,STR_Hard.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      case 1: return Container(
        child: Stack(
          children: [
            Image.asset(Skill_INT_UI),
            Positioned(
              top: MediaQuery.of(context).size.height*(70/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_INT_0),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(62/930),
                            width: MediaQuery.of(context).size.width*(250/462),
                            child: Text('消耗 ${INT_Easy.mp.value}點 MP\n下次獲得經驗值+ ${INT_Easy.value.value} %\n升級所需點數： ${INT_Easy.sp.value} SP',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(INT_Easy.status.value,'INT-Easy',INT_Easy.lv.value,INT_Easy.sp.value,INT_Easy.mp.value,3,INT_Easy.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(227/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_INT_1),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(62/930),
                            width: MediaQuery.of(context).size.width*(250/462),
                            child: Text('消耗 ${INT_Mid.mp.value}點 MP\n下次攻擊以 ${INT_Mid.value.value} % 機率獲得隨機道具\n升級所需點數： ${INT_Mid.sp.value} SP',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(INT_Mid.status.value,'INT-Mid',INT_Mid.lv.value,INT_Mid.sp.value,INT_Mid.mp.value,0,INT_Mid.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(385/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_INT_2),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(62/930),
                            width: MediaQuery.of(context).size.width*(250/462),
                            child: Text('消耗 ${INT_Hard.mp.value}點 MP\n下次死亡不會受到懲罰\n',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(INT_Hard.status.value,'INT-Hard',INT_Hard.lv.value,INT_Hard.sp.value,INT_Hard.mp.value,1,INT_Hard.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      case 2: return Container(
        child: Stack(
          children: [
            Image.asset(Skill_VIT_UI),
            Positioned(
              top: MediaQuery.of(context).size.height*(70/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_VIT_0),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            width: 250,
                            height: 62,
                            child: Text('消耗 ${VIT_Easy.mp.value}點 MP\n下次獲得金幣+ ${VIT_Easy.value.value} %\n升級所需點數： ${VIT_Easy.sp.value} SP',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(VIT_Easy.status.value,'VIT-Easy',VIT_Easy.lv.value,VIT_Easy.sp.value,VIT_Easy.mp.value,3,VIT_Easy.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(227/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_VIT_1),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(62/930),
                            width: MediaQuery.of(context).size.width*(250/462),
                            child: Text('消耗 ${VIT_Mid.mp.value}點 MP\n下次攻擊以 ${VIT_Mid.value.value} % 機率獲得隨機飾品\n升級所需點數： ${VIT_Mid.sp.value} SP',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(VIT_Mid.status.value,'VIT-Mid',VIT_Mid.lv.value,VIT_Mid.sp.value,VIT_Mid.mp.value,0,VIT_Mid.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(385/930),
              left: MediaQuery.of(context).size.width*(21/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(160/930),
                width: MediaQuery.of(context).size.width*(420/462),
                child: Stack(
                  children: [
                    Image.asset(Skill_item_UI),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(22/930),
                      left: MediaQuery.of(context).size.width*(26/462),
                      child: Container(
                        height: MediaQuery.of(context).size.height*(110/930),
                        width: MediaQuery.of(context).size.width*(110/462),
                        child: Image.asset(Skill_Icon_VIT_2),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height*(20/930),
                          left: MediaQuery.of(context).size.width*(150/462),
                          child: Container(
                            height: MediaQuery.of(context).size.height*(62/930),
                            width: MediaQuery.of(context).size.width*(250/462),
                            child: Text('消耗 ${VIT_Hard.mp.value}點 MP\n獲得額外一次攻擊機會\n',style: TextStyle(
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xffe3a06d),
                            ),),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height*(95/930),
                          left: MediaQuery.of(context).size.width*(140/462),
                          child: getSkillBottomBar(VIT_Hard.status.value,'VIT-Hard',VIT_Hard.lv.value,VIT_Hard.sp.value,VIT_Hard.mp.value,1,VIT_Hard.value.value),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      default: return Container(
        child: Stack(
          children: [
            Image.asset(Skill_STR_UI),
          ],
        ),
      );
    }
  }

  Image getAttribute(int index) {
    switch(index){
      case 0: return Image.asset(Train_Item_STR_Symbol,scale: 1.2,);
      case 1: return Image.asset(Train_Item_INT_Symbol,scale: 1.2,);
      case 2: return Image.asset(Train_Item_VIT_Symbol,scale: 1.2,);
      default: return Image.asset(Train_Item_STR_Symbol);
    }
  }

  //0 date 1 battle 2 interest 3 death
  Container getLogItem(int index,String content1,String content2) {
    switch(index){
      case 0: return Container(
        height: MediaQuery.of(context).size.height*(30/930),
        width: MediaQuery.of(context).size.width*(200/462),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height*(10/930),
              child: Image.asset(Log_SplitLine),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(-5/930),
                left: MediaQuery.of(context).size.width*(165/462),
              child: AutoSizeText(content1,textAlign:TextAlign.center,style: TextStyle(
                color: Color(0xff874b1b),
                fontFamily: 'DotGothic16',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),)
            ),
          ],
        ),
      );
      case 1: return Container(
        height: MediaQuery.of(context).size.height*(80/930),
        width: MediaQuery.of(context).size.width*(200/462),
        child: Stack(
          children: [
            Image.asset(Log_BattleLog),
            Positioned(
                top: MediaQuery.of(context).size.height*(2/930),
                left: MediaQuery.of(context).size.width*(65/462),
                child: Text(content1,textAlign:TextAlign.center,style: TextStyle(
                  color: Color(0xff874b1b),
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(35/930),
                left: MediaQuery.of(context).size.width*(75/462),
                child: Text(content2,textAlign:TextAlign.center,style: TextStyle(
                  color: Color(0xff874b1b),
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)
            ),
          ],
        ),
      );
      case 2: return Container(
        height: MediaQuery.of(context).size.height*(80/930),
        width: MediaQuery.of(context).size.width*(200/462),
        child: Stack(
          children: [
            Image.asset(Log_TrainLog),
            Positioned(
                top: MediaQuery.of(context).size.height*(2/930),
                left: MediaQuery.of(context).size.width*(65/462),
                child: Text(content1,textAlign:TextAlign.center,style: TextStyle(
                  color: Color(0xff874b1b),
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(35/930),
                left: MediaQuery.of(context).size.width*(75/462),
                child: Text(content2,textAlign:TextAlign.center,style: TextStyle(
                  color: Color(0xff874b1b),
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)
            ),
          ],
        ),
      );
      case 3: return Container(
        height: MediaQuery.of(context).size.height*(80/930),
        width: MediaQuery.of(context).size.width*(200/462),
        child: Stack(
          children: [
            Image.asset(Log_DeadLog),
            Positioned(
                top: MediaQuery.of(context).size.height*(2/930),
                left: MediaQuery.of(context).size.width*(65/462),
                child: Text(content1,textAlign:TextAlign.center,style: TextStyle(
                  color: Color(0xff874b1b),
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*(35/930),
                left: MediaQuery.of(context).size.width*(75/462),
                child: Text(content2,textAlign:TextAlign.center,style: TextStyle(
                  color: Color(0xff874b1b),
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)
            ),
          ],
        ),
      );
      default: return Container();
    }
  }

  Container getOwnedOrCoin(playerOwned,coin) {
    if(playerOwned){
      return Container(
        height: 50,
        width: 130,
        child: Image.asset(Shop_OwnedMark),
      );
    }
    else{
      return Container(
        height: 50,
        width: 130,
        child: Row(
          children: [
            SizedBox(width: 30,),
            Image.asset(CharacterStatus_Coin,scale: 1.3,),
            SizedBox(width: 10,),
            AutoSizeText(coin.toString(),textAlign:TextAlign.center,style: TextStyle(
              fontFamily: 'DotGothic16',
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color(0xffe3a16d),
            ),)
          ],
        ),
      );
    }
  }

  Container getEquipOrNot(playerEquipped) {
    if(playerEquipped){
      return Container(
        height: MediaQuery.of(context).size.height*(50/930),
        width: MediaQuery.of(context).size.width*(130/462),
        child: Image.asset(Bag_Item_EquippedMark),
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height*(50/930),
        width: MediaQuery.of(context).size.width*(130/462),
        color: Color(0xffa65413),
      );
    }
  }

  Container getLVUPAvailiable(bool status,String skillName,int nowLV,int needSp,int nowValue,int skillLv){
    if(status && skillLv==3 || skillLv == 0){
      if(nowLV<99){
        return Container(
            height: 40,
            width: 40,
            child: Stack(
              children: [
                Image.asset(Skill_item_LVUP_Button),
                InkWell(
                  onTap: (){
                    player.sp.value-=needSp;
                    if(skillName == 'STR-Easy'){
                      STR_Easy.lv.value+=1;
                      STR_Easy.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: STR_Easy.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: STR_Easy.value.value);
                      Database.getDataToSTR_Easy();
                    }
                    else if(skillName == 'STR-Mid'){
                      STR_Mid.lv.value+=1;
                      STR_Mid.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: STR_Mid.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: STR_Mid.value.value);
                    }
                    else if(skillName == 'STR-Hard'){
                      STR_Hard.lv.value+=1;
                      STR_Hard.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: STR_Hard.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: STR_Hard.value.value);
                    }
                    else if(skillName == 'INT-Easy'){
                      INT_Easy.lv.value+=1;
                      INT_Easy.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: INT_Easy.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: INT_Easy.value.value);
                    }
                    else if(skillName == 'INT-Mid'){
                      INT_Mid.lv.value+=1;
                      INT_Mid.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: INT_Mid.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: INT_Mid.value.value);
                    }
                    else if(skillName == 'INT-Hard'){
                      INT_Hard.lv.value+=1;
                      INT_Hard.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: INT_Hard.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: INT_Hard.value.value);
                    }
                    else if(skillName == 'VIT-Easy'){
                      VIT_Easy.lv.value+=1;
                      VIT_Easy.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: VIT_Easy.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: VIT_Easy.value.value);
                    }
                    else if(skillName == 'VIT-Mid'){
                      VIT_Mid.lv.value+=1;
                      VIT_Mid.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: VIT_Mid.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: VIT_Mid.value.value);
                    }
                    else if(skillName == 'VIT-Hard'){
                      VIT_Hard.lv.value+=1;
                      VIT_Hard.value.value+=1;
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Lv', data: VIT_Hard.lv.value);
                      Database.updateSkill(emailName: player.emailName.value, skillName: skillName, target: 'Value', data: VIT_Hard.value.value);
                    }
                    Database.updateSomething(emailName: player.emailName.value, target: 'sp', data: player.sp.value);
                    if(STR_Hard.status.value==2){
                      if(STR_Easy.lv.value>=50 && STR_Mid.lv.value>=30){
                        STR_Hard.status.value=1;
                        Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard',  target: 'Status', data: 1);
                      }
                    }
                    if(INT_Hard.status.value==2){
                      if(INT_Easy.lv.value>=50 && INT_Mid.lv.value>=30){
                        INT_Hard.status.value=1;
                        Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard',  target: 'Status', data: 1);
                      }
                    }
                    if(VIT_Hard.status.value==2){
                      if(VIT_Easy.lv.value>=50 && VIT_Mid.lv.value>=30){
                        VIT_Hard.status.value=1;
                        Database.updateSkill(emailName: player.emailName.value, skillName: 'VIT-Hard',  target: 'Status', data: 1);
                      }
                    }
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else{
        return Container(
          height: 40,
          width: 40,
          child: Image.asset(Skill_item_LVUP_UnUse),
        );
      }
    }
    else{
      if(skillLv==1){
        return Container(
          height: 40,
          width: 40,
        );
      }
      else{
        return Container(
          height: 40,
          width: 40,
          child: Image.asset(Skill_item_LVUP_UnUse),
        );
      }
    }
  }

  Container getUseAvailiable(bool status,String skillName,int needMp){
    if(status){
      if(skillName == 'STR-Easy' && !STR_Easy.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    STR_Easy.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Easy', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else if(skillName == 'STR-Mid' && !STR_Mid.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    STR_Mid.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Mid', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else if(skillName == 'STR-Hard' && !STR_Hard.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    STR_Hard.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else if(skillName == 'INT-Easy' && !INT_Easy.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    INT_Easy.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Easy', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else if(skillName == 'INT-Mid' && !INT_Mid.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    INT_Mid.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Mid', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else if(skillName == 'INT-Hard' && !INT_Hard.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    INT_Hard.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else if(skillName == 'VIT-Easy' && !VIT_Easy.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    VIT_Easy.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'VIT-Easy', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else if(skillName == 'VIT-Mid' && !VIT_Mid.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    VIT_Mid.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'VIT-Mid', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else if(skillName == 'VIT-Hard' && !VIT_Hard.use.value){
        return Container(
            height: MediaQuery.of(context).size.height*(40/930),
            width: MediaQuery.of(context).size.width*(70/462),
            child: Stack(
              children: [
                Image.asset(Skill_item_Use_Button),
                InkWell(
                  onTap: (){
                    player.mp.value -= needMp;
                    VIT_Hard.use.value=true;
                    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
                    Database.updateSkill(emailName: player.emailName.value, skillName: 'VIT-Hard', target: 'Use', data: true);
                    setState(() {

                    });
                  },
                )
              ],
            )
        );
      }
      else{
        return Container(
          height: MediaQuery.of(context).size.height*(40/930),
          width: MediaQuery.of(context).size.width*(70/462),
          child: Image.asset(Skill_item_Use_UnUse),
        );
      }
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height*(40/930),
        width: MediaQuery.of(context).size.width*(70/462),
        child: Image.asset(Skill_item_Use_UnUse),
      );
    }
  }

  //0: Mid 1: Hard
  Container getPrecondition(int status){
    switch(status){
      case 0: return Container(
        width: 150,
        height: 60,
        child: Text('角色等級LV10以上',textAlign:TextAlign.center,style: TextStyle(
          fontFamily: 'DotGothic16',
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Color(0xffe3a06d),
        ),),
      );
      case 1: return Container(
        width: 150,
        height: 60,
        child: Text('初級技能LV50以上\n中級技能LV30以上',textAlign:TextAlign.center,style: TextStyle(
          fontFamily: 'DotGothic16',
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Color(0xffe3a06d),
        ),),
      );
      default: return Container(
        width: 150,
        height: 20,
        color: Colors.green,
        child: Text('角色等級需達到10等以上',textAlign:TextAlign.center,style: TextStyle(
          fontFamily: 'DotGothic16',
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Color(0xffe3a06d),
        ),),
      );
    }
  }

  //0:can use 1:can learn 2:can't learn
  Container getSkillBottomBar(int skillStatus,String skillName,int lv,int sp,int mp,int skillLV,int skillValue){
    final player = Get.put(PlayerController());
    switch(skillStatus){
      case 0: return Container(
        height: MediaQuery.of(context).size.height*(40/930),
        width: MediaQuery.of(context).size.width*(270/462),
        child: Row(
          children: [
            SizedBox(width: 5,),
            Image.asset(Skill_item_LV_Text),
            SizedBox(width: 15,),
            Container(
              child: Stack(
                children: [
                  Image.asset(Skill_item_LV_TextBox),
                  Positioned(
                    top: MediaQuery.of(context).size.height*(-2/930),
                    left: MediaQuery.of(context).size.width*(-3/462),
                    child: Container(
                      height: MediaQuery.of(context).size.height*(35/930),
                      width: MediaQuery.of(context).size.width*(50/462),
                      child: Text(lv.toString(),textAlign:TextAlign.center,style: TextStyle(
                        fontFamily: 'DotGothic16',
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),),
                    ),
                  ),
                ],
              )
            ),
            SizedBox(width: 10,),
            getLVUPAvailiable((player.sp.value>=sp),skillName,lv,sp,skillValue,skillLV),
            SizedBox(width: 25,),
            getUseAvailiable((player.mp.value>=mp),skillName,mp),
          ],
        ),
      );
      case 1: return Container(
        height: MediaQuery.of(context).size.height*(40/930),
        width: MediaQuery.of(context).size.width*(270/462),
        child: Row(
          children: [
            SizedBox(width: 5,),
            Text('已可學習',textAlign:TextAlign.center,style: TextStyle(
              fontFamily: 'DotGothic16',
              fontWeight: FontWeight.w500,
              fontSize: 25,
              color: Color(0xffe3a06d),
            ),),
            SizedBox(width: 20,),
            Container(
              height: MediaQuery.of(context).size.height*(40/930),
              width: MediaQuery.of(context).size.width*(70/462),
              child: Stack(
                children: [
                  Image.asset(Skill_item_Get_Button),
                  InkWell(
                    onTap: (){
                      Database.updateSkill(emailName: player.emailName.value,skillName: skillName, target: 'Status', data: 0);
                      setState(() {

                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      );
      case 2: return Container(
        height: MediaQuery.of(context).size.height*(50/930),
        width: MediaQuery.of(context).size.width*(270/462),
        child: Row(
          children: [
            SizedBox(width: 5,),
            getPrecondition(skillLV),
            SizedBox(width: 20),
            Container(
              height: MediaQuery.of(context).size.height*(40/930),
              width: MediaQuery.of(context).size.width*(70/462),
              child: Stack(
                children: [
                  Image.asset(Skill_item_Get_UnUse),
                ],
              ),
            ),
          ],
        ),
      );
      default: return Container();
    }
  }

  //0:R 1:B 2:G 3:R-成就 4:B-成就 5:G-成就 6:玩家成就
  Container getAchievement(int type,String name,String date){
    switch(type){
      case 0: return Container(
        height: MediaQuery.of(context).size.height*(180/930),
        width: MediaQuery.of(context).size.width*(170/462),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*(53/462),
              child: Image.asset(Achievement_N_R,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(140/930),
              left: MediaQuery.of(context).size.width*(10/462),
              child: Image.asset(Achievement_SignBoard,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(160/930),
              left: MediaQuery.of(context).size.width*(25/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(40/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: AutoSizeText(name,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff000000),
                ),),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(40/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(20/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: Text(date,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xffe3a06d),
                ),),
              ),
            ),
          ],
        ),
      );
      case 1: return Container(
        height: MediaQuery.of(context).size.height*(180/930),
        width: MediaQuery.of(context).size.width*(170/462),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*(53/462),
              child: Image.asset(Achievement_N_B,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(140/930),
              left: MediaQuery.of(context).size.width*(10/462),
              child: Image.asset(Achievement_SignBoard,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(160/930),
              left: MediaQuery.of(context).size.width*(25/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(40/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: AutoSizeText(name,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff000000),
                ),),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(40/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(20/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: Text(date,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xffe3a06d),
                ),),
              ),
            ),
          ],
        ),
      );
      case 2: return Container(
        height: MediaQuery.of(context).size.height*(180/930),
        width: MediaQuery.of(context).size.width*(170/462),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*(53/462),
              child: Image.asset(Achievement_N_G,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(140/930),
              left: MediaQuery.of(context).size.width*(10/462),
              child: Image.asset(Achievement_SignBoard,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(160/930),
              left: MediaQuery.of(context).size.width*(25/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(40/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: AutoSizeText(name,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff000000),
                ),),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(40/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(20/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: Text(date,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xffe3a06d),
                ),),
              ),
            ),
          ],
        ),
      );
      case 3: return Container(
        height: 180,
        width: 170,
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*(25/462),
              child: Image.asset(Achievement_P_R,scale: 1.3,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(140/930),
              left: MediaQuery.of(context).size.width*(10/462),
              child: Image.asset(Achievement_SignBoard,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(160/930),
              left: MediaQuery.of(context).size.width*(25/462),
              child: Container(
                width: 100,
                height: 40,
                child: AutoSizeText(name,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff000000),
                ),),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(40/462),
              child: Container(
                width: 100,
                height: 20,
                child: Text(date,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xffe3a06d),
                ),),
              ),
            ),
          ],
        ),
      );
      case 4: return Container(
        height: MediaQuery.of(context).size.height*(180/930),
        width: MediaQuery.of(context).size.width*(170/462),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*(25/462),
              child: Image.asset(Achievement_P_B,scale: 1.3,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(140/930),
              left: MediaQuery.of(context).size.width*(10/462),
              child: Image.asset(Achievement_SignBoard,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(160/930),
              left: MediaQuery.of(context).size.width*(25/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(40/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: AutoSizeText(name,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff000000),
                ),maxLines: 1,),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(40/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(20/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: Text(date,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xffe3a06d),
                ),),
              ),
            ),
          ],
        ),
      );
      case 5: return Container(
        height: MediaQuery.of(context).size.height*(180/930),
        width: MediaQuery.of(context).size.width*(170/462),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*(25/462),
              child: Image.asset(Achievement_P_G,scale: 1.3,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(140/930),
              left: MediaQuery.of(context).size.width*(10/462),
              child: Image.asset(Achievement_SignBoard,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(160/930),
              left: MediaQuery.of(context).size.width*(25/462),
              child: Container(
                width: 100,
                height: 40,
                child: AutoSizeText(name,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff000000),
                ),),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(40/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(20/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: Text(date,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xffe3a06d),
                ),),
              ),
            ),
          ],
        ),
      );
      case 6: return Container(
        height: MediaQuery.of(context).size.height*(180/930),
        width: MediaQuery.of(context).size.width*(170/462),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*(25/462),
              child: Image.asset(Achievement_Player,scale: 1.4,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(140/930),
              left: MediaQuery.of(context).size.width*(10/462),
              child: Image.asset(Achievement_SignBoard,scale: 1.1,),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(160/930),
              left: MediaQuery.of(context).size.width*(25/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(40/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: AutoSizeText(name,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff000000),
                ),),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(40/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(20/930),
                width: MediaQuery.of(context).size.width*(100/462),
                child: Text(date,textAlign:TextAlign.center,style: TextStyle(
                  fontFamily: 'DotGothic16',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xffe3a06d),
                ),),
              ),
            ),
          ],
        ),
      );
      default: return Container(
        height: 180,
        width: 140,
      );
    }
  }

  Container getBuyButton(bool canBuy, String mark,String id){
    if(canBuy && mark!='Items'){
      return Container(
        height: MediaQuery.of(context).size.height*(90/930),
        width: MediaQuery.of(context).size.width*(185/462),
        child: Stack(
          children: [
            Image.asset(Shop_Buy_Button),
            InkWell(
              onTap: (){
                  if(mark=='Weapon'){
                    player.weaponShopCount.value=player.weaponShopCount.value-1;
                    Database.updateSomething(emailName: player.emailName.value, target: 'WeaponShopCount', data: player.weaponShopCount.value);
                  }
                  else if(mark=='Accessories'){
                    player.accessoriesShopCount.value=player.accessoriesShopCount.value-1;
                    Database.updateSomething(emailName: player.emailName.value, target: 'AccessoriesShopCount', data: player.accessoriesShopCount.value);
                  }
                  player.coin.value-=itemCoin.value;
                  Database.updateSomething(emailName: player.emailName.value, target: 'Coin', data: player.coin.value);
                  Database.buyItem(emailName: player.emailName.value, docId: itemId.value,mark: mark);
                  Database.addBagItem(emailName: player.emailName.value, imagePath1: itemImg1.value, imagePath2: itemImg2.value,imagePath3: itemImg3.value,content: '', type: itemType.value, STR: itemSTR.value, INT: itemINT.value, VIT: itemVIT.value,MP:0,EXP:0, coin: itemCoin.value,index: itemIndex.value, playerEquipped: false,mark: mark);
                  itemImg1.value = NoImg;
                  itemImg2.value = '';
                  itemImg3.value = '';
                  itemSTR.value = 0;
                  itemINT.value = 0;
                  itemVIT.value = 0;
                  itemCoin.value = 0;
                  itemId.value = '';
                  itemType.value = '';
                  itemMark.value = '';
                  itemIndex.value =0;
                  itemOwned.value = false;
                  setState(() {
                  });
              },
            )
          ],
        ),
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height*(90/930),
        width: MediaQuery.of(context).size.width*(185/462),
        child: Stack(
          children: [
            Image.asset(Shop_Buy_Button_Unuse),
          ],
        ),
      );
    }
  }

  Container getEquipButton(bool canEquip,String mark){
    if(!canEquip){
      return Container(
        height: MediaQuery.of(context).size.height*(185/930),
        width: MediaQuery.of(context).size.width*(185/462),
        child: Stack(
          children: [
            Image.asset(Bag_Equip_Button),
            InkWell(
              onTap: (){
                Database.equipItem(emailName: player.emailName.value, docId: itemId.value, imagePath1: itemImg1.value, imagePath2: itemImg2.value, imagePath3: itemImg3.value, type: itemType.value, STR: itemSTR.value, INT: itemINT.value, VIT: itemVIT.value,mark: mark);
                itemImg1 = NoImg.obs;
                itemImg2 = ''.obs;
                itemImg3 = ''.obs;
                itemSTR = 0.obs;
                itemINT = 0.obs;
                itemVIT = 0.obs;
                itemCoin = 0.obs;
                itemId = ''.obs;
                itemType = ''.obs;
                itemMark = ''.obs;
                itemOwned = false.obs;
                setState(() {

                });
              },
            )
          ],
        ),
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height*(185/930),
        width: MediaQuery.of(context).size.width*(185/462),
        child: Stack(
          children: [
            Image.asset(Bag_Unload_Button),
            InkWell(
              onTap: (){
                Database.unloadItem(emailName: player.emailName.value, docId: itemId.value, type: itemType.value, STR: itemSTR.value, INT: itemINT.value, VIT: itemVIT.value,mark: mark);
                itemImg1 = NoImg.obs;
                itemImg2 = ''.obs;
                itemImg3 = ''.obs;
                itemSTR = 0.obs;
                itemINT = 0.obs;
                itemVIT = 0.obs;
                itemCoin = 0.obs;
                itemId = ''.obs;
                itemType = ''.obs;
                itemMark = ''.obs;
                itemOwned = false.obs;
                setState(() {

                });
              },
            )
          ],
        ),
      );
    }
  }

  Container getShopTryOn(String type,String image){
    if(type == 'Mouth'){
      return Container(
        height: MediaQuery.of(context).size.height*(250/930),
        width: MediaQuery.of(context).size.width*(250/462),
        child: Stack(
          children: [
            Obx(()=>Image.asset(player.backHairImg.value)), //backHair
            Obx(()=>Image.asset(player.headBodyImg.value)), //headBody
            Obx(()=>Image.asset(player.earsImg.value)), //ears
            Obx(()=>Image.asset(player.eyesImg.value)), //eyes
            Obx(()=>Image.asset(player.eyeDecorationImg.value)),
            Obx(()=>Image.asset(player.foreHairImg.value)), //foreHair
            Obx(()=>Image.asset(player.clothesImg.value)), //clothes
            Image.asset(image), //mouth
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(65/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(32/930),
                width: MediaQuery.of(context).size.width*(100/462),
                color: Color(0xffffbf8a),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(236/930),
              left: MediaQuery.of(context).size.width*(65/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(3/930),
                width: MediaQuery.of(context).size.width*(100/462),
                color: Color(0xffbd6925),
              ),
            ),
          ],
        ),
      );
    }
    else if(type == 'Eyes'){
      return Container(
        height: MediaQuery.of(context).size.height*(250/930),
        width: MediaQuery.of(context).size.width*(250/462),
        child: Stack(
          children: [
            Obx(()=>Image.asset(player.backHairImg.value)), //backHair
            Obx(()=>Image.asset(player.headBodyImg.value)), //headBody
            Obx(()=>Image.asset(player.earsImg.value)), //ears
            Image.asset(image), //eyes
            Obx(()=>Image.asset(player.eyeDecorationImg.value)),
            Obx(()=>Image.asset(player.foreHairImg.value)), //foreHair
            Obx(()=>Image.asset(player.clothesImg.value)), //clothes
            Obx(()=>Image.asset(player.mouthImg.value)), //mouth
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(65/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(32/930),
                width: MediaQuery.of(context).size.width*(100/462),
                color: Color(0xffffbf8a),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(236/930),
              left: MediaQuery.of(context).size.width*(65/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(3/930),
                width: MediaQuery.of(context).size.width*(100/462),
                color: Color(0xffbd6925),
              ),
            ),
          ],
        ),
      );
    }
    else if(type == 'Ears'){
      return Container(
        height: MediaQuery.of(context).size.height*(250/930),
        width: MediaQuery.of(context).size.width*(250/462),
        child: Stack(
          children: [
            Obx(()=>Image.asset(player.backHairImg.value)), //backHair
            Obx(()=>Image.asset(player.headBodyImg.value)), //headBody
            Image.asset(image), //ears
            Obx(()=>Image.asset(player.eyesImg.value)), //eyes
            Obx(()=>Image.asset(player.eyeDecorationImg.value)),
            Obx(()=>Image.asset(player.foreHairImg.value)), //foreHair
            Obx(()=>Image.asset(player.clothesImg.value)), //clothes
            Obx(()=>Image.asset(player.mouthImg.value)), //mouth
            Positioned(
              top: MediaQuery.of(context).size.height*(205/930),
              left: MediaQuery.of(context).size.width*(65/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(32/930),
                width: MediaQuery.of(context).size.width*(100/462),
                color: Color(0xffffbf8a),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(236/930),
              left: MediaQuery.of(context).size.width*(65/462),
              child: Container(
                height: MediaQuery.of(context).size.height*(3/930),
                width: MediaQuery.of(context).size.width*(100/462),
                color: Color(0xffbd6925),
              ),
            ),
          ],
        ),
      );
    }
    else{
      return Container();
    }
  }
}

