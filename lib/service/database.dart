import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liver_final/constants/image_path.dart';
import 'package:liver_final/constants/set_part.dart';
import 'package:liver_final/controller/player_controller.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Database{

  static Future<void> addUser(emailName) async{
    final snapShot = await _firestore.collection('user').doc(emailName).get();
    if(!snapShot.exists){
      await _firestore.collection('user').doc(emailName).set({
        'EmailName' : emailName,
        'PlayerName': 'player1',
        'OutfitDone' : false,
        'NameDone' : false,
        'BackHairImg': setBackHairImg(type: 0, color: 0),
        'HeadBodyImg': setHeadBodyImg(color: 0),
        'EarsImg': setEarsImg(type: 0, color: 0),
        'EyesImg': setEyesImg(type: 0, color: 0),
        'ForeHairImg': setForeHairImg(type: 1, color: 0),
        'PantsImg': setPantsImg(color: 0),
        'ClothesImg': setClothesImg(color: 0),
        'MouthImg': setMouthImg(type: 0),
        'ShoesImg': setShoesImg(color: 0),
        'EyeDecorationImg' : NoImg,
        'BackItemImg' : NoImg,
        'LiverImg' : Liver_og,
        
        'initBackHairImg': '',
        'initHeadBodyImg': '',
        'initEarsImg': '',
        'initEyesImg': '',
        'initForeHairImg': '',
        'initPantsImg': '',
        'initClothesImg': '',
        'initMouthImg': '',
        'initShoesImg': '',
        
        'LightWeaponImg': NoImg,
        'HeavyWeaponHandleImg': NoImg,
        'HeavyWeaponHeadImg': NoImg,
        'Hp' : 1,
        'Mp' : 5.0,
        'Exp' : 0.0,
        'MaxHp' : 1,
        'MaxMp' : 5.0,
        'MaxExp' : 10.0,
        'STR' : 1.0,
        'INT' : 1.0,
        'VIT' : 1.0,
        'Lv' : 1,
        'Coin' :0.0,
        'backHairType' :0,
        'backHair' :0,
        'headBody' :0,
        'earsType' :0,
        'eyesType' :0,
        'ears' :0,
        'eyes' :0,
        'foreHairType' :1,
        'foreHair' :0,
        'pants' : 0,
        'clothes' :0,
        'mouth' :0,
        'shoes' :0,
        'lightWeapon':0,
        'heavyWeaponHead' :0,
        'heavyWeaponHandle' :0,
        'LogCount' :0,
        'AchievementCount' :0,
        'log_date_done' : false,
        'latestDate' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'sp' : 0,
        'monsterRCount' :0,
        'monsterBCount' :0,
        'monsterGCount' :0,

        'monsterRLV' :1,
        'monsterBLV' :1,
        'monsterGLV' :1,

        'WeaponShopCount' : 11,
        'AccessoriesShopCount' : 3,
        'ItemShopCount' : 2,
      });
      //upload item to shop
      //weapon type:0
      //STR Weapon
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_LightWeapon_0, imagePath2: LightWeapon_0, imagePath3: '',content: '', type: 'LightWeapon', STR: 5, INT: 0, VIT: 0,MP: 0,EXP: 0, coin: 100,index: 0, playerOwned: false,mark: 'Weapon');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_LightWeapon_3, imagePath2: LightWeapon_3, imagePath3: '',content: '', type: 'LightWeapon', STR: 10, INT: 0, VIT: 0,MP: 0,EXP: 0, coin: 200,index: 1, playerOwned: false,mark: 'Weapon');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_HeavyWeapon_0, imagePath2: Heavy_Weapon_Handle_0, imagePath3: NoImg,content: '', type: 'HeavyWeapon', STR: 30, INT: 0, VIT: 0,MP: 0,EXP: 0, coin: 600,index: 2, playerOwned: false,mark: 'Weapon');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_HeavyWeapon_1, imagePath2: Heavy_Weapon_Handle_1, imagePath3: NoImg,content: '', type: 'HeavyWeapon', STR: 50, INT: 0, VIT: 0,MP: 0,EXP: 0, coin: 1000,index: 3, playerOwned: false,mark: 'Weapon');
      //INT Weapon
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_LightWeapon_1, imagePath2: LightWeapon_1, imagePath3: '',content: '', type: 'LightWeapon', STR: 0, INT: 5, VIT: 0,MP: 0,EXP: 0, coin: 100,index: 4, playerOwned: false,mark: 'Weapon');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_LightWeapon_2, imagePath2: LightWeapon_2, imagePath3: '',content: '', type: 'LightWeapon', STR: 0, INT: 25, VIT: 0,MP: 0,EXP: 0, coin: 500,index: 5, playerOwned: false,mark: 'Weapon');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_LightWeapon_4, imagePath2: LightWeapon_4, imagePath3: '',content: '', type: 'LightWeapon', STR: 0, INT: 50, VIT: 0,MP: 0,EXP: 0, coin: 1000,index: 6, playerOwned: false,mark: 'Weapon');
      //VIT Weapon
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_HeavyWeapon_2, imagePath2: Heavy_Weapon_Handle_2, imagePath3: Heavy_Weapon_Head_2,content: '', type: 'HeavyWeapon', STR: 0, INT: 0, VIT: 5,MP: 0,EXP: 0, coin: 100,index: 7, playerOwned: false,mark: 'Weapon');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_HeavyWeapon_3, imagePath2: Heavy_Weapon_Handle_3, imagePath3: Heavy_Weapon_Head_3,content: '', type: 'HeavyWeapon', STR: 0, INT: 0, VIT: 10,MP: 0,EXP: 0, coin: 200,index: 8, playerOwned: false,mark: 'Weapon');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_HeavyWeapon_4, imagePath2: Heavy_Weapon_Handle_4, imagePath3: Heavy_Weapon_Head_4,content: '', type: 'HeavyWeapon', STR: 0, INT: 0, VIT: 30,MP: 0,EXP: 0, coin: 600,index: 9, playerOwned: false,mark: 'Weapon');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_HeavyWeapon_5, imagePath2: Heavy_Weapon_Handle_5, imagePath3: Heavy_Weapon_Head_5,content: '', type: 'HeavyWeapon', STR: 0, INT: 0, VIT: 50,MP: 0,EXP: 0, coin: 1000,index: 10, playerOwned: false,mark: 'Weapon');
      //armors type:1
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Clothes_0, imagePath2: Clothes_0, imagePath3: '', content: '', type: 'Clothes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 0, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Clothes_1, imagePath2: Clothes_1, imagePath3: '', content: '', type: 'Clothes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 1, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Clothes_2, imagePath2: Clothes_2, imagePath3: '', content: '', type: 'Clothes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 2, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Clothes_3, imagePath2: Clothes_3, imagePath3: '', content: '', type: 'Clothes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 3, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Clothes_4, imagePath2: Clothes_4, imagePath3: '', content: '', type: 'Clothes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 4, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Clothes_5, imagePath2: Clothes_5, imagePath3: '', content: '', type: 'Clothes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 5, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Clothes_6, imagePath2: Clothes_6, imagePath3: '', content: '', type: 'Clothes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 6, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Clothes_7, imagePath2: Clothes_7, imagePath3: '', content: '', type: 'Clothes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 7, playerOwned: false, mark: 'Armors');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_0, imagePath2: Pants_0, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 8, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_1, imagePath2: Pants_1, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 9, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_2, imagePath2: Pants_2, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 10, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_3, imagePath2: Pants_3, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 11, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_4, imagePath2: Pants_4, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 12, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_5, imagePath2: Pants_5, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 13, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_6, imagePath2: Pants_6, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 14, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_7, imagePath2: Pants_7, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 15, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_8, imagePath2: Pants_8, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 16, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_9, imagePath2: Pants_9, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 17, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_10, imagePath2: Pants_10, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 18, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Pants_11, imagePath2: Pants_11, imagePath3: '', content: '', type: 'Pants', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 19, playerOwned: false, mark: 'Armors');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Shoes_0, imagePath2: Shoes_0, imagePath3: '', content: '', type: 'Shoes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 20, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Shoes_1, imagePath2: Shoes_1, imagePath3: '', content: '', type: 'Shoes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 21, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Shoes_2, imagePath2: Shoes_2, imagePath3: '', content: '', type: 'Shoes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 22, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Shoes_3, imagePath2: Shoes_3, imagePath3: '', content: '', type: 'Shoes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 23, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Shoes_4, imagePath2: Shoes_4, imagePath3: '', content: '', type: 'Shoes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 24, playerOwned: false, mark: 'Armors');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Shoes_5, imagePath2: Shoes_5, imagePath3: '', content: '', type: 'Shoes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 80,index: 25, playerOwned: false, mark: 'Armors');

      //accessories type:2
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_EyeDecoration_0, imagePath2: EyeDecoration_0, imagePath3: '', content: '', type: 'EyeDecoration', STR: 3, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 300,index: 0, playerOwned: false, mark: 'Accessories');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_EyeDecoration_1, imagePath2: EyeDecoration_1, imagePath3: '', content: '', type: 'EyeDecoration', STR: 0, INT: 3, VIT: 0, MP: 0, EXP: 0, coin: 300,index: 1, playerOwned: false, mark: 'Accessories');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_BackItem_0, imagePath2: BackItem_0, imagePath3: '', content: '', type: 'BackItem', STR: 0, INT: 0, VIT: 3, MP: 0, EXP: 0, coin: 300,index: 2, playerOwned: false, mark: 'Accessories');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Liver_0, imagePath2: Liver_0, imagePath3: '', content: '', type: 'Liver', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 500,index: 3, playerOwned: false, mark: 'Accessories');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Liver_1, imagePath2: Liver_1, imagePath3: '', content: '', type: 'Liver', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 500,index: 4, playerOwned: false, mark: 'Accessories');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Liver_2, imagePath2: Liver_2, imagePath3: '', content: '', type: 'Liver', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 500,index: 5, playerOwned: false, mark: 'Accessories');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Liver_3, imagePath2: Liver_3, imagePath3: '', content: '', type: 'Liver', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 500,index: 6, playerOwned: false, mark: 'Accessories');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Liver_4, imagePath2: Liver_4, imagePath3: '', content: '', type: 'Liver', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 500,index: 7, playerOwned: false, mark: 'Accessories');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Liver_5, imagePath2: Liver_5, imagePath3: '', content: '', type: 'Liver', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 500,index: 8, playerOwned: false, mark: 'Accessories');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Liver_6, imagePath2: Liver_6, imagePath3: '', content: '', type: 'Liver', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 500,index: 9, playerOwned: false, mark: 'Accessories');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Liver_7, imagePath2: Liver_7, imagePath3: '', content: '', type: 'Liver', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 500,index: 10, playerOwned: false, mark: 'Accessories');
      //body type:3
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_0, imagePath2: Eyes_0_0, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 0, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_1, imagePath2: Eyes_0_1, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 1, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_2, imagePath2: Eyes_0_2, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 2, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_3, imagePath2: Eyes_0_3, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 3, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_4, imagePath2: Eyes_0_4, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 4, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_5, imagePath2: Eyes_0_5, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 5, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_6, imagePath2: Eyes_0_6, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 6, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_7, imagePath2: Eyes_0_7, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 7, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_8, imagePath2: Eyes_0_8, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 8, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_0_9, imagePath2: Eyes_0_9, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 9, playerOwned: false, mark: 'Body');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_0, imagePath2: Eyes_1_0, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 10, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_1, imagePath2: Eyes_1_1, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 11, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_2, imagePath2: Eyes_1_2, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 12, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_3, imagePath2: Eyes_1_3, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 13, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_4, imagePath2: Eyes_1_4, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 14, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_5, imagePath2: Eyes_1_5, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 15, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_6, imagePath2: Eyes_1_6, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 16, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_7, imagePath2: Eyes_1_7, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 17, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_8, imagePath2: Eyes_1_8, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 18, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_1_9, imagePath2: Eyes_1_9, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 19, playerOwned: false, mark: 'Body');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_0, imagePath2: Eyes_2_0, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 20, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_1, imagePath2: Eyes_2_1, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 21, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_2, imagePath2: Eyes_2_2, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 22, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_3, imagePath2: Eyes_2_3, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 23, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_4, imagePath2: Eyes_2_4, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 24, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_5, imagePath2: Eyes_2_5, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 25, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_6, imagePath2: Eyes_2_6, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 26, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_7, imagePath2: Eyes_2_7, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 27, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_8, imagePath2: Eyes_2_8, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 28, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_2_9, imagePath2: Eyes_2_9, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 29, playerOwned: false, mark: 'Body');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_0, imagePath2: Eyes_3_0, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 30, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_1, imagePath2: Eyes_3_1, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 31, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_2, imagePath2: Eyes_3_2, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 32, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_3, imagePath2: Eyes_3_3, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 33, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_4, imagePath2: Eyes_3_4, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 34, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_5, imagePath2: Eyes_3_5, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 35, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_6, imagePath2: Eyes_3_6, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 36, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_7, imagePath2: Eyes_3_7, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 37, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_8, imagePath2: Eyes_3_8, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 38, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Eyes_3_9, imagePath2: Eyes_3_9, imagePath3: '', content: '', type: 'Eyes', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 39, playerOwned: false, mark: 'Body');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_0_0, imagePath2: Ears_0_0, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 40, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_0_1, imagePath2: Ears_0_1, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 41, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_0_2, imagePath2: Ears_0_2, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 42, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_0_3, imagePath2: Ears_0_3, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 43, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_0_4, imagePath2: Ears_0_4, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 44, playerOwned: false, mark: 'Body');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_1_0, imagePath2: Ears_1_0, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 45,playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_1_1, imagePath2: Ears_1_1, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 46, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_1_2, imagePath2: Ears_1_2, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 47, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_1_3, imagePath2: Ears_1_3, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 48, playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Ears_1_4, imagePath2: Ears_1_4, imagePath3: '', content: '', type: 'Ears', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 49, playerOwned: false, mark: 'Body');

      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Mouth_0, imagePath2: Mouth_0, imagePath3: '', content: '', type: 'Mouth', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 50,playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Mouth_1, imagePath2: Mouth_1, imagePath3: '', content: '', type: 'Mouth', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 51,playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Mouth_2, imagePath2: Mouth_2, imagePath3: '', content: '', type: 'Mouth', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 52,playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Mouth_3, imagePath2: Mouth_3, imagePath3: '', content: '', type: 'Mouth', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 53,playerOwned: false, mark: 'Body');
      Database.addShopItem(emailName: emailName, imagePath1: Thumbnail_Mouth_4, imagePath2: Mouth_4, imagePath3: '', content: '', type: 'Mouth', STR: 0, INT: 0, VIT: 0, MP: 0, EXP: 0, coin: 50,index: 54,playerOwned: false, mark: 'Body');

      //items type:4
      Database.addShopItem(emailName: emailName, imagePath1: Item_MPPotion, imagePath2: '', imagePath3: '',content: '回復 5 MP', type: 'Potion', STR: 0, INT: 0, VIT: 0,MP: 5,EXP: 0, coin: 30,index: 0, playerOwned: false,mark: 'Items');
      Database.addShopItem(emailName: emailName, imagePath1: Item_EXPPotion, imagePath2: '', imagePath3: '',content: '得到 5 EXP', type: 'Potion', STR: 0, INT: 0, VIT: 0,MP: 0,EXP: 5, coin: 30,index: 1, playerOwned: false,mark: 'Items');

      //upload all skill
      //STR
      //easy
      Database.addSkill(emailName: emailName, skillName: 'STR-Easy', lv: 0, mp: 5, value: 1,  sp: 1,   status: 0,use: false);
      //normal
      Database.addSkill(emailName: emailName, skillName: 'STR-Mid', lv: 0, mp: 50, value: 1,  sp: 3,   status: 2,use: false);
      //hard
      Database.addSkill(emailName: emailName, skillName: 'STR-Hard', lv: 1, mp: 200, value: 0,  sp: 1,   status: 2,use: false);
      //INT
      //easy
      Database.addSkill(emailName: emailName, skillName: 'INT-Easy', lv: 0, mp: 5, value: 1,  sp: 1,   status: 0,use: false);
      //normal
      Database.addSkill(emailName: emailName, skillName: 'INT-Mid', lv: 0, mp: 50, value: 1,  sp: 3,   status: 2,use: false);
      //hard
      Database.addSkill(emailName: emailName, skillName: 'INT-Hard', lv: 1, mp: 200, value: 0,  sp: 1,  status: 2,use: false);
      //VIT
      //easy
      Database.addSkill(emailName: emailName, skillName: 'VIT-Easy', lv: 0, mp: 5, value: 1,  sp: 1,  status: 0,use: false);
      //normal
      Database.addSkill(emailName: emailName, skillName: 'VIT-Mid', lv: 0, mp: 50, value: 1,  sp: 3,   status: 2,use: false);
      //hard
      Database.addSkill(emailName: emailName, skillName: 'VIT-Hard', lv: 1, mp: 200, value: 0,  sp: 1,   status: 2,use: false);

    }
  }

  static Future<void> getDataToController(emailName) async{
    final player = Get.put(PlayerController());
    await _firestore.collection('user').where('EmailName',isEqualTo: emailName).get().then((value){
      value.docs.forEach((element) {
        player.emailName.value=element['EmailName'];
        player.playerName.value=element['PlayerName'];
        player.outfitDone.value=element['OutfitDone'];
        player.nameDone.value=element['NameDone'];
        player.backHairImg.value=element['BackHairImg'];
        player.headBodyImg.value=element['HeadBodyImg'];
        player.earsImg.value=element['EarsImg'];
        player.eyesImg.value=element['EyesImg'];
        player.foreHairImg.value=element['ForeHairImg'];
        player.pantsImg.value=element['PantsImg'];
        player.clothesImg.value=element['ClothesImg'];
        player.mouthImg.value=element['MouthImg'];
        player.shoesImg.value=element['ShoesImg'];
        player.lightWeaponImg.value=element['LightWeaponImg'];
        player.heavyWeaponHandleImg.value=element['HeavyWeaponHandleImg'];
        player.heavyWeaponHeadImg.value=element['HeavyWeaponHeadImg'];
        player.hp.value=element['Hp'];
        player.mp.value=element['Mp'];
        player.exp.value=element['Exp'];
        player.maxHp.value=element['MaxHp'];
        player.maxMp.value=element['MaxMp'];
        player.maxExp.value=element['MaxExp'];
        player.STR.value=element['STR'];
        player.INT.value=element['INT'];
        player.VIT.value=element['VIT'];
        player.maxExp.value=element['MaxExp'];
        player.maxExp.value=element['MaxExp'];
        player.lv.value=element['Lv'];
        player.coin.value=element['Coin'];
        player.backHairType.value=element['backHairType'];
        player.backHair.value=element['backHair'];
        player.headBody.value=element['headBody'];
        player.earsType.value=element['earsType'];
        player.ears.value=element['ears'];
        player.eyesType.value=element['eyesType'];
        player.eyes.value=element['eyes'];
        player.foreHairType.value=element['foreHairType'];
        player.foreHair.value=element['foreHair'];
        player.pants.value=element['pants'];
        player.clothes.value=element['clothes'];
        player.mouth.value=element['mouth'];
        player.shoes.value=element['shoes'];
        player.lightWeapon.value=element['lightWeapon'];
        player.heavyWeaponHandle.value=element['heavyWeaponHandle'];
        player.heavyWeaponHead.value=element['heavyWeaponHead'];
        player.LogCount.value=element['LogCount'];
        player.log_date_done.value=element['log_date_done'];
        player.latestDate.value=element['latestDate'];
        player.sp.value=element['sp'];
        player.monsterRCount.value=element['monsterRCount'];
        player.monsterBCount.value=element['monsterBCount'];
        player.monsterGCount.value=element['monsterGCount'];
        player.initBackHairImg.value=element['initBackHairImg'];
        player.initHeadBodyImg.value=element['initHeadBodyImg'];
        player.initEarsImg.value=element['initEarsImg'];
        player.initEyesImg.value=element['initEyesImg'];
        player.initForeHairImg.value=element['initForeHairImg'];
        player.initPantsImg.value=element['initPantsImg'];
        player.initClothesImg.value=element['initClothesImg'];
        player.initMouthImg.value=element['initMouthImg'];
        player.initShoesImg.value=element['initShoesImg'];
        player.eyeDecorationImg.value=element['EyeDecorationImg'];
        player.backItemImg.value = element['BackItemImg'];
        player.weaponShopCount.value = element['WeaponShopCount'];
        player.accessoriesShopCount.value = element['AccessoriesShopCount'];
        player.itemShopCount.value = element['ItemShopCount'];
        player.monsterRLV.value = element['monsterRLV'];
        player.monsterBLV.value = element['monsterBLV'];
        player.monsterGLV.value = element['monsterGLV'];
        player.liverImg.value=element['LiverImg'];
        player.update();
      });
    });
  }

  static Future<void> updateSomething({required String emailName,required String target,required dynamic data}) async{
    Map<String,dynamic> updates ={
      '${target}' : data,
    };
    await _firestore.collection('user').doc(emailName).update(updates);
    getDataToController(emailName);
  }

  static Future<void> updateSkill({required String emailName,required String skillName,required String target,required dynamic data}) async{
    Map<String,dynamic> updates ={
      '${target}' : data,
    };
    await _firestore.collection('user').doc(emailName).collection('skill').doc(skillName).update(updates);
  }

  static Future<void> updateMonster({required String emailName,required String type,required String target,required dynamic data}) async{
    Map<String,dynamic> updates ={
      '${target}' : data,
    };
    await _firestore.collection('user').doc(emailName).collection('monster').doc(type).update(updates);
  }

  static Future<void> delMonster({required String emailName,required String type}) async{
    await _firestore.collection('user').doc(emailName).collection('monster').doc(type).delete();
  }

  static Future<void> addTrain(emailName,trainName,attribute,coin,exp) async{
    final snapShot = await _firestore.collection('user').doc(emailName).collection('train').doc(trainName).get();
    if(!snapShot.exists){
      await _firestore.collection('user').doc(emailName).collection('train').add({
        'TrainName':trainName,
        'Attribute':attribute,
        'Counter':0,
        'Coin':coin,
        'Exp':exp,
      });
    }
  }

  static Future<void> delTrain(emailName,docId) async{
    await _firestore.collection('user').doc(emailName).collection('train').doc(docId).delete();
  }

  static Future<void> addCounter({required String emailName,required String docId,required int nowCounter}) async{
    Map<String,dynamic> updates ={
      'Counter' : nowCounter+1,
    };
    await _firestore.collection('user').doc(emailName).collection('train').doc(docId).update(updates);
  }

  static Future<void> addLog(emailName,content1,content2,type,index) async{
    await _firestore.collection('user').doc(emailName).collection('log').add({
      'Content1':content1,
      'Content2':content2,
      'Type':type,
      'Index': index,
    });
  }

  static Future<void> addShopItem({required String emailName,required String imagePath1,required String imagePath2,required String imagePath3,required String content,required String type,required int STR,required int INT,required int VIT,required int MP,required int EXP,required int coin,required int index,required bool playerOwned,required String mark}) async{
    await _firestore.collection('user').doc(emailName).collection('shop').doc(mark).collection(mark).add({
      'Image1' : imagePath1,
      'Image2' : imagePath2,
      'Image3' : imagePath3,
      'Content' :content,
      'Type' : type,
      'STR' : STR,
      'INT' : INT,
      'VIT' : VIT,
      'MP' : MP,
      'EXP' : EXP,
      'Coin' : coin,
      'Index' : index,
      'PlayerOwned' : playerOwned,
    });
  }

  static Future<void> buyItem({required String emailName,required String docId,required String mark}) async{
    print(docId);
    await _firestore.collection('user').doc(emailName).collection('shop').doc(mark).collection(mark).doc(docId).delete();
  }

  static Future<void> delExistArmors({required String emailName}) async{
    final player = Get.put(PlayerController());
    await _firestore.collection('user').doc(emailName).collection('shop').doc('Armors').collection('Armors').get().then((value){
      value.docs.forEach((element) {
        if(element['Image2']==player.initHeadBodyImg.value){
          _firestore.collection('user').doc(emailName).collection('shop').doc('Armors').collection('Armors').doc(element.id).delete();
        }
        else if(element['Image2']==player.initForeHairImg.value){
          _firestore.collection('user').doc(emailName).collection('shop').doc('Armors').collection('Armors').doc(element.id).delete();
        }
        else if(element['Image2']==player.initBackHairImg.value){
          _firestore.collection('user').doc(emailName).collection('shop').doc('Armors').collection('Armors').doc(element.id).delete();
        }
        else if(element['Image2']==player.initClothesImg.value){
          _firestore.collection('user').doc(emailName).collection('shop').doc('Armors').collection('Armors').doc(element.id).delete();
        }
        else if(element['Image2']==player.initPantsImg.value){
          _firestore.collection('user').doc(emailName).collection('shop').doc('Armors').collection('Armors').doc(element.id).delete();
        }
        else if(element['Image2']==player.initShoesImg.value){
          _firestore.collection('user').doc(emailName).collection('shop').doc('Armors').collection('Armors').doc(element.id).delete();
        }
      });
    });
    await _firestore.collection('user').doc(emailName).collection('shop').doc('Body').collection('Body').get().then((value){
      value.docs.forEach((element) {
        if(element['Image2']==player.initEarsImg.value){
        _firestore.collection('user').doc(emailName).collection('shop').doc('Body').collection('Body').doc(element.id).delete();
        }
        else if(element['Image2']==player.initEyesImg.value){
        _firestore.collection('user').doc(emailName).collection('shop').doc('Body').collection('Body').doc(element.id).delete();
        }
        else if(element['Image2']==player.initMouthImg.value){
        _firestore.collection('user').doc(emailName).collection('shop').doc('Body').collection('Body').doc(element.id).delete();
        }
      });
    });
  }

  static Future<void> addBagItem({required String emailName,required String imagePath1,required String imagePath2,required String imagePath3,required String content,required String type,required int STR,required int INT,required int VIT,required int MP,required int EXP,required int coin,required int index,required bool playerEquipped,required String mark}) async{
    await _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).add({
      'Image1' : imagePath1,
      'Image2' : imagePath2,
      'Image3' : imagePath3,
      'Content' :content,
      'Type' : type,
      'STR' : STR,
      'INT' : INT,
      'VIT' : VIT,
      'MP' : MP,
      'EXP' : EXP,
      'Coin' : coin,
      'Index' : index,
      'PlayerEquipped' : playerEquipped,
    });
  }

  static Future<void> equipItem({required String emailName,required String docId,required String imagePath1,required String imagePath2,required String imagePath3,required String type,required int STR,required int INT,required int VIT,required String mark}) async{
    final player = Get.put(PlayerController());
    if(mark == 'Weapon'){
      await _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).get().then((value){
        value.docs.forEach((element) {
          if(element['PlayerEquipped']){
            Map<String,dynamic> updates ={
              'PlayerEquipped' : false,
            };
            _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(element.id).update(updates);
            player.STR.value-=(element['STR']as num).toInt();
            player.INT.value-=(element['INT']as num).toInt();
            player.VIT.value-=(element['VIT']as num).toInt();
          }
        });
      });
      Map<String,dynamic> updates ={
        'PlayerEquipped' : true,
      };
      _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(docId).update(updates);
      player.lightWeaponImg.value=NoImg;
      player.heavyWeaponHandleImg.value=NoImg;
      player.heavyWeaponHeadImg.value=NoImg;
      Database.updateSomething(emailName: player.emailName.value, target: 'LightWeaponImg', data: NoImg);
      Database.updateSomething(emailName: player.emailName.value, target: 'HeavyWeaponHandleImg', data: NoImg);
      Database.updateSomething(emailName: player.emailName.value, target: 'HeavyWeaponHeadImg', data: NoImg);

      if(type == 'LightWeapon'){
        Database.updateSomething(emailName: player.emailName.value, target: 'LightWeaponImg', data: imagePath2);
      }
      if(type == 'HeavyWeapon'){
        Database.updateSomething(emailName: player.emailName.value, target: 'HeavyWeaponHandleImg', data: imagePath2);
        Database.updateSomething(emailName: player.emailName.value, target: 'HeavyWeaponHeadImg', data: imagePath3);
      }

      player.STR.value+=STR;
      player.INT.value+=INT;
      player.VIT.value+=VIT;
      Database.updateSomething(emailName: player.emailName.value, target: 'STR', data: player.STR.value);
      Database.updateSomething(emailName: player.emailName.value, target: 'INT', data: player.INT.value);
      Database.updateSomething(emailName: player.emailName.value, target: 'VIT', data: player.VIT.value);
      Database.getDataToController(player.emailName.value);
      player.update();
    }
    else if(mark=='Armors' || mark=='Body'){
      await _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).get().then((value){
        value.docs.forEach((element) {
          if(element['Type']==type && element['PlayerEquipped']){
            Map<String,dynamic> updates ={
              'PlayerEquipped' : false,
            };
            _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(element.id).update(updates);
            player.STR.value-=(element['STR']as num).toInt();
            player.INT.value-=(element['INT']as num).toInt();
            player.VIT.value-=(element['VIT']as num).toInt();
          }
        });
      });
      Map<String,dynamic> updates ={
        'PlayerEquipped' : true,
      };
      _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(docId).update(updates);
      Database.updateSomething(emailName: player.emailName.value, target: '${type}Img', data: imagePath2);

      player.STR.value+=STR;
      player.INT.value+=INT;
      player.VIT.value+=VIT;
      Database.updateSomething(emailName: player.emailName.value, target: 'STR', data: player.STR.value);
      Database.updateSomething(emailName: player.emailName.value, target: 'INT', data: player.INT.value);
      Database.updateSomething(emailName: player.emailName.value, target: 'VIT', data: player.VIT.value);
      Database.getDataToController(player.emailName.value);
      player.update();
    }
    else if(mark=='Accessories'){
      await _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).get().then((value){
        value.docs.forEach((element) {
          if(element['Type']==type && element['PlayerEquipped']){
            Map<String,dynamic> updates ={
              'PlayerEquipped' : false,
            };
            _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(element.id).update(updates);
            player.STR.value-=(element['STR']as num).toInt();
            player.INT.value-=(element['INT']as num).toInt();
            player.VIT.value-=(element['VIT']as num).toInt();
          }
        });
      });
      Map<String,dynamic> updates ={
        'PlayerEquipped' : true,
      };
      _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(docId).update(updates);
      Database.updateSomething(emailName: player.emailName.value, target: '${type}Img', data: imagePath2);

      player.STR.value+=STR;
      player.INT.value+=INT;
      player.VIT.value+=VIT;
      Database.updateSomething(emailName: player.emailName.value, target: 'STR', data: player.STR.value);
      Database.updateSomething(emailName: player.emailName.value, target: 'INT', data: player.INT.value);
      Database.updateSomething(emailName: player.emailName.value, target: 'VIT', data: player.VIT.value);
      Database.getDataToController(player.emailName.value);
      player.update();
    }
  }

  static Future<void> useItem({required String emailName,required String docId,required String imagePath1,required String imagePath2,required String imagePath3,required String type,required int STR,required int INT,required int VIT,required int MP,required int EXP,required String mark}) async{
    final player = Get.put(PlayerController());
    if(player.mp.value+MP>=player.maxMp.value){
      player.mp.value=player.maxMp.value;
    }
    else{
      player.mp.value=player.mp.value+MP;
    }
    player.playergetEXPCoin(0, EXP.toDouble());
    Database.updateSomething(emailName: player.emailName.value, target: 'Mp', data: player.mp.value);
    Database.getDataToController(player.emailName.value);
    player.update();
    await _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(docId).delete();
  }

  static Future<void> unloadItem({required String emailName,required String docId,required String type,required int STR,required int INT,required int VIT,required String mark}) async{
    final player = Get.put(PlayerController());
    if(mark=='Weapon'){
      await _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).get().then((value){
        value.docs.forEach((element) {
          if(element['PlayerEquipped']){
            Map<String,dynamic> updates ={
              'PlayerEquipped' : false,
            };
            _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(element.id).update(updates);
            player.STR.value-=(element['STR']as num).toInt();
            player.INT.value-=(element['INT']as num).toInt();
            player.VIT.value-=(element['VIT']as num).toInt();
          }
        });
      });
      player.lightWeaponImg.value=NoImg;
      player.heavyWeaponHandleImg.value=NoImg;
      player.heavyWeaponHeadImg.value=NoImg;
      Database.updateSomething(emailName: player.emailName.value, target: 'LightWeaponImg', data: NoImg);
      Database.updateSomething(emailName: player.emailName.value, target: 'HeavyWeaponHandleImg', data: NoImg);
      Database.updateSomething(emailName: player.emailName.value, target: 'HeavyWeaponHeadImg', data: NoImg);

      Database.getDataToController(player.emailName.value);
      player.update();
    }
    else if(mark=='Armors' || mark=='Accessories' || mark=='Body'){
      await _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).get().then((value){
        value.docs.forEach((element) {
          if(element['Type']==type && element['PlayerEquipped']){
            Map<String,dynamic> updates ={
              'PlayerEquipped' : false,
            };
            _firestore.collection('user').doc(emailName).collection('bag').doc(mark).collection(mark).doc(element.id).update(updates);
            player.STR.value-=(element['STR']as num).toInt();
            player.INT.value-=(element['INT']as num).toInt();
            player.VIT.value-=(element['VIT']as num).toInt();
          }
        });
      });
      if(type=='Clothes'){
        player.clothesImg.value=player.initClothesImg.value;
        Database.updateSomething(emailName: player.emailName.value, target: 'ClothesImg', data: player.initClothesImg.value);
      }
      else if(type=='Pants'){
        player.pantsImg.value=player.initPantsImg.value;
        Database.updateSomething(emailName: player.emailName.value, target: 'PantsImg', data: player.initPantsImg.value);
      }
      else if(type=='Shoes'){
        player.shoesImg.value=player.initShoesImg.value;
        Database.updateSomething(emailName: player.emailName.value, target: 'ShoesImg', data: player.initShoesImg.value);
      }
      else if(type=='EyeDecoration'){
        player.eyeDecorationImg.value=NoImg;
        Database.updateSomething(emailName: player.emailName.value, target: 'EyeDecorationImg', data: NoImg);
      }
      else if(type=='BackItem'){
        player.backItemImg.value=NoImg;
        Database.updateSomething(emailName: player.emailName.value, target: 'BackItemImg', data: NoImg);
      }
      else if(type=='Liver'){
        player.liverImg.value=Liver_og;
        Database.updateSomething(emailName: player.emailName.value, target: 'LiverImg', data: Liver_og);
      }
      else if(type=='Mouth'){
        player.mouthImg.value=player.initMouthImg.value;
        Database.updateSomething(emailName: player.emailName.value, target: 'MouthImg', data: player.initMouthImg.value);
      }
      else if(type=='Eyes'){
        player.eyesImg.value=player.initEyesImg.value;
        Database.updateSomething(emailName: player.emailName.value, target: 'EyesImg', data: player.initEyesImg.value);
      }
      else if(type=='Ears'){
        player.earsImg.value=player.initEarsImg.value;
        Database.updateSomething(emailName: player.emailName.value, target: 'EarsImg', data: player.initEarsImg.value);
      }
      Database.getDataToController(player.emailName.value);
      player.update();
    }

  }

  static Future<void> addSkill({required String emailName,required String skillName,required int lv,required int mp,required int value,required int sp,required int status,required bool use}) async{
    await _firestore.collection('user').doc(emailName).collection('skill').doc(skillName).set({
      'SkillName' : skillName,
      'Lv' : lv,
      'Mp' : mp,
      'Value' : value,
      'Sp' : sp,
      'Status' : status,
      'Use' : use,
    });
  }

  static Future<void> checkSTRHardSkill({required String emailName,}) async{
    final player = Get.put(PlayerController());
    await _firestore.collection('user').doc(emailName).collection('skill').doc('STR-Hard').get().then((value){
      if(value['Status']==2){
        _firestore.collection('user').doc(emailName).collection('skill').doc('STR-Easy').get().then((value){
          if(value['Lv']>=50){
            _firestore.collection('user').doc(emailName).collection('skill').doc('STR-Mid').get().then((value1){
              if(value1['Lv']>=30){
                Database.updateSkill(emailName: player.emailName.value, skillName: 'STR-Hard',  target: 'Status', data: 1);
              }
            });
          }
        });
      }
    });
  }

  static Future<void> checkINTHardSkill({required String emailName,}) async{
    final player = Get.put(PlayerController());
    await _firestore.collection('user').doc(emailName).collection('skill').doc('INT-Hard').get().then((value){
      if(value['Status']==2){
        _firestore.collection('user').doc(emailName).collection('skill').doc('INT-Easy').get().then((value){
          if(value['Lv']>=50){
            _firestore.collection('user').doc(emailName).collection('skill').doc('INT-Mid').get().then((value1){
              if(value1['Lv']>=30){
                Database.updateSkill(emailName: player.emailName.value, skillName: 'INT-Hard',  target: 'Status', data: 1);
              }
            });
          }
        });
      }
    });
  }

  static Future<void> checkVITHardSkill({required String emailName,}) async{
    final player = Get.put(PlayerController());
    await _firestore.collection('user').doc(emailName).collection('skill').doc('VIT-Hard').get().then((value){
      if(value['Status']==2){
        _firestore.collection('user').doc(emailName).collection('skill').doc('VIT-Easy').get().then((value){
          if(value['Lv']>=50){
            _firestore.collection('user').doc(emailName).collection('skill').doc('VIT-Mid').get().then((value1){
              if(value1['Lv']>=30){
                Database.updateSkill(emailName: player.emailName.value, skillName: 'VIT-Hard',  target: 'Status', data: 1);
              }
            });
          }
        });
      }
    });
  }

  static Future<void> addMonster({required String emailName,required String type,required String monsterName,required String image,required int lv,required double hp,required double maxHp,required double exp,required double coin,required int killCount,required bool canBeAttack}) async{
    await _firestore.collection('user').doc(emailName).collection('monster').doc(type).set({
      'Type' : type,
      'MonsterName' : monsterName,
      'Lv' : lv,
      'Hp' : hp,
      'MaxHp' : maxHp,
      'Image' : image,
      'Exp' :exp,
      'Coin' : coin,
      'KillCount' : killCount,
      'CanBeAttack' :canBeAttack,
    });
  }

  static Future<void> getDataToMonsterR(emailName) async{
    final monsterR = Get.put(MonsterRController());
    monsterR.refresh();
    await _firestore.collection('user').doc(emailName).collection('monster').doc('Exercise').get().then((value){
      monsterR.name.value=value['MonsterName'];
      monsterR.type.value=value['Type'];
      monsterR.lv.value=value['Lv'];
      monsterR.hp.value=value['Hp'];
      monsterR.maxHp.value=value['MaxHp'];
      monsterR.image.value=value['Image'];
      monsterR.exp.value=value['Exp'];
      monsterR.coin.value=value['Coin'];
      monsterR.killCount.value=value['KillCount'];
      monsterR.canBeAttack.value=value['CanBeAttack'];
      monsterR.setHpRatio();
      monsterR.update();
    });
  }

  static Future<void> getDataToMonsterB(emailName) async{
    final monsterB = Get.put(MonsterBController());
    monsterB.refresh();
    await _firestore.collection('user').doc(emailName).collection('monster').doc('Learning').get().then((value){
      monsterB.name.value=value['MonsterName'];
      monsterB.type.value=value['Type'];
      monsterB.lv.value=value['Lv'];
      monsterB.hp.value=value['Hp'];
      monsterB.maxHp.value=value['MaxHp'];
      monsterB.image.value=value['Image'];
      monsterB.exp.value=value['Exp'];
      monsterB.coin.value=value['Coin'];
      monsterB.killCount.value=value['KillCount'];
      monsterB.canBeAttack.value=value['CanBeAttack'];
      monsterB.setHpRatio();
      monsterB.update();
    });
  }

  static Future<void> getDataToMonsterG(emailName) async{
    final monsterG = Get.put(MonsterGController());
    monsterG.refresh();
    await _firestore.collection('user').doc(emailName).collection('monster').doc('Life').get().then((value){
      monsterG.name.value=value['MonsterName'];
      monsterG.type.value=value['Type'];
      monsterG.lv.value=value['Lv'];
      monsterG.hp.value=value['Hp'];
      monsterG.maxHp.value=value['MaxHp'];
      monsterG.image.value=value['Image'];
      monsterG.exp.value=value['Exp'];
      monsterG.coin.value=value['Coin'];
      monsterG.killCount.value=value['KillCount'];
      monsterG.canBeAttack.value=value['CanBeAttack'];
      monsterG.setHpRatio();
      monsterG.update();
    });
  }

  static Future<void> getDataToSTR_Easy() async{
    final player = Get.put(PlayerController());
    final STR_Easy = Get.put(Skill_STR_Easy());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('STR-Easy').get().then((value){
      STR_Easy.lv.value = value['Lv'];
      STR_Easy.mp.value = value['Mp'];
      STR_Easy.sp.value = value['Sp'];
      STR_Easy.value.value = value['Value'];
      STR_Easy.status.value = value['Status'];
      STR_Easy.use.value = value['Use'];
      STR_Easy.update();
    });
  }

  static Future<void> getDataToSTR_Mid() async{
    final player = Get.put(PlayerController());
    final STR_Mid = Get.put(Skill_STR_Mid());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('STR-Mid').get().then((value){
      STR_Mid.lv.value = value['Lv'];
      STR_Mid.mp.value = value['Mp'];
      STR_Mid.sp.value = value['Sp'];
      STR_Mid.value.value = value['Value'];
      STR_Mid.status.value = value['Status'];
      STR_Mid.use.value = value['Use'];
      STR_Mid.update();
    });
  }

  static Future<void> getDataToSTR_Hard() async{
    final player = Get.put(PlayerController());
    final STR_Hard = Get.put(Skill_STR_Hard());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('STR-Hard').get().then((value){
      STR_Hard.lv.value = value['Lv'];
      STR_Hard.mp.value = value['Mp'];
      STR_Hard.sp.value = value['Sp'];
      STR_Hard.value.value = value['Value'];
      STR_Hard.status.value = value['Status'];
      STR_Hard.use.value = value['Use'];
      STR_Hard.update();
    });
  }

  static Future<void> getDataToINT_Easy() async{
    final player = Get.put(PlayerController());
    final INT_Easy = Get.put(Skill_INT_Easy());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('INT-Easy').get().then((value){
      INT_Easy.lv.value = value['Lv'];
      INT_Easy.mp.value = value['Mp'];
      INT_Easy.sp.value = value['Sp'];
      INT_Easy.value.value = value['Value'];
      INT_Easy.status.value = value['Status'];
      INT_Easy.use.value = value['Use'];
      INT_Easy.update();
    });
  }

  static Future<void> getDataToINT_Mid() async{
    final player = Get.put(PlayerController());
    final INT_Mid = Get.put(Skill_INT_Mid());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('INT-Mid').get().then((value){
      INT_Mid.lv.value = value['Lv'];
      INT_Mid.mp.value = value['Mp'];
      INT_Mid.sp.value = value['Sp'];
      INT_Mid.value.value = value['Value'];
      INT_Mid.status.value = value['Status'];
      INT_Mid.use.value = value['Use'];
      INT_Mid.update();
    });
  }

  static Future<void> getDataToINT_Hard() async{
    final player = Get.put(PlayerController());
    final INT_Hard = Get.put(Skill_INT_Hard());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('INT-Hard').get().then((value){
      INT_Hard.lv.value = value['Lv'];
      INT_Hard.mp.value = value['Mp'];
      INT_Hard.sp.value = value['Sp'];
      INT_Hard.value.value = value['Value'];
      INT_Hard.status.value = value['Status'];
      INT_Hard.use.value = value['Use'];
      INT_Hard.update();
    });
  }

  static Future<void> getDataToVIT_Easy() async{
    final player = Get.put(PlayerController());
    final VIT_Easy = Get.put(Skill_VIT_Easy());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('VIT-Easy').get().then((value){
      VIT_Easy.lv.value = value['Lv'];
      VIT_Easy.mp.value = value['Mp'];
      VIT_Easy.sp.value = value['Sp'];
      VIT_Easy.value.value = value['Value'];
      VIT_Easy.status.value = value['Status'];
      VIT_Easy.use.value = value['Use'];
      VIT_Easy.update();
    });
  }

  static Future<void> getDataToVIT_Mid() async{
    final player = Get.put(PlayerController());
    final VIT_Mid = Get.put(Skill_VIT_Mid());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('VIT-Mid').get().then((value){
      VIT_Mid.lv.value = value['Lv'];
      VIT_Mid.mp.value = value['Mp'];
      VIT_Mid.sp.value = value['Sp'];
      VIT_Mid.value.value = value['Value'];
      VIT_Mid.status.value = value['Status'];
      VIT_Mid.use.value = value['Use'];
      VIT_Mid.update();
    });
  }

  static Future<void> getDataToVIT_Hard() async{
    final player = Get.put(PlayerController());
    final VIT_Hard = Get.put(Skill_VIT_Hard());
    await _firestore.collection('user').doc(player.emailName.value).collection('skill').doc('VIT-Hard').get().then((value){
      VIT_Hard.lv.value = value['Lv'];
      VIT_Hard.mp.value = value['Mp'];
      VIT_Hard.sp.value = value['Sp'];
      VIT_Hard.value.value = value['Value'];
      VIT_Hard.status.value = value['Status'];
      VIT_Hard.use.value = value['Use'];
      VIT_Hard.update();
    });
  }

  static Future<void> addAchievement(emailName,name,date,type,index) async{
    await _firestore.collection('user').doc(emailName).collection('achievement').add({
      'Name':name,
      'Date':date,
      'Type':type,
      'Index': index,
    });
  }

  static Future<void> getShopItem({required String emailName,required String type}) async{
    final player = Get.put(PlayerController());
    Random random=new Random();
    int randomNumber ;
    String itemId='';
    String itemImg1='';
    String itemImg2='';
    String itemImg3='';
    String itemContent='';
    String itemType='';
    int itemSTR=0;
    int itemINT=0;
    int itemVIT=0;
    int itemMP=0;
    int itemEXP=0;
    int itemCoin=0;
    int itemIndex=0;
    if(type == 'Weapon' && player.weaponShopCount.value>0){
      print('^^^^^^^^^^^^^^^^');
      //get random weapon
      randomNumber = random.nextInt(player.weaponShopCount.value);
      await _firestore.collection('user').doc(emailName).collection('shop').doc('Weapon').collection('Weapon').get().then((value){
        itemId = value.docs.elementAt(randomNumber).id.toString();
        itemImg1=value.docs.elementAt(randomNumber)['Image1'];
        itemImg2=value.docs.elementAt(randomNumber)['Image2'];
        itemImg3=value.docs.elementAt(randomNumber)['Image3'];
        itemContent=value.docs.elementAt(randomNumber)['Content'];
        itemType=value.docs.elementAt(randomNumber)['Type'];
        itemSTR=value.docs.elementAt(randomNumber)['STR'];
        itemINT=value.docs.elementAt(randomNumber)['INT'];
        itemVIT=value.docs.elementAt(randomNumber)['VIT'];
        itemMP=value.docs.elementAt(randomNumber)['MP'];
        itemEXP=value.docs.elementAt(randomNumber)['EXP'];
        itemCoin=value.docs.elementAt(randomNumber)['Coin'];
        itemIndex=value.docs.elementAt(randomNumber)['Index'];
      });

      _firestore.collection('user').doc(emailName).collection('shop').doc('Weapon').collection('Weapon').doc(itemId).delete();

      addBagItem(emailName: emailName, imagePath1: itemImg1, imagePath2: itemImg2, imagePath3: itemImg3, content: itemContent, type: itemType, STR: itemSTR, INT: itemINT, VIT: itemVIT, MP: itemMP, EXP: itemEXP, coin: itemCoin,index: itemIndex, playerEquipped: false, mark: 'Weapon');

      player.weaponShopCount.value=player.weaponShopCount.value-1;
      updateSomething(emailName: emailName, target: 'WeaponShopCount', data: player.weaponShopCount.value);
    }
    else if(type == 'Items'){
      print('^^^^^^^^^^^^^^^^');
      //get random item
      randomNumber = random.nextInt(player.itemShopCount.value);
      await _firestore.collection('user').doc(emailName).collection('shop').doc('Items').collection('Items').get().then((value){
        itemId = value.docs.elementAt(randomNumber).id.toString();
        itemImg1=value.docs.elementAt(randomNumber)['Image1'];
        itemImg2=value.docs.elementAt(randomNumber)['Image2'];
        itemImg3=value.docs.elementAt(randomNumber)['Image3'];
        itemContent=value.docs.elementAt(randomNumber)['Content'];
        itemType=value.docs.elementAt(randomNumber)['Type'];
        itemSTR=value.docs.elementAt(randomNumber)['STR'];
        itemINT=value.docs.elementAt(randomNumber)['INT'];
        itemVIT=value.docs.elementAt(randomNumber)['VIT'];
        itemMP=value.docs.elementAt(randomNumber)['MP'];
        itemEXP=value.docs.elementAt(randomNumber)['EXP'];
        itemCoin=value.docs.elementAt(randomNumber)['Coin'];
        itemIndex=value.docs.elementAt(randomNumber)['Index'];
      });

      addBagItem(emailName: emailName, imagePath1: itemImg1, imagePath2: itemImg2, imagePath3: itemImg3, content: itemContent, type: itemType, STR: itemSTR, INT: itemINT, VIT: itemVIT, MP: itemMP, EXP: itemEXP, coin: itemCoin,index: itemIndex, playerEquipped: false, mark: 'Items');
    }
    else if(type == 'Accessories' && player.accessoriesShopCount.value>0){
      print('^^^^^^^^^^^^^^^^');
      //get random Accessories
      randomNumber = random.nextInt(player.accessoriesShopCount.value);
      await _firestore.collection('user').doc(emailName).collection('shop').doc('Accessories').collection('Accessories').get().then((value){
        itemId = value.docs.elementAt(randomNumber).id.toString();
        itemImg1=value.docs.elementAt(randomNumber)['Image1'];
        itemImg2=value.docs.elementAt(randomNumber)['Image2'];
        itemImg3=value.docs.elementAt(randomNumber)['Image3'];
        itemContent=value.docs.elementAt(randomNumber)['Content'];
        itemType=value.docs.elementAt(randomNumber)['Type'];
        itemSTR=value.docs.elementAt(randomNumber)['STR'];
        itemINT=value.docs.elementAt(randomNumber)['INT'];
        itemVIT=value.docs.elementAt(randomNumber)['VIT'];
        itemMP=value.docs.elementAt(randomNumber)['MP'];
        itemEXP=value.docs.elementAt(randomNumber)['EXP'];
        itemCoin=value.docs.elementAt(randomNumber)['Coin'];
        itemIndex=value.docs.elementAt(randomNumber)['Index'];
      });

      _firestore.collection('user').doc(emailName).collection('shop').doc('Accessories').collection('Accessories').doc(itemId).delete();

      addBagItem(emailName: emailName, imagePath1: itemImg1, imagePath2: itemImg2, imagePath3: itemImg3, content: itemContent, type: itemType, STR: itemSTR, INT: itemINT, VIT: itemVIT, MP: itemMP, EXP: itemEXP, coin: itemCoin,index: itemIndex, playerEquipped: false, mark: 'Accessories');
      player.accessoriesShopCount.value=player.accessoriesShopCount.value-1;
      updateSomething(emailName: emailName, target: 'AccessoriesShopCount', data: player.accessoriesShopCount.value);
    }

  }

}