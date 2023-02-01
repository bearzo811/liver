import 'image_path.dart';

String setBackHairImg({required int type,required int color}){
  if(type == 0){
    switch(color){
      case 0 : return BackHair_0_0;
      case 1 : return BackHair_0_1;
      case 2 : return BackHair_0_2;
      case 3 : return BackHair_0_3;
      case 4 : return BackHair_0_4;
      case 5 : return BackHair_0_5;
      case 6 : return BackHair_0_6;
      case 7 : return BackHair_0_7;
      case 8 : return BackHair_0_8;
    }
  }
  else if(type == 1){
    switch(color){
      case 0 : return BackHair_1_0;
      case 1 : return BackHair_1_1;
      case 2 : return BackHair_1_2;
      case 3 : return BackHair_1_3;
      case 4 : return BackHair_1_4;
      case 5 : return BackHair_1_5;
      case 6 : return BackHair_1_6;
      case 7 : return BackHair_1_7;
      case 8 : return BackHair_1_8;
    }
  }
  else if(type == 2){
    switch(color){
      case 0 : return BackHair_2_0;
    }
  }
  return '';
}

String setHeadBodyImg({required int color}){
  switch(color){
    case 0: return HeadBody_0;
    case 1: return HeadBody_1;
    case 2: return HeadBody_2;
    case 3: return HeadBody_3;
    case 4: return HeadBody_4;
  }
  return '';
}

String setEarsImg({required int type,required int color}){
  if(type==0){
    switch(color){
      case 0 : return Ears_0_0;
      case 1 : return Ears_0_1;
      case 2 : return Ears_0_2;
      case 3 : return Ears_0_3;
      case 4 : return Ears_0_4;
    }
  }
  if(type==1){
    switch(color){
      case 0 : return Ears_1_0;
      case 1 : return Ears_1_1;
      case 2 : return Ears_1_2;
      case 3 : return Ears_1_3;
      case 4 : return Ears_1_4;
    }
  }
  return '';
}

String setEyesImg({required int type, required int color}){
  if(type == 0){
    switch(color){
      case 0 : return Eyes_0_0;
      case 1 : return Eyes_0_1;
      case 2 : return Eyes_0_2;
      case 3 : return Eyes_0_3;
      case 4 : return Eyes_0_4;
      case 5 : return Eyes_0_5;
      case 6 : return Eyes_0_6;
      case 7 : return Eyes_0_7;
      case 8 : return Eyes_0_8;
      case 9 : return Eyes_0_9;
    }
  }
  if(type == 1){
    switch(color){
      case 0 : return Eyes_1_0;
      case 1 : return Eyes_1_1;
      case 2 : return Eyes_1_2;
      case 3 : return Eyes_1_3;
      case 4 : return Eyes_1_4;
      case 5 : return Eyes_1_5;
      case 6 : return Eyes_1_6;
      case 7 : return Eyes_1_7;
      case 8 : return Eyes_1_8;
      case 9 : return Eyes_1_9;
    }
  }
  if(type == 2){
    switch(color){
      case 0 : return Eyes_2_0;
      case 1 : return Eyes_2_1;
      case 2 : return Eyes_2_2;
      case 3 : return Eyes_2_3;
      case 4 : return Eyes_2_4;
      case 5 : return Eyes_2_5;
      case 6 : return Eyes_2_6;
      case 7 : return Eyes_2_7;
      case 8 : return Eyes_2_8;
      case 9 : return Eyes_2_9;
    }
  }
  if(type == 3){
    switch(color){
      case 0 : return Eyes_3_0;
      case 1 : return Eyes_3_1;
      case 2 : return Eyes_3_2;
      case 3 : return Eyes_3_3;
      case 4 : return Eyes_3_4;
      case 5 : return Eyes_3_5;
      case 6 : return Eyes_3_6;
      case 7 : return Eyes_3_7;
      case 8 : return Eyes_3_8;
      case 9 : return Eyes_3_9;
    }
  }
  return '';
}

