class PageFieldConfig {
  String? categoryCode;
  String? categoryId;
  String? categoryName;
  String? configId;
  String? fieldCode;
  String? fieldEnumCode;
  String? fieldName;
  int? fieldSort;
  String? id;
  bool? isClientDisplay;
  bool? isClientFromAlbum;
  bool? isClientFromCamera;
  bool? isClientFromFileSystem;
  bool? isClientRequired;
  bool? isReadonly;
  String? moduleBackgroundImageUrl;
  String? moduleDescription;
  String? moduleFormat;
  String? modulePrefix;
  String? moduleSuffix;
  String? moduleTitle;
  String? moduleType;
  String? orgId;
  String? type;
  String? fontColor;
  String? backgroundColor;

  PageFieldConfig({
    this.categoryCode,
    this.categoryId,
    this.categoryName,
    this.configId,
    this.fieldCode,
    this.fieldEnumCode,
    this.fieldName,
    this.fieldSort,
    this.id,
    this.isClientDisplay,
    this.isClientFromAlbum,
    this.isClientFromCamera,
    this.isClientFromFileSystem,
    this.isClientRequired,
    this.isReadonly,
    this.moduleBackgroundImageUrl,
    this.moduleDescription,
    this.moduleFormat,
    this.modulePrefix,
    this.moduleSuffix,
    this.moduleTitle,
    this.moduleType,
    this.orgId,
    this.type,
    this.fontColor,
    this.backgroundColor,
  });

  factory PageFieldConfig.fromJson(Map<String, dynamic> json) {
    return PageFieldConfig(
      categoryCode: json['categoryCode'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      configId: json['configId'] as String? ?? '',
      fieldCode: json['fieldCode'] as String? ?? '',
      fieldEnumCode: json['fieldEnumCode'] as String? ?? '',
      fieldName: json['fieldName'] as String? ?? '',
      fieldSort: json['fieldSort'] as int? ?? 0,
      id: json['id'] as String? ?? '',
      isClientDisplay: json['isClientDisplay'] as bool? ?? false,
      isClientFromAlbum: json['isClientFromAlbum'] as bool? ?? false,
      isClientFromCamera: json['isClientFromCamera'] as bool? ?? false,
      isClientFromFileSystem: json['isClientFromFileSystem'] as bool? ?? false,
      isClientRequired: json['isClientRequired'] as bool? ?? false,
      isReadonly: json['isReadonly'] as bool? ?? false,
      moduleBackgroundImageUrl:
          json['moduleBackgroundImageUrl'] as String? ?? '',
      moduleDescription: json['moduleDescription'] as String? ?? '',
      moduleFormat: json['moduleFormat'] as String? ?? '',
      modulePrefix: json['modulePrefix'] as String? ?? '',
      moduleSuffix: json['moduleSuffix'] as String? ?? '',
      moduleTitle: json['moduleTitle'] as String? ?? '',
      moduleType: json['moduleType'] as String? ?? '',
      orgId: json['orgId'] as String? ?? '',
      type: json['type'] as String? ?? '',
      fontColor: json['fontColor'] as String? ?? '',
      backgroundColor: json['backgroundColor'] as String? ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'categoryCode': categoryCode,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'configId': configId,
      'fieldCode': fieldCode,
      'fieldEnumCode': fieldEnumCode,
      'fieldName': fieldName,
      'fieldSort': fieldSort,
      'id': id,
      'isClientDisplay': isClientDisplay,
      'isClientFromAlbum': isClientFromAlbum,
      'isClientFromCamera': isClientFromCamera,
      'isClientFromFileSystem': isClientFromFileSystem,
      'isClientRequired': isClientRequired,
      'isReadonly': isReadonly,
      'moduleBackgroundImageUrl': moduleBackgroundImageUrl,
      'moduleDescription': moduleDescription,
      'moduleFormat': moduleFormat,
      'modulePrefix': modulePrefix,
      'moduleSuffix': moduleSuffix,
      'moduleTitle': moduleTitle,
      'moduleType': moduleType,
      'orgId': orgId,
      'type': type,
      'fontColor': fontColor,
      'backgroundColor': backgroundColor,
    };
  }
}
