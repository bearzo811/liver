import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liver_final/constants/image_path.dart';
import 'package:liver_final/controller/login_controller.dart';
import 'package:liver_final/controller/player_controller.dart';
import 'package:liver_final/service/database.dart';
import 'package:intl/intl.dart';

class AddInterest extends StatefulWidget {
  @override
  _AddInterestState createState() => _AddInterestState();
}

class _AddInterestState extends State<AddInterest> {
  final player = Get.put(PlayerController());
  final monsterR = Get.put(MonsterRController());
  final monsterB = Get.put(MonsterBController());
  final monsterG = Get.put(MonsterGController());
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
  RxInt itemSTR = 0.obs;
  RxInt itemINT = 0.obs;
  RxInt itemVIT = 0.obs;
  RxInt itemCoin = 0.obs;
  RxString itemId = ''.obs;
  RxString itemType = ''.obs;
  RxString itemMark = ''.obs;
  RxInt attribute = 3.obs;

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
    return Scaffold(
        backgroundColor: const Color(0xFFaa5410),
        resizeToAvoidBottomInset:false,
        body: Stack(
          children: [
            Column(
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
                                Image.asset(CharacterStatus_Home_Button,scale: 1.2,),
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
                              child: getPageByIndex(0),
                            );
                          },
                          itemCount: 1,
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
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent.withOpacity(0.4),
              child: InkWell(
                onTap: (){
                  Get.back();
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*(280/930),
              left: MediaQuery.of(context).size.width*(15/462),
              child: Container(
                width: MediaQuery.of(context).size.width*(430/462),
                child: Stack(
                  children: [
                    Image.asset(Train_Add_BG,),
                    Positioned(
                        top: MediaQuery.of(context).size.height*(60/930),
                        left: MediaQuery.of(context).size.width*(18/462),
                        child: Container(
                            width: MediaQuery.of(context).size.width*(410/462),
                            height: MediaQuery.of(context).size.height*(65/930),
                            child: Stack(
                              children: [
                                Image.asset(Train_Add_TextBar),
                                Positioned(
                                  left: MediaQuery.of(context).size.width*(10/462),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*(410/462),
                                    height: MediaQuery.of(context).size.height*(55/930),
                                    child: TextField(
                                        textAlign: TextAlign.start,
                                        cursorColor: Colors.black,
                                        controller: _interestNameController,
                                        decoration: InputDecoration(border: InputBorder.none),
                                        style: TextStyle(
                                            fontFamily: 'DotGothic16',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            )
                        )
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height*(130/930),
                        left: MediaQuery.of(context).size.width*(20/462),
                        child: Container(
                          width: MediaQuery.of(context).size.width*(390/462),
                          height: MediaQuery.of(context).size.height*(65/930),
                          child: Stack(
                            children: [
                              Image.asset(Train_Add_TextBar),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(7/930),
                                left: MediaQuery.of(context).size.width*(6/462),
                                child: Obx(()=>getAttributeText(attribute.value.toInt())),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height*(7/930),
                                left: MediaQuery.of(context).size.width*(330/462),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*(50/462),
                                  height: MediaQuery.of(context).size.height*(50/930),
                                  child: Stack(
                                    children: [
                                      Image.asset(Train_Add_AttributeMenu_Button),
                                      InkWell(
                                        onTap: (){
                                          showModalBottomSheet(
                                              barrierColor: Colors.transparent,
                                              backgroundColor: Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context){
                                                return Container(
                                                    height: MediaQuery.of(context).size.height*(477/930),
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width*(420/462),
                                                            child: Stack(
                                                              children: [
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height*(16/930),
                                                                  left: MediaQuery.of(context).size.width*(35/462),
                                                                  child: Image.asset(Train_Add_AttributeOption_BG),
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height*(25/930),
                                                                  left: MediaQuery.of(context).size.width*(45/462),
                                                                  child: Image.asset(Train_Add_Attribute_STR_Button),
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height*(77/930),
                                                                  left: MediaQuery.of(context).size.width*(45/462),
                                                                  child: Image.asset(Train_Add_Attribute_INT_Button),
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height*(130/930),
                                                                  left: MediaQuery.of(context).size.width*(45/462),
                                                                  child: Image.asset(Train_Add_Attribute_VIT_Button),
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height*(25/930),
                                                                  left: MediaQuery.of(context).size.width*(45/462),
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width*(370/462),
                                                                    height: MediaQuery.of(context).size.height*(50/930),
                                                                    child: InkWell(
                                                                      onTap: (){
                                                                        print('STR');
                                                                        Navigator.pop(context);
                                                                        attribute.value=0;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height*(77/930),
                                                                  left: MediaQuery.of(context).size.width*(45/462),
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width*(370/462),
                                                                    height: MediaQuery.of(context).size.height*(50/930),
                                                                    child: InkWell(
                                                                      onTap: (){
                                                                        print('INT');
                                                                        Navigator.pop(context);
                                                                        attribute.value=1;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: MediaQuery.of(context).size.height*(130/930),
                                                                  left: MediaQuery.of(context).size.width*(45/462),
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width*(370/462),
                                                                    height: MediaQuery.of(context).size.height*(50/930),
                                                                    child: InkWell(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                        attribute.value=2;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                );
                                              }
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height*(195/930),
                      left: MediaQuery.of(context).size.width*(315/462),
                      child: Container(
                        width: MediaQuery.of(context).size.width*(130/462),
                        height: MediaQuery.of(context).size.height*(50/930),
                        child: Stack(
                          children: [
                            Image.asset(Train_Add_OK_Button),
                            InkWell(
                              onTap: (){
                                Database.addTrain(player.emailName.value, _interestNameController.text, attribute.value, 5, player.lv.value);
                                Get.back();
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
                        width: MediaQuery.of(context).size.width*(40/462),
                        height: MediaQuery.of(context).size.height*(40/930),
                        child: Stack(
                          children: [
                            Image.asset(Train_Add_Close_Button),
                            InkWell(
                              onTap: (){
                                Get.back();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Container getPageByIndex(int index) { // 0: battle 1: interest 2:skill 3:shop 4:log 5:status 6:bag
    switch(index){
    //0 battle
      case 0 : return Container(
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
                                          top: MediaQuery.of(context).size.height*(13/930),
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
                                        Positioned(
                                          top: 15,
                                          left: 325,
                                          child: Container(
                                            height: 50,
                                            width: 50,
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
                    ]
                ),
              )
            ],
          )
      );
      default: return Container();
    }
  }

  Container getAttributeText(int attribute) {
    switch(attribute){
      case 0: return Container(
        child: Image.asset(Train_Add_Attribute_STR_Button),
      );
      case 1: return Container(
        child: Image.asset(Train_Add_Attribute_INT_Button),
      );
      case 2: return Container(
        child: Image.asset(Train_Add_Attribute_VIT_Button),
      );
      case 3: return Container(
        height: 50,
        width: 310,
        color: Color(0xffe7bc9a),
      );
      default: return Container(
        height: 50,
        width: 310,
        color: Color(0xffe7bc9a),
      );
    }
  }
  Image getAttribute(int index) {
    switch(index){
      case 0: return Image.asset(Train_Item_STR_Symbol);
      case 1: return Image.asset(Train_Item_INT_Symbol);
      case 2: return Image.asset(Train_Item_VIT_Symbol);
      default: return Image.asset(Train_Item_STR_Symbol);
    }
  }
}
