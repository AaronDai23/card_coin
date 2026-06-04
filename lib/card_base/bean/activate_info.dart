class ActivateInfo {
  int? activeCount;
  int? activePackageCount;
  String? batchId;
  String? cardNo;
  int? inActiveCount;
  int? inActivePackageCount;
  int? totalCount;
  int? totalPackageCount;
  String? uid;

  ActivateInfo(
      {this.activeCount,
      this.activePackageCount,
      this.batchId,
      this.cardNo,
      this.inActiveCount,
      this.inActivePackageCount,
      this.totalCount,
      this.totalPackageCount,
      this.uid});

  ActivateInfo.fromJson(Map<String, dynamic> json) {
    activeCount = json['activeCount'];
    activePackageCount = json['activePackageCount'];
    batchId = json['batchId'];
    cardNo = json['cardNo'];
    inActiveCount = json['inActiveCount'];
    inActivePackageCount = json['inActivePackageCount'];
    totalCount = json['totalCount'];
    totalPackageCount = json['totalPackageCount'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activeCount'] = activeCount;
    data['activePackageCount'] = activePackageCount;
    data['batchId'] = batchId;
    data['cardNo'] = cardNo;
    data['inActiveCount'] = inActiveCount;
    data['inActivePackageCount'] = inActivePackageCount;
    data['totalCount'] = totalCount;
    data['totalPackageCount'] = totalPackageCount;
    data['uid'] = uid;
    return data;
  }

  copyWith({int? activePackageCount, int? inActivePackageCount}) {
    return ActivateInfo(
        activePackageCount: activePackageCount ?? this.activePackageCount,
        inActivePackageCount: inActivePackageCount ?? this.inActivePackageCount,
        activeCount: activeCount,
        inActiveCount: inActivePackageCount ?? this.inActivePackageCount,
        batchId: batchId,
        cardNo: cardNo,
        totalCount: totalCount,
        totalPackageCount: totalPackageCount,
        uid: uid);
  }
}

class ActivateSummary {
  int? activeCount;
  int? inActiveCount;
  int? totalCount;

  ActivateSummary({this.activeCount, this.inActiveCount, this.totalCount});

  ActivateSummary.fromJson(Map<String, dynamic> json) {
    activeCount = json['activeCount'];
    inActiveCount = json['inActiveCount'];
    totalCount = json['totalCount'];
  }

  copyWith({int? activeCount, int? inActiveCount}) {
    return ActivateSummary(activeCount: activeCount ?? this.activeCount, inActiveCount: inActiveCount ?? this.inActiveCount, totalCount: totalCount);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activeCount'] = activeCount;
    data['inActiveCount'] = inActiveCount;
    data['totalCount'] = totalCount;
    return data;
  }
}

class ActivatePackageSummary {
  int? activePackageCount;
  int? inActivePackageCount;
  int? totalPackageCount;

  ActivatePackageSummary({this.activePackageCount, this.inActivePackageCount, this.totalPackageCount});

  ActivatePackageSummary.fromJson(Map<String, dynamic> json) {
    activePackageCount = json['activePackageCount'];
    inActivePackageCount = json['inActivePackageCount'];
    totalPackageCount = json['totalPackageCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activePackageCount'] = activePackageCount;
    data['inActivePackageCount'] = inActivePackageCount;
    data['totalPackageCount'] = totalPackageCount;
    return data;
  }
}

class CardPackage {
  int? packageActiveCount;
  int? packageInActiveCount;
  String? packageNumber;
  int? totalPackageCount;
  String? packageRemarks;

  CardPackage({this.packageActiveCount, this.packageInActiveCount, this.packageNumber, this.packageRemarks, this.totalPackageCount});

  CardPackage.fromJson(Map<String, dynamic> json) {
    packageActiveCount = json['packageActiveCount'];
    packageInActiveCount = json['packageInActiveCount'];
    packageNumber = json['packageNumber'];
    totalPackageCount = json['totalPackageCount'];
    packageRemarks = json['packageRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packageActiveCount'] = packageActiveCount;
    data['packageInActiveCount'] = packageInActiveCount;
    data['packageNumber'] = packageNumber;
    data['totalPackageCount'] = totalPackageCount;
    data['packageRemarks'] = packageRemarks;
    return data;
  }
}
