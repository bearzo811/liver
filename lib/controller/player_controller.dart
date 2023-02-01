import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liver_final/constants/image_path.dart';
import 'package:liver_final/service/database.dart';

class PlayerController extends GetxController{

  RxString emailName = ''.obs;
  RxString playerName= ''.obs;
  RxBool outfitDone= false.obs;
  RxBool nameDone= false.obs;
  RxString backHairImg= ''.obs;
  RxString headBodyImg= ''.obs;
  RxString earsImg= ''.obs;
  RxString eyesImg= ''.obs;
  RxString foreHairImg= ''.obs;
  RxString pantsImg= ''.obs;
  RxString clothesImg= ''.obs;
  RxString mouthImg= ''.obs;
  RxString shoesImg= ''.obs;
  RxString lightWeaponImg= ''.obs;
  RxString heavyWeaponHandleImg= ''.obs;
  RxString heavyWeaponHeadImg= ''.obs;
  RxString eyeDecorationImg =''.obs;
  RxString backItemImg = ''.obs;
  RxString liverImg = ''.obs;

  RxString initBackHairImg= ''.obs;
  RxString initHeadBodyImg= ''.obs;
  RxString initEarsImg= ''.obs;
  RxString initEyesImg= ''.obs;
  RxString initForeHairImg= ''.obs;
  RxString initPantsImg= ''.obs;
  RxString initClothesImg= ''.obs;
  RxString initMouthImg= ''.obs;
  RxString initShoesImg= ''.obs;
  
  RxInt hp =0.obs;
  RxDouble mp=0.0.obs;
  RxDouble exp=0.0.obs;
  RxInt maxHp=0.obs;
  RxDouble maxMp=0.0.obs;
  RxDouble maxExp=0.0.obs;
  RxInt lv=0.obs;
  RxDouble coin=0.0.obs;
  RxDouble STR =0.0.obs;
  RxDouble INT = 0.0.obs;
  RxDouble VIT = 0.0.obs;
  RxInt LogCount =0.obs;
  RxInt AchievementCount =0.obs;
  RxDouble hpRatio=0.0.obs;
  RxDouble mpRatio=0.0.obs;
  RxDouble expRatio=0.0.obs;
  RxInt backHairType=0.obs;
  RxInt backHair=0.obs;
  RxInt headBody=0.obs;
  RxInt earsType=0.obs;
  RxInt eyesType=0.obs;
  RxInt ears=0.obs;
  RxInt eyes=0.obs;
  RxInt foreHairType=0.obs;
  RxInt foreHair=1.obs;
  RxInt pants=0.obs;
  RxInt clothes=0.obs;
  RxInt mouth=0.obs;
  RxInt shoes=0.obs;
  RxInt lightWeapon=0.obs;
  RxInt heavyWeaponHead=0.obs;
  RxInt heavyWeaponHandle=0.obs;
  RxInt taskCount=0.obs;
  RxBool log_date_done = false.obs;
  RxString latestDate =''.obs;
  RxInt sp = 0.obs;
  RxInt monsterRCount =0.obs;
  RxInt monsterBCount =0.obs;
  RxInt monsterGCount =0.obs;
  Random random = new Random();
  int randomNumber = 0;
  RxInt weaponShopCount = 0.obs;
  RxInt accessoriesShopCount = 0.obs;
  RxInt itemShopCount = 0.obs;
  RxBool getWeapon = false.obs;
  RxBool getAccessories = false.obs;
  RxBool getItems = false.obs;

  RxInt monsterRLV = 1.obs;
  RxInt monsterBLV = 1.obs;
  RxInt monsterGLV = 1.obs;

  void setHpRatio(){
    this.hpRatio.value=this.hp.value.toDouble()/this.maxHp.value.toDouble();
  }

  void setMpRatio(){
    this.mpRatio.value=this.mp.value.toDouble()/this.maxMp.value.toDouble();
  }

