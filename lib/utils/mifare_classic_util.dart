import 'dart:typed_data';

class MifareClassicUtil{
  static Uint8List getDefaultKey(bool enableNdef,int sectorIndex){
    List<int> key;
    if(enableNdef){
      if(sectorIndex == 0){
        key = [0xA0,0xA1,0xA2,0xA3,0xA4,0xA5];
      }else{
        key = [0xD3,0xF7,0xD3,0xF7,0xD3,0xF7];
      }
    }else{
      key = [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF];
    }
    return Uint8List.fromList(key);
  }

  static int getBlockIndex(int sectorIndex,int sectorBlockIndex){
    return sectorIndex*4+sectorBlockIndex;
  }
}