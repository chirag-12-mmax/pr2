class EmployerConfigurationModel {
  bool? isDynamicForm;
  bool? isGlobalClient;
  bool? isNonGulfClient;
  bool? isAadhaarMandatory;
  String? employeeName;
  String? companyLogo;

  EmployerConfigurationModel(
      {this.isDynamicForm,
      this.isGlobalClient,
      this.isNonGulfClient,
      this.isAadhaarMandatory,
      this.employeeName,
      this.companyLogo});

  EmployerConfigurationModel.fromJson(Map<String, dynamic> json) {
    isDynamicForm = json['isDynamicForm'];
    isGlobalClient = json['isGlobalClient'];
    isNonGulfClient = json['isNonGulfClient'];
    isAadhaarMandatory = json['isAadhaarMandatory'];
    employeeName = json['employeeName'];
    companyLogo = json['companyLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDynamicForm'] = this.isDynamicForm;
    data['isGlobalClient'] = this.isGlobalClient;
    data['isNonGulfClient'] = this.isNonGulfClient;
    data['isAadhaarMandatory'] = this.isAadhaarMandatory;
    data['employeeName'] = this.employeeName;
    data['companyLogo'] = this.companyLogo;
    return data;
  }
}