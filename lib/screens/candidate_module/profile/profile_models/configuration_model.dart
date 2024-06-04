class ConfigurationModel {
  List<TabDetails>? tabDetails;
  List<FieldConfigDetails>? fieldConfigDetails;
  List<TabWiseFieldConfig>? tabWiseFieldConfig;
  List<OtherApplicability>? otherApplicability;
  String? edApproverDetailsForAllTabs;
  dynamic apiToken;
  String? employeeRole;

  ConfigurationModel(
      {this.tabDetails,
      this.fieldConfigDetails,
      this.tabWiseFieldConfig,
      this.otherApplicability,
      this.edApproverDetailsForAllTabs,
      this.apiToken,
      this.employeeRole});

  ConfigurationModel.fromJson(Map<String, dynamic> json) {
    if (json['tabdetails'] != null) {
      tabDetails = <TabDetails>[];
      json['tabdetails'].forEach((v) {
        tabDetails!.add(TabDetails.fromJson(v));
      });
    }
    if (json['fieldConfigDetails'] != null) {
      fieldConfigDetails = <FieldConfigDetails>[];
      json['fieldConfigDetails'].forEach((v) {
        fieldConfigDetails!.add(FieldConfigDetails.fromJson(v));
      });
    }
    if (json['tabWiseFieldConfig'] != null) {
      tabWiseFieldConfig = <TabWiseFieldConfig>[];
      json['tabWiseFieldConfig'].forEach((v) {
        tabWiseFieldConfig!.add(TabWiseFieldConfig.fromJson(v));
      });
    }
    if (json['otherApplicability'] != null) {
      otherApplicability = <OtherApplicability>[];
      json['otherApplicability'].forEach((v) {
        otherApplicability!.add(OtherApplicability.fromJson(v));
      });
    }
    edApproverDetailsForAllTabs = json['edApproverDetailsForAllTabs'];
    apiToken = json['apiToken'];
    employeeRole = json['employeeRole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (tabDetails != null) {
      data['tabdetails'] = tabDetails!.map((v) => v.toJson()).toList();
    }
    if (fieldConfigDetails != null) {
      data['fieldConfigDetails'] =
          fieldConfigDetails!.map((v) => v.toJson()).toList();
    }
    if (tabWiseFieldConfig != null) {
      data['tabWiseFieldConfig'] =
          tabWiseFieldConfig!.map((v) => v.toJson()).toList();
    }
    if (otherApplicability != null) {
      data['otherApplicability'] =
          otherApplicability!.map((v) => v.toJson()).toList();
    }
    data['edApproverDetailsForAllTabs'] = edApproverDetailsForAllTabs;
    data['apiToken'] = apiToken;
    data['employeeRole'] = employeeRole;
    return data;
  }
}

class TabDetails {
  int? combinationId;
  int? tabId;
  int? sectionId;
  String? fieldCode;
  int? fieldId;
  String? tooltip;
  String? fieldName;
  dynamic recFieldCode;
  bool? editFlag;
  bool? mandatoryFlag;
  bool? viewFlag;
  bool? deleteFlag;
  int? sortOrder;
  bool? approvalFlag;
  String? maxApproverLevel;
  String? role;
  bool? isDateControl;
  dynamic fieldValidation;
  bool? isStatutory;
  dynamic fieldTag;
  dynamic countryPack;
  int? signUpId;
  dynamic countryId;
  bool? isCustomField;
  dynamic minTimeStamp;
  dynamic maxTimeStamp;
  bool? isLockedField;
  bool? isMultilingual;
  dynamic masterColumn;
  bool? isMandatoryMultilingual;
  dynamic control;

  TabDetails(
      {this.combinationId,
      this.tabId,
      this.sectionId,
      this.fieldCode,
      this.fieldId,
      this.tooltip,
      this.fieldName,
      this.recFieldCode,
      this.editFlag,
      this.mandatoryFlag,
      this.viewFlag,
      this.deleteFlag,
      this.sortOrder,
      this.approvalFlag,
      this.maxApproverLevel,
      this.role,
      this.isDateControl,
      this.fieldValidation,
      this.isStatutory,
      this.fieldTag,
      this.countryPack,
      this.signUpId,
      this.countryId,
      this.isCustomField,
      this.minTimeStamp,
      this.maxTimeStamp,
      this.isLockedField,
      this.isMultilingual,
      this.masterColumn,
      this.isMandatoryMultilingual,
      this.control});