String setForeHairImg({required int type,required int color}){
  if(type == 0){
    switch(color){
      case 0 : return ForeHair_0_0;
    }
  }
  else if(type == 1){
    switch(color){
      case 0 : return ForeHair_1_0;
      case 1 : return ForeHair_1_1;
      case 2 : return ForeHair_1_2;
      case 3 : return ForeHair_1_3;
      case 4 : return ForeHair_1_4;
      case 5 : return ForeHair_1_5;
      case 6 : return ForeHair_1_6;
      case 7 : return ForeHair_1_7;
      case 8 : return ForeHair_1_8;
    }
  }
  else if(type == 2){
    switch(color){
      case 0 : return ForeHair_2_0;
      case 1 : return ForeHair_2_1;
      case 2 : return ForeHair_2_2;
      case 3 : return ForeHair_2_3;
      case 4 : return ForeHair_2_4;
      case 5 : return ForeHair_2_5;
      case 6 : return ForeHair_2_6;
      case 7 : return ForeHair_2_7;
      case 8 : return ForeHair_2_8;
    }
  }
  else if(type == 3){
    switch(color){
      case 0 : return ForeHair_3_0;
      case 1 : return ForeHair_3_1;
      case 2 : return ForeHair_3_2;
      case 3 : return ForeHair_3_3;
      case 4 : return ForeHair_3_4;
      case 5 : return ForeHair_3_5;
      case 6 : return ForeHair_3_6;
      case 7 : return ForeHair_3_7;
      case 8 : return ForeHair_3_8;
    }
  }
  return '';
}

String setPantsImg({required int color}){
  switch(color){
    case 0: return Pants_0;
    case 1: return Pants_1;
    case 2: return Pants_2;
    case 3: return Pants_3;
    case 4: return Pants_4;
    case 5: return Pants_5;
    case 6: return Pants_6;
    case 7: return Pants_7;
    case 8: return Pants_8;
    case 9: return Pants_9;
    case 10: return Pants_10;
    case 11: return Pants_11;
  }
  return '';
}

String setClothesImg({required int color}){
  switch(color){
    case 0: return Clothes_0;
    case 1: return Clothes_1;
    case 2: return Clothes_2;
    case 3: return Clothes_3;
    case 4: return Clothes_4;
    case 5: return Clothes_5;
    case 6: return Clothes_6;
    case 7: return Clothes_7;
  }
  return '';
}

String setMouthImg({required int type}){
  switch(type){
    case 0: return Mouth_0;
    case 1: return Mouth_1;
    case 2: return Mouth_2;
    case 3: return Mouth_3;
    case 4: return Mouth_4;
  }
  return '';
}

String setShoesImg({required int color}){
  switch(color){
    case 0: return Shoes_0;
    case 1: return Shoes_1;
    case 2: return Shoes_2;
    case 3: return Shoes_3;
    case 4: return Shoes_4;
    case 5: return Shoes_5;
  }
  return '';
}

String setLightWeaponImg({required int type}){
  switch(type){
    case 0: return LightWeapon_0;
    case 1: return LightWeapon_1;
    case 2: return LightWeapon_2;
    case 3: return LightWeapon_3;
    case 4: return LightWeapon_4;
  }
  return '';
}

String setHeavyWeaponHandleImg({required int type}){
  switch(type){
    case 0: return Heavy_Weapon_Handle_0;
    case 1: return Heavy_Weapon_Handle_1;
    case 2: return Heavy_Weapon_Handle_2;
    case 3: return Heavy_Weapon_Handle_3;
    case 4: return Heavy_Weapon_Handle_4;
    case 5: return Heavy_Weapon_Handle_5;
  }
  return '';
}

String setHeavyWeaponHeadImg({required int type}){
  switch(type){
    case 2: return Heavy_Weapon_Head_2;
    case 3: return Heavy_Weapon_Head_3;
    case 4: return Heavy_Weapon_Head_4;
    case 5: return Heavy_Weapon_Head_5;
  }
  return '';
}