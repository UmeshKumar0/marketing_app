class GSTdetails {
  Dealer? dealer;
  bool? status;

  GSTdetails({this.dealer, this.status});

  GSTdetails.fromJson(Map<String, dynamic> json) {
    dealer = json['dealer'] != null ? Dealer.fromJson(json['dealer']) : null;
    status = json['status'];
  }
}

class Dealer {
  String? sId;
  String? counterName;
  String? legalName;
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
  List<String>? lastFySales;
  List<String>? lastFyTurnover;
  List<String>? ironDealers;
  List<String>? magadhDealers;

  Dealer({
    this.sId,
    this.counterName,
    this.firmName,
    this.partnerName,
    this.legalName,
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
    this.ironDealers,
    this.magadhDealers,
  });

  Dealer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    counterName = json['counter_name'];
    firmName = json['firm_name'];
    partnerName = json['partner_name'];
    legalName = json['leagal_name'];
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
    if (json['last_fy_sales'] != null) {
      lastFySales = <String>[];
      json['last_fy_sales'].forEach((v) {
        lastFySales!.add(v);
      });
    }
    if (json['last_fy_turnover'] != null) {
      lastFyTurnover = <String>[];
      json['last_fy_turnover'].forEach((v) {
        lastFyTurnover!.add(v);
      });
    }
    if (json['iron_dealers'] != null) {
      ironDealers = <String>[];
      json['iron_dealers'].forEach((v) {
        ironDealers!.add(v);
      });
    }
    if (json['magadh_dealers'] != null) {
      magadhDealers = <String>[];
      json['magadh_dealers'].forEach((v) {
        magadhDealers!.add(v);
      });
    }
  }
}
