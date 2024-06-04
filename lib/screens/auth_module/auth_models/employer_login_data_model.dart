class EmployerLoginDataModel {
  int? code;
  String? uRL;
  List<RoleWiseMenu>? roleWiseMenu;
  String? lastLogin;
  String? key;
  String? tokenValue;
  String? signUpID;
  String? isPaaS;
  String? oTPOnLogin;
  String? isNewDirectory;
  String? alertMessage;
  String? host;
  String? multiShiftKey;
  bool? isNewUxDesign;
  bool? newUxConfigure;
  String? isNewEDConfigure;
  String? subscriptionId;
  String? employCode;
  String? employPassword;

  EmployerLoginDataModel(
      {this.code,
      this.uRL,
      this.roleWiseMenu,
      this.lastLogin,
      this.key,
      this.tokenValue,
      this.signUpID,
      this.isPaaS,
      this.oTPOnLogin,
      this.isNewDirectory,
      this.alertMessage,
      this.host,
      this.multiShiftKey,
      this.isNewUxDesign,
      this.newUxConfigure,
      this.isNewEDConfigure,
      this.subscriptionId,
      this.employCode,
      this.employPassword});

  EmployerLoginDataModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    uRL = json['URL'];
    if (json['RoleWiseMenu'] != null) {
      roleWiseMenu = <RoleWiseMenu>[];
      json['RoleWiseMenu'].forEach((v) {
        roleWiseMenu!.add(RoleWiseMenu.fromJson(v));
      });
    }
    lastLogin = json['LastLogin'];
    key = json['key'];
    tokenValue = json['TokenValue'];
    signUpID = json['SignUpID'];
    isPaaS = json['IsPaaS'];
    oTPOnLogin = json['OTPOnLogin'];
    isNewDirectory = json['IsNewDirectory'];
    alertMessage = json['AlertMessage'];
    host = json['Host'];
    multiShiftKey = json['MultiShiftKey'];
    isNewUxDesign = json['IsNewUxDesign'];
    newUxConfigure = json['NewUxConfigure'];
    isNewEDConfigure = json['IsNewEDConfigure'];
    subscriptionId = json['subscriptionId'];
    employCode = json['employCode'];
    employPassword = json['employPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['URL'] = uRL;
    if (roleWiseMenu != null) {
      data['RoleWiseMenu'] = roleWiseMenu!.map((v) => v.toJson()).toList();
    }
    data['LastLogin'] = lastLogin;
    data['key'] = key;
    data['TokenValue'] = tokenValue;
    data['SignUpID'] = signUpID;
    data['IsPaaS'] = isPaaS;
    data['OTPOnLogin'] = oTPOnLogin;
    data['IsNewDirectory'] = isNewDirectory;
    data['AlertMessage'] = alertMessage;
    data['Host'] = host;
    data['MultiShiftKey'] = multiShiftKey;
    data['IsNewUxDesign'] = isNewUxDesign;
    data['NewUxConfigure'] = newUxConfigure;
    data['IsNewEDConfigure'] = isNewEDConfigure;
    data['subscriptionId'] = subscriptionId;
    data['employCode'] = employCode;
    data['employPassword'] = employPassword;
    return data;
  }
}

class RoleWiseMenu {
  String? screenCode;
  String? applicable;
  String? sortorder;

  RoleWiseMenu({this.screenCode, this.applicable, this.sortorder});

  RoleWiseMenu.fromJson(Map<String, dynamic> json) {
    screenCode = json['ScreenCode'];
    applicable = json['Applicable'];
    sortorder = json['sortorder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ScreenCode'] = screenCode;
    data['Applicable'] = applicable;
    data['sortorder'] = sortorder;
    return data;
  }
}