  void setExpRatio(){
    this.expRatio.value=this.exp.value.toDouble()/this.maxExp.value.toDouble();
  }

  void attackMonster(String monsterType){
    final monsterR = Get.put(MonsterRController());
    final monsterB = Get.put(MonsterBController());
    final monsterG = Get.put(MonsterGController());
    final STR_Easy = Get.put(Skill_STR_Easy());
    final STR_Mid = Get.put(Skill_STR_Mid());
    final INT_Easy = Get.put(Skill_INT_Easy());
    final INT_Mid = Get.put(Skill_INT_Mid());
    final VIT_Easy = Get.put(Skill_VIT_Easy());
    final VIT_Mid = Get.put(Skill_VIT_Mid());
    final VIT_Hard = Get.put(Skill_VIT_Hard());
    double damage=0.0;
    double getExp = 0.0;
    double getCoin = 0.0;
    int nowMonsterRCount=monsterRCount.value;
    int nowMonsterBCount=monsterBCount.value;
    int nowMonsterGCount=monsterGCount.value;
    if(monsterType=='monsterR'){
      if(STR_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=STR_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Weapon');
          getWeapon.value=true;
        }
        STR_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'STR-Mid', target: 'Use', data: false);
      }
      if(INT_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=INT_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Items');
          getItems.value=true;
        }
        INT_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'INT-Mid', target: 'Use', data: false);
      }
      if(VIT_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=VIT_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Accessories');
          getAccessories.value=true;
        }
        VIT_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Mid', target: 'Use', data: false);
      }

      if(!VIT_Hard.use.value){
        monsterR.canBeAttack.value=false;
        Database.updateMonster(emailName: emailName.value, type: 'Exercise', target: 'CanBeAttack', data: false);
      }
      else{
        VIT_Hard.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Hard', target: 'Use', data: false);
      }
      if(!STR_Easy.use.value){
        damage=STR.value;
      }
      else{
        damage=STR.value*(1+(STR_Easy.value.value/100));
        STR_Easy.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'STR-Easy', target: 'Use', data: false);
      }
      Database.addLog(emailName.value, '${playerName.value} 攻擊了 ${monsterR.name.value} ' , '造成了 ${damage.toInt()}點傷害', 1 ,LogCount.value);
      LogCount.value+=1;
      Database.updateSomething(emailName: emailName.value, target: 'LogCount', data: LogCount.value);
      monsterR.hp.value-=damage;
      Database.updateMonster(emailName: emailName.value, type: 'Exercise', target: 'Hp', data: monsterR.hp.value);
      if(monsterR.hp.value<=0){
        monsterRLV.value=monsterRLV.value+1;
        Database.updateSomething(emailName: emailName.value, target: 'monsterRLV', data: monsterRLV.value);
        monsterRCount.value=monsterRCount.value+1;
        print('xxxxxxxxxx${monsterRCount.value}');
        Database.updateSomething(emailName: emailName.value, target: 'monsterRCount', data: monsterRCount.value);
        if(!INT_Easy.use.value){
          getExp=monsterR.exp.value;
        }
        else{
          getExp=monsterR.exp.value*(1+(INT_Easy.value.value/100));
          INT_Easy.use.value=false;
          Database.updateSkill(emailName: emailName.value, skillName: 'INT-Easy', target: 'Use', data: false);
        }
        if(!VIT_Easy.use.value){
          getCoin=monsterR.coin.value;
        }
        else{
          getCoin=monsterR.coin.value*(1+(VIT_Easy.value.value/100));
          VIT_Easy.use.value=false;
          Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Easy', target: 'Use', data: false);
        }

        Database.addLog(emailName.value,  ' 恭喜！！擊敗了 ${monsterB.name.value}','獲得 ${(getExp).toInt()}點EXP，${(getCoin).toInt()}個金幣，3 SP' , 1 ,LogCount.value);
        LogCount.value+=1;
        Database.updateSomething(emailName: emailName.value, target: 'LogCount', data: LogCount.value);

        Database.addAchievement(emailName.value, monsterR.name.value, DateFormat('yyyy-MM-dd').format(DateTime.now()), 0, AchievementCount.value);
        AchievementCount.value+=1;
        Database.updateSomething(emailName: emailName.value, target: 'AchievementCount', data: AchievementCount.value);

        Database.delMonster(emailName: emailName.value, type: 'Exercise');
        monsterR.image.value='';
        playergetEXPCoin(getCoin, getExp);
      }
      else{
        monsterR.setHpRatio();
      }
    }
    else if(monsterType=='monsterB'){
      if(STR_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=STR_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Weapon');
          getWeapon.value=true;
        }
        STR_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'STR-Mid', target: 'Use', data: false);
      }
      if(INT_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=INT_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Items');
          getItems.value=true;
        }
        INT_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'INT-Mid', target: 'Use', data: false);
      }
      if(VIT_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=VIT_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Accessories');
          getAccessories.value=true;
        }
        VIT_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Mid', target: 'Use', data: false);
      }

      if(!VIT_Hard.use.value){
        monsterB.canBeAttack.value=false;
        Database.updateMonster(emailName: emailName.value, type: 'Learning', target: 'CanBeAttack', data: false);
      }
      else{
        VIT_Hard.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Hard', target: 'Use', data: false);
      }
      if(!STR_Easy.use.value){
        damage=INT.value;
      }
      else{
        damage=INT.value*(1+(STR_Easy.value.value/100));
        STR_Easy.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'STR-Easy', target: 'Use', data: false);
      }
      Database.addLog(emailName.value, '${playerName.value} 攻擊了 ${monsterB.name.value} ' , '造成了 ${damage.toInt()}點傷害', 1 ,LogCount.value);
      LogCount.value+=1;
      Database.updateSomething(emailName: emailName.value, target: 'LogCount', data: LogCount.value);
      monsterB.hp.value-=damage;
      Database.updateMonster(emailName: emailName.value, type: 'Learning', target: 'Hp', data: monsterB.hp.value);
      if(monsterB.hp.value<=0){
        monsterBLV.value=monsterBLV.value+1;
        Database.updateSomething(emailName: emailName.value, target: 'monsterBLV', data: monsterBLV.value);
        monsterBCount.value=monsterBCount.value+1;
        print('xxxxxxxxxx${monsterBCount.value}');
        Database.updateSomething(emailName: emailName.value, target: 'monsterBCount', data: monsterBCount.value);
        monsterBCount.value+=1;
        if(!INT_Easy.use.value){
          getExp=monsterB.exp.value;
        }
        else{
          getExp=monsterB.exp.value*(1+(INT_Easy.value.value/100));
          INT_Easy.use.value=false;
          Database.updateSkill(emailName: emailName.value, skillName: 'INT-Easy', target: 'Use', data: false);
        }
        if(!VIT_Easy.use.value){
          getCoin=monsterB.coin.value;
        }
        else{
          getCoin=monsterB.coin.value*(1+(VIT_Easy.value.value/100));
          VIT_Easy.use.value=false;
          Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Easy', target: 'Use', data: false);
        }
        Database.addLog(emailName.value,  ' 恭喜！！擊敗了 ${monsterB.name.value}','獲得 ${(getExp).toInt()}點EXP，${(getCoin).toInt()}個金幣，3 SP' , 1 ,LogCount.value);
        LogCount.value+=1;
        Database.updateSomething(emailName: emailName.value, target: 'LogCount', data: LogCount.value);

        Database.addAchievement(emailName.value, monsterB.name.value, DateFormat('yyyy-MM-dd').format(DateTime.now()), 1, AchievementCount.value);
        AchievementCount.value+=1;
        Database.updateSomething(emailName: emailName.value, target: 'AchievementCount', data: AchievementCount.value);

        Database.delMonster(emailName: emailName.value, type: 'Learning');
        monsterB.image.value='';

        playergetEXPCoin(getCoin, getExp);
      }
      else{
        monsterB.setHpRatio();
      }
    }
    else if(monsterType=='monsterG'){
      if(STR_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=STR_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Weapon');
          getWeapon.value=true;
        }
        STR_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'STR-Mid', target: 'Use', data: false);
      }
      if(INT_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=INT_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Items');
          getItems.value=true;
        }
        INT_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'INT-Mid', target: 'Use', data: false);
      }
      if(VIT_Mid.use.value){
        randomNumber = random.nextInt(101)+1;
        if(randomNumber<=VIT_Mid.value.value){
          Database.getShopItem(emailName: emailName.value, type: 'Accessories');
          getAccessories.value=true;
        }
        VIT_Mid.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Mid', target: 'Use', data: false);
      }

      if(!VIT_Hard.use.value){
        monsterG.canBeAttack.value=false;
        Database.updateMonster(emailName: emailName.value, type: 'Life', target: 'CanBeAttack', data: false);
      }
      else{
        VIT_Hard.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Hard', target: 'Use', data: false);
      }
      if(!STR_Easy.use.value){
        damage=VIT.value;
      }
      else{
        damage=VIT.value*(1+(STR_Easy.value.value/100));
        STR_Easy.use.value=false;
        Database.updateSkill(emailName: emailName.value, skillName: 'STR-Easy', target: 'Use', data: false);
      }
      Database.addLog(emailName.value, '${playerName.value} 攻擊了 ${monsterG.name.value} ' , '造成了 ${damage.toInt()}點傷害', 1 ,LogCount.value);
      LogCount.value+=1;
      Database.updateSomething(emailName: emailName.value, target: 'LogCount', data: LogCount.value);
      monsterG.hp.value-=damage;
      Database.updateMonster(emailName: emailName.value, type: 'Life', target: 'Hp', data: monsterG.hp.value);
      if(monsterG.hp.value<=0){
        monsterGLV.value=monsterGLV.value+1;
        Database.updateSomething(emailName: emailName.value, target: 'monsterGLV', data: monsterGLV.value);
        monsterGCount.value+=1;
        monsterGCount.value=monsterGCount.value+1;
        print('xxxxxxxxxx${monsterGCount.value}');
        Database.updateSomething(emailName: emailName.value, target: 'monsterGCount', data: monsterGCount.value);
        if(!INT_Easy.use.value){
          getExp=monsterG.exp.value;
        }
        else{
          getExp=monsterG.exp.value*(1+(INT_Easy.value.value/100));
          INT_Easy.use.value=false;
          Database.updateSkill(emailName: emailName.value, skillName: 'INT-Easy', target: 'Use', data: false);
        }
        if(!VIT_Easy.use.value){
          getCoin=monsterG.coin.value;
        }
        else{
          getCoin=monsterG.coin.value*(1+(VIT_Easy.value.value/100));
          VIT_Easy.use.value=false;
          Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Easy', target: 'Use', data: false);
        }
        Database.addLog(emailName.value,  ' 恭喜！！擊敗了 ${monsterG.name.value}','獲得 ${(getExp).toInt()}點EXP，${(getCoin).toInt()}個金幣，3 SP' , 1 ,LogCount.value);
        LogCount.value+=1;
        Database.updateSomething(emailName: emailName.value, target: 'LogCount', data: LogCount.value);

        Database.addAchievement(emailName.value, monsterG.name.value, DateFormat('yyyy-MM-dd').format(DateTime.now()), 2, AchievementCount.value);
        AchievementCount.value+=1;
        Database.updateSomething(emailName: emailName.value, target: 'AchievementCount', data: AchievementCount.value);

        Database.delMonster(emailName: emailName.value, type: 'Life');
        monsterG.image.value='';
        playergetEXPCoin(getCoin, getExp);
      }
      else{
        monsterG.setHpRatio();
      }
    }

    if(monsterRCount.value>=10 && nowMonsterRCount<10){
      Database.addAchievement(emailName.value,'擊敗紅魔物*10', DateFormat('yyyy-MM-dd').format(DateTime.now()), 3, AchievementCount.value);
      AchievementCount.value+=1;
      Database.updateSomething(emailName: emailName.value, target: 'AchievementCount', data: AchievementCount.value);
    }
    if(monsterBCount.value>=10 && nowMonsterBCount<10){
      Database.addAchievement(emailName.value,'擊敗藍魔物*10', DateFormat('yyyy-MM-dd').format(DateTime.now()), 4, AchievementCount.value);
      AchievementCount.value+=1;
      Database.updateSomething(emailName: emailName.value, target: 'AchievementCount', data: AchievementCount.value);
    }
    if(monsterGCount.value>=10 && nowMonsterGCount<10){
      Database.addAchievement(emailName.value,'擊敗綠魔物*10', DateFormat('yyyy-MM-dd').format(DateTime.now()), 5, AchievementCount.value);
      AchievementCount.value+=1;
      Database.updateSomething(emailName: emailName.value, target: 'AchievementCount', data: AchievementCount.value);
    }
  }

  void playergetEXPCoin(double getCoin,double getExp){
    int nowLV =lv.value;
    final STR_Mid = Get.put(Skill_STR_Mid());
    final INT_Mid = Get.put(Skill_INT_Mid());
    final VIT_Mid = Get.put(Skill_VIT_Mid());
    exp.value+=getExp;
    Database.updateSomething(emailName: emailName.value, target: 'Exp', data: exp.value);
    coin.value+=getCoin;
    Database.updateSomething(emailName: emailName.value, target: 'Coin', data: coin.value);
    if(exp.value>=maxExp.value){
      sp.value+=3;
      lv.value+=1;
      exp.value-=maxExp.value;
      maxExp.value=(lv.value-1)*50;
      if(lv.value<=10){
        maxMp.value=lv.value*5;
      }
      else if(lv.value>10 && lv.value<25){
        maxMp.value=(lv.value*10)-50;
      }
      else if(lv.value>=25){
        maxMp.value=(lv.value*4)+100;
      }
      mp.value=maxMp.value;
      Database.updateSomething(emailName: emailName.value, target: 'MaxMp', data: maxMp.value);
      Database.updateSomething(emailName: emailName.value, target: 'MaxExp', data: maxExp.value);
      Database.updateSomething(emailName: emailName.value, target: 'Mp', data: mp.value);
      Database.updateSomething(emailName: emailName.value, target: 'Exp', data: exp.value);
      Database.updateSomething(emailName: emailName.value, target: 'Lv', data: lv.value);
      Database.updateSomething(emailName: emailName.value, target: 'sp', data: sp.value);
      setExpRatio();
    }
    else{
      setExpRatio();
    }

    if(lv.value>=10 && nowLV<10){

      Database.addAchievement(emailName.value,'達成十級!', DateFormat('yyyy-MM-dd').format(DateTime.now()), 6, AchievementCount.value);
      AchievementCount.value+=1;
      Database.updateSomething(emailName: emailName.value, target: 'AchievementCount', data: AchievementCount.value);

      if(STR_Mid.status.value==2){
        Database.updateSkill(emailName: emailName.value, skillName: 'STR-Mid', target: 'Status', data: 1);
      }
      if(INT_Mid.status.value==2){
        Database.updateSkill(emailName: emailName.value, skillName: 'INT-Mid', target: 'Status', data: 1);
      }
      if(VIT_Mid.status.value==2){
        Database.updateSkill(emailName: emailName.value, skillName: 'VIT-Mid', target: 'Status', data: 1);
      }
    }
    if(lv.value>=20 && nowLV<20){
      Database.addAchievement(emailName.value,'達成二十級!', DateFormat('yyyy-MM-dd').format(DateTime.now()), 6, AchievementCount.value);
      AchievementCount.value+=1;
      Database.updateSomething(emailName: emailName.value, target: 'AchievementCount', data: AchievementCount.value);
    }
  }

}

