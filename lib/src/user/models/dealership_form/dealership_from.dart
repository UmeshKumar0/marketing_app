import 'package:marketing/src/AppConfig.dart';

class DealershipForm {
  DealerShip? dealer;
  bool? status;

  DealershipForm({this.dealer, this.status});

  DealershipForm.fromJson(Map<String, dynamic> json) {
    dealer =
        json['dealer'] != null ? DealerShip.fromJson(json['dealer']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dealer != null) {
      data['dealer'] = dealer!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class DealerShip {
  BusinessDetails? businessDetails;
  StaffCount? staffCount;
  String? sId;
  String? counterName;
  String? firmName;
  String? partnerName;
  String? address;
  String? taluka;
  String? pincode;
  String? phone;
  String? landline;
  String? email;
  int? counterPotential;
  int? targetQuantity;
  int? spaceAvailable;
  String? gstNumber;
  String? panNumber;
  String? tradeLicense;
  int? dateOfTradeLicense;
  int? validityOfTradeLicense;
  String? chequeNumber;
  int? chequeDate;
  int? sdAmount;
  String? bankName;
  String? branchName;
  String? accountNumber;
  int? ccLimits;
  String? ifscCode;
  String? micrCode;
  List<int>? lastFySales;
  List<int>? lastFyTurnover;
  List<Documents>? documents;
  List<IronDealers>? ironDealers;
  List<MagadhDealers>? magadhDealers;
  int? iV;
  int? areaOfShop;
  int? godownArea;
  String? godownCondition;
  String? image;
  String? sign;

  DealerShip({
    this.businessDetails,
    this.staffCount,
    this.sId,
    this.counterName,
    this.firmName,
    this.partnerName,
    this.address,
    this.taluka,
    this.pincode,
    this.phone,
    this.landline,
    this.email,
    this.counterPotential,
    this.targetQuantity,
    this.spaceAvailable,
    this.gstNumber,
    this.panNumber,
    this.tradeLicense,
    this.dateOfTradeLicense,
    this.validityOfTradeLicense,
    this.chequeNumber,
    this.chequeDate,
    this.sdAmount,
    this.bankName,
    this.branchName,
    this.accountNumber,
    this.ccLimits,
    this.ifscCode,
    this.micrCode,
    this.lastFySales,
    this.lastFyTurnover,
    this.documents,
    this.ironDealers,
    this.magadhDealers,
    this.iV,
    this.areaOfShop,
    this.godownArea,
    this.godownCondition,
    this.image,
    this.sign,
  });

  DealerShip.fromJson(Map<String, dynamic> json) {
    businessDetails = json['business_details'] != null
        ? BusinessDetails.fromJson(json['business_details'])
        : null;
    staffCount = json['staff_count'] != null
        ? StaffCount.fromJson(json['staff_count'])
        : null;
    sId = json['_id'];
    counterName = json['counter_name'];
    firmName = json['firm_name'];
    partnerName = json['partner_name'];
    address = json['address'];
    taluka = json['taluka'];
    pincode = json['pincode'];
    phone = json['phone'];
    landline = json['landline'];
    email = json['email'];
    counterPotential = json['counter_potential'];
    targetQuantity = json['target_quantity'];
    spaceAvailable = json['space_available'];
    gstNumber = json['gst_number'];
    panNumber = json['pan_number'];
    tradeLicense = json['trade_license'];
    dateOfTradeLicense = json['date_of_trade_license'];
    validityOfTradeLicense = json['validity_of_trade_license'];
    chequeNumber = json['cheque_number'];
    chequeDate = json['cheque_date'];
    sdAmount = json['sd_amount'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    accountNumber = json['account_number'];
    ccLimits = json['cc_limits'];
    ifscCode = json['ifsc_code'];
    micrCode = json['micr_code'];
    lastFySales = json['last_fy_sales'].cast<int>();
    lastFyTurnover = json['last_fy_turnover'].cast<int>();
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    if (json['iron_dealers'] != null) {
      ironDealers = <IronDealers>[];
      json['iron_dealers'].forEach((v) {
        ironDealers!.add(IronDealers.fromJson(v));
      });
    }
    if (json['magadh_dealers'] != null) {
      magadhDealers = <MagadhDealers>[];
      json['magadh_dealers'].forEach((v) {
        magadhDealers!.add(MagadhDealers.fromJson(v));
      });
    }
    areaOfShop = json['area_of_shop'];
    godownArea = json['godown_area'];
    godownCondition = json['godown_condition'];
    print('${AppConfig.SERVER_IP}${json['sign']}');

    print('${AppConfig.SERVER_IP}${json['image']}');
    sign =
        json['sign'] != null ? '${AppConfig.SERVER_IP}/${json['sign']}' : null;
    image = json['image'] != null
        ? '${AppConfig.SERVER_IP}/${json['image']}'
        : null;
  }

  Map<String, dynamic> toCreate() {
    final Map<String, dynamic> data = {};
    data['counter_name'] = counterName;
    data['firm_name'] = firmName;
    data['address'] = address;
    data['taluka'] = taluka;
    data['pincode'] = pincode;
    data['phone'] = phone;
    data['landline'] = landline ?? '';
    data['email'] = email ?? '';
    data['counter_potential'] = counterPotential.toString();
    data['target_quantity'] = targetQuantity.toString();
    data['space_available'] = spaceAvailable.toString();
    data['gst_number'] = gstNumber;
    data['pan_number'] = panNumber;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['account_number'] = accountNumber;
    data['cc_limits'] = ccLimits;
    data['ifsc_code'] = ifscCode;
    data['micr_code'] = micrCode;
    data['trade_license'] = tradeLicense.toString();
    data['date_of_trade_license'] = dateOfTradeLicense.toString();
    data['validity_of_trade_license'] = validityOfTradeLicense.toString();
    data['cheque_number'] = chequeNumber.toString();
    data['cheque_date'] = chequeDate.toString();
    data['sd_amount'] = sdAmount.toString();
    data['partner_name'] = partnerName;

    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (businessDetails != null) {
      data['business_details'] = businessDetails!.toJson();
    }
    if (staffCount != null) {
      data['staff_count'] = staffCount!.toJson();
    }
    data['_id'] = sId;
    data['counter_name'] = counterName;
    data['firm_name'] = firmName;
    data['partner_name'] = partnerName;
    data['address'] = address;
    data['taluka'] = taluka;
    data['pincode'] = pincode;
    data['phone'] = phone;
    data['landline'] = landline;
    data['email'] = email;
    data['counter_potential'] = counterPotential;
    data['target_quantity'] = targetQuantity;
    data['space_available'] = spaceAvailable;
    data['gst_number'] = gstNumber;
    data['pan_number'] = panNumber;
    data['trade_license'] = tradeLicense;
    data['date_of_trade_license'] = dateOfTradeLicense;
    data['validity_of_trade_license'] = validityOfTradeLicense;
    data['cheque_number'] = chequeNumber;
    data['cheque_date'] = chequeDate;
    data['sd_amount'] = sdAmount;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['account_number'] = accountNumber;
    data['cc_limits'] = ccLimits;
    data['ifsc_code'] = ifscCode;
    data['micr_code'] = micrCode;
    data['last_fy_sales'] = lastFySales;
    data['last_fy_turnover'] = lastFyTurnover;
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    if (ironDealers != null) {
      data['iron_dealers'] = ironDealers!.map((v) => v.toJson()).toList();
    }
    if (magadhDealers != null) {
      data['magadh_dealers'] = magadhDealers!.map((v) => v.toJson()).toList();
    }
    data['__v'] = iV;
    data['area_of_shop'] = areaOfShop;
    data['godown_area'] = godownArea;
    data['godown_condition'] = godownCondition;
    return data;
  }
}

class BusinessDetails {
  String? businessType;
  int? establishmentDate;
  int? businessExperience;

  BusinessDetails(
      {this.businessType, this.establishmentDate, this.businessExperience});

  BusinessDetails.fromJson(Map<String, dynamic> json) {
    businessType = json['business_type'];
    establishmentDate = json['establishment_date'];
    businessExperience = json['business_experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_type'] = businessType;
    data['establishment_date'] = establishmentDate;
    data['business_experience'] = businessExperience;
    return data;
  }
}

class StaffCount {
  int? permanent;
  int? temporary;

  StaffCount({this.permanent, this.temporary});

  StaffCount.fromJson(Map<String, dynamic> json) {
    permanent = json['permanent'];
    temporary = json['temporary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['permanent'] = permanent;
    data['temporary'] = temporary;
    return data;
  }
}

class Documents {
  String? title;
  String? reason;
  String? sId;
  String? attachment;

  Documents({this.title, this.reason, this.sId, this.attachment});

  Documents.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    reason = json['reason'];
    sId = json['_id'];
    attachment = json['attachment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['reason'] = reason;
    data['_id'] = sId;
    data['attachment'] = attachment;
    return data;
  }
}

class IronDealers {
  String? name;
  int? totalSale;
  String? sId;

  IronDealers({this.name, this.totalSale, this.sId});

  IronDealers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    totalSale = json['total_sale'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['total_sale'] = totalSale;
    data['_id'] = sId;
    return data;
  }
}

class MagadhDealers {
  String? name;
  String? location;
  int? distance;
  String? remarks;
  String? sId;

  MagadhDealers(
      {this.name, this.location, this.distance, this.remarks, this.sId});

  MagadhDealers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    location = json['location'];
    distance = json['distance'];
    remarks = json['remarks'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['location'] = location;
    data['distance'] = distance;
    data['remarks'] = remarks;
    data['_id'] = sId;
    return data;
  }
}
