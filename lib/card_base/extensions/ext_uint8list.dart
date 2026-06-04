import 'dart:typed_data';

extension BigIntExt on Uint8List{
  BigInt toBigInt() {
    // 确保字节数组不是空的
    if (isEmpty) {
      throw ArgumentError("The byte array cannot be empty.");
    }

    // 计算总长度（以字节为单位）
    int length = lengthInBytes;

    // 创建一个 BigInt 对象
    BigInt result = BigInt.zero;

    // 遍历字节数组，并将每个字节转换为 BigInt
    for (int i = 0; i < length; i++) {
      // 将当前字节添加到结果中
      result = (result << 8) + BigInt.from(this[i]);
    }

    return result;
  }
}