class MonsterRController extends GetxController{
  @override
  void onInit() {
    image.value='';
    super.onInit();
  }
  RxString name =''.obs;
  RxString type =''.obs;
  RxString image =''.obs;
  RxDouble hp =10.0.obs;
  RxDouble maxHp =10.0.obs;
  RxInt lv =1.obs;
  RxDouble exp =10.0.obs;
  RxDouble coin =10.0.obs;
  RxInt killCount=0.obs;
  RxBool canBeAttack = true.obs;
  RxDouble hpRatio=0.0.obs;

  void setHpRatio(){
    this.hpRatio.value=this.hp.value.toDouble()/this.maxHp.value.toDouble();
  }
}

class MonsterBController extends GetxController{
  @override
  void onInit() {
    image.value='';
    super.onInit();
  }
  RxString name =''.obs;
  RxString type =''.obs;
  RxString image =''.obs;
  RxDouble hp =10.0.obs;
  RxDouble maxHp =10.0.obs;
  RxInt lv =1.obs;
  RxDouble exp =10.0.obs;
  RxDouble coin =10.0.obs;
  RxInt killCount=0.obs;
  RxBool canBeAttack = true.obs;
  RxDouble hpRatio=0.0.obs;

  void setHpRatio(){
    this.hpRatio.value=this.hp.value.toDouble()/this.maxHp.value.toDouble();
  }
}

