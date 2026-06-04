class PostCardInfo {
  String? customerAddress;
  List<OcrResults>? ocrResults;
  List<Buttons>? buttons;
  String? logoImage;
  String? backgroundImage;
  String? companyName;
  String? qrImage;
  String? department;
  String? title;
  String? customerName;

  PostCardInfo(
      {this.customerAddress,
      this.ocrResults,
      this.buttons,
      this.logoImage,
      this.backgroundImage,
      this.companyName,
      this.qrImage,
      this.department,
      this.title,
      this.customerName});

  PostCardInfo.fromJson(Map<String, dynamic> json) {
    customerAddress = json['customerAddress'];
    if (json['ocrResults'] != null) {
      ocrResults = <OcrResults>[];
      json['ocrResults'].forEach((v) {
        ocrResults!.add(OcrResults.fromJson(v));
      });
    }
    if (json['buttons'] != null) {
      buttons = <Buttons>[];
      json['buttons'].forEach((v) {
        buttons!.add(Buttons.fromJson(v));
      });
    }
    logoImage = json['logoImage'];
    backgroundImage = json['backgroundImage'];
    companyName = json['companyName'];
    qrImage = json['qrImage'];
    department = json['department'];
    title = json['title'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerAddress'] = customerAddress;
    if (ocrResults != null) {
      data['ocrResults'] = ocrResults!.map((v) => v.toJson()).toList();
    }
    if (buttons != null) {
      data['buttons'] = buttons!.map((v) => v.toJson()).toList();
    }
    data['logoImage'] = logoImage;
    data['backgroundImage'] = backgroundImage;
    data['companyName'] = companyName;
    data['qrImage'] = qrImage;
    data['department'] = department;
    data['title'] = title;
    data['customerName'] = customerName;
    return data;
  }
}

class OcrResults {
  int? lineNo;
  String? lineContent;

  OcrResults({this.lineNo, this.lineContent});

  OcrResults.fromJson(Map<String, dynamic> json) {
    lineNo = json['lineNo'];
    lineContent = json['lineContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lineNo'] = lineNo;
    data['lineContent'] = lineContent;
    return data;
  }
}

class Buttons {
  String? prefix;
  String? imageUrl;
  String? name;
  String? description;
  bool? disabled;
  String? id;
  String? label;
  String? type;
  String? value;
  String? isCustomUrl;

  Buttons(
      {this.prefix,
      this.imageUrl,
      this.name,
      this.description,
      this.disabled,
      this.id,
      this.label,
      this.type,
      this.value,
      this.isCustomUrl});

  Buttons.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    description = json['description'];
    disabled = json['disabled'];
    id = json['id'];
    label = json['label'];
    type = json['type'];
    value = json['value'];
    isCustomUrl = json['isCustomUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prefix'] = prefix;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['description'] = description;
    data['disabled'] = disabled;
    data['id'] = id;
    data['label'] = label;
    data['type'] = type;
    data['value'] = value;
    data['isCustomUrl'] = isCustomUrl;
    return data;
  }
}

class CardCreateType {
  String? createBy;
  String? code;
  int? createTime;
  String? updateBy;
  String? name;
  String? id;
  String? value;
  String? orgId;
  int? seq;
  String? status;

  CardCreateType(
      {this.createBy,
      this.code,
      this.createTime,
      this.updateBy,
      this.name,
      this.id,
      this.value,
      this.orgId,
      this.seq,
      this.status});

  CardCreateType.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    code = json['code'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    name = json['name'];
    id = json['id'];
    value = json['value'];
    orgId = json['orgId'];
    seq = json['seq'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createBy'] = createBy;
    data['code'] = code;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['name'] = name;
    data['id'] = id;
    data['value'] = value;
    data['orgId'] = orgId;
    data['seq'] = seq;
    data['status'] = status;
    return data;
  }
}

class QRCodeType {
  String? value;
  String? key;
  int? seq;

  QRCodeType({this.value, this.key, this.seq});

  QRCodeType.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    key = json['key'];
    seq = json['seq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['key'] = key;
    data['seq'] = seq;
    return data;
  }
}
