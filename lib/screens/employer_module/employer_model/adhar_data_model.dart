class AadhaarDataModel {
  String? name;
  String? dob;
  String? gender;
  String? houseNumber;
  String? street;
  String? locality;
  String? landmark;
  String? postOffice;
  String? state;
  String? district;
  String? subDistrict;
  String? country;
  String? address;
  String? pincode;
  String? image;
  String? fatherName;
  String? shareCode;

  AadhaarDataModel(
      {this.name,
      this.dob,
      this.gender,
      this.houseNumber,
      this.street,
      this.locality,
      this.landmark,
      this.postOffice,
      this.state,
      this.district,
      this.subDistrict,
      this.country,
      this.address,
      this.pincode,
      this.image,
      this.fatherName,
      this.shareCode});

  AadhaarDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
    houseNumber = json['house Number'];
    street = json['street'];
    locality = json['locality'];
    landmark = json['landmark'];
    postOffice = json['post Office'];
    state = json['state'];
    district = json['district'];
    subDistrict = json['sub District'];
    country = json['country'];
    address = json['address'];
    pincode = json['pincode'];
    image = json['image'];
    fatherName = json['father Name'];
    shareCode = json['shareCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['house Number'] = this.houseNumber;
    data['street'] = this.street;
    data['locality'] = this.locality;
    data['landmark'] = this.landmark;
    data['post Office'] = this.postOffice;
    data['state'] = this.state;
    data['district'] = this.district;
    data['sub District'] = this.subDistrict;
    data['country'] = this.country;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['image'] = this.image;
    data['father Name'] = this.fatherName;
    data['shareCode'] = this.shareCode;
    return data;
  }
}
