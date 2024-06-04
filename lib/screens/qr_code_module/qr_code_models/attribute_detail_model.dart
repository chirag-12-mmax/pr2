// class AttributeDetailModel {
//   List<AttributeDetails>? attributeDetails;
//   List<AttributeUnits>? attributeUnits;
//   List<AttributeDefaultValues>? attributeDefaultValues;
//   List<AttributeRelation>? attributeRelation;

//   AttributeDetailModel(
//       {this.attributeDetails,
//       this.attributeUnits,
//       this.attributeDefaultValues,
//       this.attributeRelation});

//   AttributeDetailModel.fromJson(Map<String, dynamic> json) {
//     if (json['attributeDetails'] != null) {
//       attributeDetails = <AttributeDetails>[];
//       json['attributeDetails'].forEach((v) {
//         attributeDetails!.add(AttributeDetails.fromJson(v));
//       });
//     }
//     if (json['attributeUnits'] != null) {
//       attributeUnits = <AttributeUnits>[];
//       json['attributeUnits'].forEach((v) {
//         attributeUnits!.add(AttributeUnits.fromJson(v));
//       });
//     }
//     if (json['attributeDefaultValues'] != null) {
//       attributeDefaultValues = <AttributeDefaultValues>[];
//       json['attributeDefaultValues'].forEach((v) {
//         attributeDefaultValues!.add(AttributeDefaultValues.fromJson(v));
//       });
//     }
//     if (json['attributeRelation'] != null) {
//       attributeRelation = <AttributeRelation>[];
//       json['attributeRelation'].forEach((v) {
//         attributeRelation!.add(AttributeRelation.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (attributeDetails != null) {
//       data['attributeDetails'] =
//           attributeDetails!.map((v) => v.toJson()).toList();
//     }
//     if (attributeUnits != null) {
//       data['attributeUnits'] = attributeUnits!.map((v) => v.toJson()).toList();
//     }
//     if (attributeDefaultValues != null) {
//       data['attributeDefaultValues'] =
//           attributeDefaultValues!.map((v) => v.toJson()).toList();
//     }
//     if (attributeRelation != null) {
//       data['attributeRelation'] =
//           attributeRelation!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class AttributeDetails {
//   int? row;
//   int? attrId;
//   String? attrDesc;
//   String? attrCode;
//   int? sortOrder;
//   bool? isVisible;
//   bool? isMandatory;
//   bool? isEditable;

//   AttributeDetails(
//       {this.row,
//       this.attrId,
//       this.attrDesc,
//       this.attrCode,
//       this.sortOrder,
//       this.isVisible,
//       this.isMandatory,
//       this.isEditable});

//   AttributeDetails.fromJson(Map<String, dynamic> json) {
//     row = json['row'];
//     attrId = json['attrId'];
//     attrDesc = json['attrDesc'];
//     attrCode = json['attrCode'];
//     sortOrder = json['sortOrder'];
//     isVisible = json['isVisible'];
//     isMandatory = json['isMandatory'];
//     isEditable = json['isEditable'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['row'] = row;
//     data['attrId'] = attrId;
//     data['attrDesc'] = attrDesc;
//     data['attrCode'] = attrCode;
//     data['sortOrder'] = sortOrder;
//     data['isVisible'] = isVisible;
//     data['isMandatory'] = isMandatory;
//     data['isEditable'] = isEditable;
//     return data;
//   }
// }

// class AttributeUnits {
//   int? attrId;
//   int? attrUnitId;
//   String? attrUnitDesc;

//   AttributeUnits({this.attrId, this.attrUnitId, this.attrUnitDesc});

//   AttributeUnits.fromJson(Map<String, dynamic> json) {
//     attrId = json['attrId'];
//     attrUnitId = json['attrUnitId'];
//     attrUnitDesc = json['attrUnitDesc'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['attrId'] = attrId;
//     data['attrUnitId'] = attrUnitId;
//     data['attrUnitDesc'] = attrUnitDesc;
//     return data;
//   }
// }

// class AttributeDefaultValues {
//   String? attrCode;
//   String? attrValue;

//   AttributeDefaultValues({this.attrCode, this.attrValue});

//   AttributeDefaultValues.fromJson(Map<String, dynamic> json) {
//     attrCode = json['attrCode'];
//     attrValue = json['attrValue'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['attrCode'] = attrCode;
//     data['attrValue'] = attrValue;
//     return data;
//   }
// }

// class AttributeRelation {
//   int? parentId;
//   String? childId;

//   AttributeRelation({this.parentId, this.childId});

//   AttributeRelation.fromJson(Map<String, dynamic> json) {
//     parentId = json['parentId'];
//     childId = json['childId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['parentId'] = parentId;
//     data['childId'] = childId;
//     return data;
//   }
// }
