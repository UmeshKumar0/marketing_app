class TempGSTDetals {
  TempDealer? dealer;
  bool? status;

  TempGSTDetals({this.dealer, this.status});

  TempGSTDetals.fromJson(Map<String, dynamic> json) {
    dealer =
        json['dealer'] != null ? TempDealer.fromJson(json['dealer']) : null;
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

class TempDealer {
  String? gstin;
  String? tradeName;
  String? legalName;
  String? addrBnm;
  String? addrBno;
  String? addrFlno;
  String? addrSt;
  String? addrLoc;
  int? stateCode;
  int? addrPncd;
  String? txpType;
  String? status;
  String? blkStatus;
  String? dtReg;

  TempDealer({
    this.gstin,
    this.tradeName,
    this.legalName,
    this.addrBnm,
    this.addrBno,
    this.addrFlno,
    this.addrSt,
    this.addrLoc,
    this.stateCode,
    this.addrPncd,
    this.txpType,
    this.status,
    this.blkStatus,
    this.dtReg,
  });

  TempDealer.fromJson(Map<String, dynamic> json) {
    gstin = json['Gstin'];
    tradeName = json['TradeName'];
    legalName = json['LegalName'];
    addrBnm = json['AddrBnm'];
    addrBno = json['AddrBno'];
    addrFlno = json['AddrFlno'];
    addrSt = json['AddrSt'];
    addrLoc = json['AddrLoc'];
    stateCode = json['StateCode'];
    addrPncd = json['AddrPncd'];
    txpType = json['TxpType'];
    status = json['Status'];
    blkStatus = json['BlkStatus'];
    dtReg = json['DtReg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Gstin'] = gstin;
    data['TradeName'] = tradeName;
    data['LegalName'] = legalName;
    data['AddrBnm'] = addrBnm;
    data['AddrBno'] = addrBno;
    data['AddrFlno'] = addrFlno;
    data['AddrSt'] = addrSt;
    data['AddrLoc'] = addrLoc;
    data['StateCode'] = stateCode;
    data['AddrPncd'] = addrPncd;
    data['TxpType'] = txpType;
    data['Status'] = status;
    data['BlkStatus'] = blkStatus;
    data['DtReg'] = dtReg;
    return data;
  }
}
