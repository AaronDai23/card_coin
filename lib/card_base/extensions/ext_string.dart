extension StringSeprate on String {
  String stringSeprate({int count = 4, String separator = ','}) {
    if (isEmpty) {
      return '';
    }
    if (count < 1) {
      return this;
    }
    if (count >= length) {
      return this;
    }
    var str = replaceAll(separator, "");
    var chars = str.runes.toList();
    var namOfSeparation =
        (chars.length.toDouble() / count.toDouble()).ceil() - 1;

    int len = chars.length + namOfSeparation.round();
    var separatedChars = List.filled(len, "");
    var j = 0;
    for (var i = 0; i < chars.length; i++) {
      separatedChars[j] = String.fromCharCode(chars[i]);
      if (i > 0 && (i + 1) < chars.length && (i + 1) % count == 0) {
        j += 1;
        separatedChars[j] = separator;
      }

      j += 1;
    }

    return separatedChars.join();
  }

  String getMoneyStyleStr() {
    try {
      if (isEmpty) {
        return "";
      } else {
        String temp = "";
        if (length <= 3) {
          return this;
        } else {
          int count = ((length) ~/ 3); //切割次数
          int startIndex = length % 3; //开始切割的位置
          if (startIndex != 0) {
            if (count == 1) {
              temp = "${substring(0, startIndex)},${substring(startIndex, length)}";
            } else {
              temp = "${substring(0, startIndex)},"; //第一次切割0-startIndex
              int syCount = count - 1; //剩余切割次数
              for (int i = 0; i < syCount; i++) {
                temp += "${substring(
                    startIndex + 3 * i, startIndex + (i * 3) + 3)},";
              }
              temp += substring(
                  (startIndex + (syCount - 1) * 3 + 3), length);
            }
          } else {
            for (int i = 0; i < count; i++) {
              if (i != count - 1) {
                temp += "${substring(3 * i, (i + 1) * 3)},";
              } else {
                temp += substring(3 * i, (i + 1) * 3);
              }
            }
          }
          return temp;
        }
      }
    } catch (e) {
      return '';
    }
  }
}