  TabDetails.fromJson(Map<String, dynamic> json) {
    combinationId = json['combinationId'];
    tabId = json['tabId'];
    sectionId = json['sectionId'];
    fieldCode = json['fieldCode'];
    fieldId = json['fieldId'];
    tooltip = json['tooltip'];
    fieldName = json['fieldName'];
    recFieldCode = json['recFieldCode'];
    editFlag = json['editFlag'];
    mandatoryFlag = json['mandatoryFlag'];
    viewFlag = json['viewFlag'];
    deleteFlag = json['deleteFlag'];
    sortOrder = json['sortOrder'];
    approvalFlag = json['approvalFlag'];
    maxApproverLevel = json['maxApproverLevel'];
    role = json['role'];
    isDateControl = json['isDateControl'];
    fieldValidation = json['fieldValidation'];
    isStatutory = json['isStatutory'];
    fieldTag = json['fieldTag'];
    countryPack = json['countryPack'];
    signUpId = json['signUpId'];
    countryId = json['countryId'];
    isCustomField = json['isCustomField'];
    minTimeStamp = json['minTimeStamp'];
    maxTimeStamp = json['maxTimeStamp'];
    isLockedField = json['isLockedField'];
    isMultilingual = json['isMultilingual'];
    masterColumn = json['masterColumn'];
    isMandatoryMultilingual = json['isMandatoryMultilingual'];
    control = json['control'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['combinationId'] = combinationId;
    data['tabId'] = tabId;
    data['sectionId'] = sectionId;
    data['fieldCode'] = fieldCode;
    data['fieldId'] = fieldId;
    data['tooltip'] = tooltip;
    data['fieldName'] = fieldName;
    data['recFieldCode'] = recFieldCode;
    data['editFlag'] = editFlag;
    data['mandatoryFlag'] = mandatoryFlag;
    data['viewFlag'] = viewFlag;
    data['deleteFlag'] = deleteFlag;
    data['sortOrder'] = sortOrder;
    data['approvalFlag'] = approvalFlag;
    data['maxApproverLevel'] = maxApproverLevel;
    data['role'] = role;
    data['isDateControl'] = isDateControl;
    data['fieldValidation'] = fieldValidation;
    data['isStatutory'] = isStatutory;
    data['fieldTag'] = fieldTag;
    data['countryPack'] = countryPack;
    data['signUpId'] = signUpId;
    data['countryId'] = countryId;
    data['isCustomField'] = isCustomField;
    data['minTimeStamp'] = minTimeStamp;
    data['maxTimeStamp'] = maxTimeStamp;
    data['isLockedField'] = isLockedField;
    data['isMultilingual'] = isMultilingual;
    data['masterColumn'] = masterColumn;
    data['isMandatoryMultilingual'] = isMandatoryMultilingual;
    data['control'] = control;
    return data;
  }
}

class FieldConfigDetails {
  int? combinationId;
  int? tabId;
  int? sectionId;
  String? fieldCode;
  int? fieldId;
  String? tooltip;
  String? fieldName;
  String? recFieldCode;
  bool? editFlag;
  bool? mandatoryFlag;
  bool? viewFlag;
  bool? deleteFlag;
  int? sortOrder;
  bool? approvalFlag;
  dynamic maxApproverLevel;
  String? role;
  bool? isDateControl;
  String? fieldValidation;
  bool? isStatutory;
  String? fieldTag;
  String? countryPack;
  int? signUpId;
  dynamic countryId;
  bool? isCustomField;
  String? minTimeStamp;
  String? maxTimeStamp;
  bool? isLockedField;
  bool? isMultilingual;
  String? masterColumn;
  bool? isMandatoryMultilingual;
  String? control;

  FieldConfigDetails(
      {this.combinationId,
      this.tabId,
      this.sectionId,
      this.fieldCode,
      this.fieldId,
      this.tooltip,
      this.fieldName,
      this.recFieldCode,
      this.editFlag,
      this.mandatoryFlag,
      this.viewFlag,
      this.deleteFlag,
      this.sortOrder,
      this.approvalFlag,
      this.maxApproverLevel,
      this.role,
      this.isDateControl,
      this.fieldValidation,
      this.isStatutory,
      this.fieldTag,
      this.countryPack,
      this.signUpId,
      this.countryId,
      this.isCustomField,
      this.minTimeStamp,
      this.maxTimeStamp,
      this.isLockedField,
      this.isMultilingual,
      this.masterColumn,
      this.isMandatoryMultilingual,
      this.control});

