class CPShop {
  String? cpCode;
  String? email;
  String? displayName;
  String? mobile;
  String? userType;
  String? gst;
  String? businessName;
  String? businessAddress;
  String? businessAddress2;
  String? businessLoc;
  String? businessPincode;
  String? businessStatecode;
  String? businessStatus;
  String? businessPan;
  String? businessEmail;
  String? businessContact;
  String? ownerName;

  CPShop(
      {this.cpCode,
      this.email,
      this.displayName,
      this.mobile,
      this.userType,
      this.gst,
      this.businessName,
      this.businessAddress,
      this.businessAddress2,
      this.businessLoc,
      this.businessPincode,
      this.businessStatecode,
      this.businessStatus,
      this.businessPan,
      this.businessEmail,
      this.businessContact,
      this.ownerName});

  CPShop.fromJson(Map<String, dynamic> json) {
    cpCode = json['cp_code'];
    email = json['email'];
    displayName = json['display_name'];
    mobile = json['mobile'];
    userType = json['user_type'];
    gst = json['gst'];
    businessName = json['business_name'];
    businessAddress = json['business_address'];
    businessAddress2 = json['business_address2'];
    businessLoc = json['business_loc'];
    businessPincode = json['business_pincode'];
    businessStatecode = json['business_statecode'];
    businessStatus = json['business_status'];
    businessPan = json['business_pan'];
    businessEmail = json['business_email'];
    businessContact = json['business_contact'];
    ownerName = json['owner_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cp_code'] = cpCode;
    data['email'] = email;
    data['display_name'] = displayName;
    data['mobile'] = mobile;
    data['user_type'] = userType;
    data['gst'] = gst;
    data['business_name'] = businessName;
    data['business_address'] = businessAddress;
    data['business_address2'] = businessAddress2;
    data['business_loc'] = businessLoc;
    data['business_pincode'] = businessPincode;
    data['business_statecode'] = businessStatecode;
    data['business_status'] = businessStatus;
    data['business_pan'] = businessPan;
    data['business_email'] = businessEmail;
    data['business_contact'] = businessContact;
    data['owner_name'] = ownerName;
    return data;
  }
}
