class JobDescriptionModel {
  int? requisitionID;
  String? requisitionTitle;
  String? employementType;
  String? jobTitle;
  String? jobDescription;
  dynamic requisitionNumber;
  String? department;
  String? designation;
  String? location;
  String? gender;
  String? rulesAndResponsibility;
  String? krAs;
  String? skillsAndCompetencies;
  dynamic endDate;
  dynamic concept;
  dynamic country;
  bool? isGlobalClient;
  bool? isMultilingual;
  bool? isVideoInterviewMandatory;
  bool? isVideoInterviewApplicable;
  bool? isHijriCalender;
  int? signUpId;
  dynamic referralDetails;
  dynamic jdVideo;
  bool? isQRAadhaarEKYC;
  bool? isBrandedPage;
  dynamic brandedImage;
  String? companyLogo;
  dynamic organisationUnit;
  dynamic region;
  bool? isJdImage;
  String? jdImage;

  JobDescriptionModel({
    this.requisitionID,
    this.requisitionTitle,
    this.employementType,
    this.jobTitle,
    this.jobDescription,
    this.requisitionNumber,
    this.department,
    this.designation,
    this.location,
    this.gender,
    this.rulesAndResponsibility,
    this.krAs,
    this.skillsAndCompetencies,
    this.endDate,
    this.concept,
    this.country,
    this.isGlobalClient,
    this.isMultilingual,
    this.isVideoInterviewMandatory,
    this.isVideoInterviewApplicable,
    this.isHijriCalender,
    this.signUpId,
    this.referralDetails,
    this.jdVideo,
    this.isQRAadhaarEKYC,
    this.isBrandedPage,
    this.brandedImage,
    this.companyLogo,
    this.organisationUnit,
    this.region,
    this.isJdImage,
    this.jdImage,
  });

  JobDescriptionModel.fromJson(Map<String, dynamic> json) {
    requisitionID = json['requisitionID'];
    requisitionTitle = json['requisitionTitle'];
    employementType = json['employementType'];
    jobTitle = json['jobTitle'];
    jobDescription = json['jobDescription'];
    requisitionNumber = json['requisitionNumber'];
    department = json['department'];
    designation = json['designation'];
    location = json['location'];
    gender = json['gender'];
    rulesAndResponsibility = json['rulesAndResponsibility'];
    krAs = json['krAs'];
    skillsAndCompetencies = json['skillsAndCompetencies'];
    endDate = json['endDate'];
    concept = json['concept'];
    country = json['country'];
    isGlobalClient = json['isGlobalClient'];
    isMultilingual = json['isMultilingual'];
    isVideoInterviewMandatory = json['isVideoInterviewMandatory'];
    isVideoInterviewApplicable = json['isVideoInterviewApplicable'];
    isHijriCalender = json['isHijriCalender'];
    signUpId = json['signUpId'];
    referralDetails = json['referralDetails'];
    jdVideo = json['jdVideo'];
    isQRAadhaarEKYC = json['isQRAadhaarEKYC'];
    isBrandedPage = json['isBrandedPage'];
    brandedImage = json['brandedImage'];
    companyLogo = json['companyLogo'];
    organisationUnit = json['organisationUnit'];
    region = json['region'];
    isJdImage = json['isJdImage'];
    jdImage = json['jdImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requisitionID'] = requisitionID;
    data['requisitionTitle'] = requisitionTitle;
    data['employementType'] = employementType;
    data['jobTitle'] = jobTitle;
    data['jobDescription'] = jobDescription;
    data['requisitionNumber'] = requisitionNumber;
    data['department'] = department;
    data['designation'] = designation;
    data['location'] = location;
    data['gender'] = gender;
    data['rulesAndResponsibility'] = rulesAndResponsibility;
    data['krAs'] = krAs;
    data['skillsAndCompetencies'] = skillsAndCompetencies;
    data['endDate'] = endDate;
    data['concept'] = concept;
    data['country'] = country;
    data['isGlobalClient'] = isGlobalClient;
    data['isMultilingual'] = isMultilingual;
    data['isVideoInterviewMandatory'] = isVideoInterviewMandatory;
    data['isVideoInterviewApplicable'] = isVideoInterviewApplicable;
    data['isHijriCalender'] = isHijriCalender;
    data['signUpId'] = signUpId;
    data['referralDetails'] = referralDetails;
    data['jdVideo'] = jdVideo;
    data['isQRAadhaarEKYC'] = isQRAadhaarEKYC;
    data['isBrandedPage'] = isBrandedPage;
    data['brandedImage'] = brandedImage;
    data['companyLogo'] = companyLogo;
    data['organisationUnit'] = organisationUnit;
    data['region'] = region;
    data['isJdImage'] = isJdImage;
    data['jdImage'] = jdImage;
    return data;
  }
}