class MonsterGController extends GetxController{
  @override
  void onInit() {
    image.value='';
    super.onInit();
  }
  RxString name =''.obs;
  RxString type =''.obs;
  RxString image =''.obs;
  RxDouble hp =10.0.obs;
  RxDouble maxHp =10.0.obs;
  RxInt lv =1.obs;
  RxDouble exp =10.0.obs;
  RxDouble coin =10.0.obs;
  RxInt killCount=0.obs;
  RxBool canBeAttack = true.obs;
  RxDouble hpRatio=0.0.obs;

  void setHpRatio(){
    this.hpRatio.value=this.hp.value.toDouble()/this.maxHp.value.toDouble();
  }
}

class Skill_STR_Easy extends GetxController{

  String image = Skill_Icon_STR_0;
  String name = 'STR-Easy';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}

class Skill_STR_Mid extends GetxController{

  String image = Skill_Icon_STR_0;
  String name = 'STR-Mid';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}

class Skill_STR_Hard extends GetxController{

  String image = Skill_Icon_STR_2;
  String name = 'STR-Hard';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}

class Skill_INT_Easy extends GetxController{

  String image = Skill_Icon_INT_0;
  String name = 'INT-Easy';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}

class Skill_INT_Mid extends GetxController{

  String image = Skill_Icon_INT_0;
  String name = 'INT-Mid';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}

class Skill_INT_Hard extends GetxController{

  String image = Skill_Icon_INT_2;
  String name = 'INT-Hard';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}

class Skill_VIT_Easy extends GetxController{

  String image = Skill_Icon_VIT_0;
  String name = 'VIT_Easy';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}

class Skill_VIT_Mid extends GetxController{

  String image = Skill_Icon_VIT_0;
  String name = 'VIT-Mid';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}

class Skill_VIT_Hard extends GetxController{

  String image = Skill_Icon_VIT_2;
  String name = 'VIT-Hard';
  RxInt lv =0.obs;
  RxInt mp =5.obs;
  RxInt sp =0.obs;
  RxInt value =0.obs;
  RxInt status =0.obs;
  RxBool use = false.obs;
}