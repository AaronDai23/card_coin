class PinCodeInfo {
  bool isOpen;
  int? pinCount;

  PinCodeInfo({required this.isOpen, this.pinCount});

  PinCodeInfo copyWith({bool? isOpen, int? pinCount}) {
    return PinCodeInfo(
        isOpen: isOpen ?? this.isOpen, pinCount: pinCount ?? this.pinCount);
  }
}