  FieldConfigDetails.fromJson(Map<String, dynamic> json) {
    combinationId = json['combinationId'];
    tabId = json['tabId'];
    sectionId = json['sectionId'];
    fieldCode = json['fieldCode'];
    fieldId = json['fieldId'];
    tooltip = json['tooltip'];
    fieldName = json['fieldName'];
    recFieldCode = json['recFieldCode'];
    editFlag = json['editFlag'];
    mandatoryFlag = json['mandatoryFlag'];
    viewFlag = json['viewFlag'];
    deleteFlag = json['deleteFlag'];
    sortOrder = json['sortOrder'];
    approvalFlag = json['approvalFlag'];
    maxApproverLevel = json['maxApproverLevel'];
    role = json['role'];
    isDateControl = json['isDateControl'];
    fieldValidation = json['fieldValidation'];
    isStatutory = json['isStatutory'];
    fieldTag = json['fieldTag'];
    countryPack = json['countryPack'];
    signUpId = json['signUpId'];
    countryId = json['countryId'];
    isCustomField = json['isCustomField'];
    minTimeStamp = json['minTimeStamp'];
    maxTimeStamp = json['maxTimeStamp'];
    isLockedField = json['isLockedField'];
    isMultilingual = json['isMultilingual'];
    masterColumn = json['masterColumn'];
    isMandatoryMultilingual = json['isMandatoryMultilingual'];
    control = json['control'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['combinationId'] = combinationId;
    data['tabId'] = tabId;
    data['sectionId'] = sectionId;
    data['fieldCode'] = fieldCode;
    data['fieldId'] = fieldId;
    data['tooltip'] = tooltip;
    data['fieldName'] = fieldName;
    data['recFieldCode'] = recFieldCode;
    data['editFlag'] = editFlag;
    data['mandatoryFlag'] = mandatoryFlag;
    data['viewFlag'] = viewFlag;
    data['deleteFlag'] = deleteFlag;
    data['sortOrder'] = sortOrder;
    data['approvalFlag'] = approvalFlag;
    data['maxApproverLevel'] = maxApproverLevel;
    data['role'] = role;
    data['isDateControl'] = isDateControl;
    data['fieldValidation'] = fieldValidation;
    data['isStatutory'] = isStatutory;
    data['fieldTag'] = fieldTag;
    data['countryPack'] = countryPack;
    data['signUpId'] = signUpId;
    data['countryId'] = countryId;
    data['isCustomField'] = isCustomField;
    data['minTimeStamp'] = minTimeStamp;
    data['maxTimeStamp'] = maxTimeStamp;
    data['isLockedField'] = isLockedField;
    data['isMultilingual'] = isMultilingual;
    data['masterColumn'] = masterColumn;
    data['isMandatoryMultilingual'] = isMandatoryMultilingual;
    data['control'] = control;
    return data;
  }
}

class TabWiseFieldConfig {
  int? tabId;
  int? sectionId;
  int? fieldId;
  String? description;
  bool? isActive;
  String? createdDate;
  String? createdBy;
  String? type;

  TabWiseFieldConfig(
      {this.tabId,
      this.sectionId,
      this.fieldId,
      this.description,
      this.isActive,
      this.createdDate,
      this.createdBy,
      this.type});

  TabWiseFieldConfig.fromJson(Map<String, dynamic> json) {
    tabId = json['tabId'];
    sectionId = json['sectionId'];
    fieldId = json['fieldId'];
    description = json['description'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['tabId'] = tabId;
    data['sectionId'] = sectionId;
    data['fieldId'] = fieldId;
    data['description'] = description;
    data['isActive'] = isActive;
    data['createdDate'] = createdDate;
    data['createdBy'] = createdBy;
    data['type'] = type;
    return data;
  }
}

class OtherApplicability {
  String? isVP;
  String? isContractApplicable;

  OtherApplicability({this.isVP, this.isContractApplicable});

  OtherApplicability.fromJson(Map<String, dynamic> json) {
    isVP = json['isVP'];
    isContractApplicable = json['isContractApplicable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['isVP'] = isVP;
    data['isContractApplicable'] = isContractApplicable;
    return data;
  }
}
