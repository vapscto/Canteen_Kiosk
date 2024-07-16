class TransationBillModel {
  String? type;
  List<TransationBillModelValues>? values;

  TransationBillModel({this.type, this.values});

  TransationBillModel.fromJson(Map<String, dynamic> json) {
    type = json['\$type'];
    if (json['\$values'] != null) {
      values = <TransationBillModelValues>[];
      json['\$values'].forEach((v) {
        values!.add(TransationBillModelValues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$type'] = type;
    if (values != null) {
      data['\$values'] = values!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransationBillModelValues {
  String? type;
  int? aCMSTId;
  String? aMSTFirstName;
  double? cMTRANSTotalAmount;
  String? cMTransactionnum;
  int? cMOrderID;
  String? cMTRANSIName;
  double? cMTRANSQty;
  double? cMTRANSIUnitRate;
  int? rollNo;
  String? className;
  String? sectionName;
  String? logo;
  int? cMMFIId;
  int? cMMCAId;
  String? cMMCACategoryName;bool? voidItemFlag; String? sGST;
  String? cGST;
  String? gSTIN;
  String? fSSAI;

  TransationBillModelValues(
      {this.type,
        this.aCMSTId,
        this.aMSTFirstName,
        this.cMTRANSTotalAmount,
        this.cMTransactionnum,
        this.cMOrderID,
        this.cMTRANSIName,
        this.cMTRANSQty,
        this.cMTRANSIUnitRate,
        this.rollNo,
        this.className,
        this.sectionName,
        this.logo,
        this.cMMFIId,
        this.cMMCAId,
        this.cMMCACategoryName,this.voidItemFlag,this.sGST,
        this.cGST,
        this.gSTIN,
        this.fSSAI});

  TransationBillModelValues.fromJson(Map<String, dynamic> json) {
    type = json['$type'];
    aCMSTId = json['ACMST_Id'];
    aMSTFirstName = json['AMST_FirstName'];
    cMTRANSTotalAmount = json['CMTRANS_TotalAmount'];
    cMTransactionnum = json['CM_Transactionnum'];
    cMOrderID = json['CM_orderID'];
    cMTRANSIName = json['CMTRANSI_name'];
    cMTRANSQty = json['CMTRANS_Qty'];
    cMTRANSIUnitRate = json['CMTRANSI_UnitRate'];
    rollNo = json['RollNo'];
    className = json['ClassName'];
    sectionName = json['SectionName'];
    logo = json['Logo'];
    cMMFIId = json['CMMFI_Id'];
    cMMCAId = json['CMMCA_Id'];
    cMMCACategoryName = json['CMMCA_CategoryName'];
    voidItemFlag = json['CMTRANSI_VoidItemFlg']??false;
    sGST = json['SGST'];
    cGST = json['CGST'];
    gSTIN = json['GSTIN'];
    fSSAI = json['FSSAI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['$type'] = type;
    data['ACMST_Id'] = aCMSTId;
    data['AMST_FirstName'] = aMSTFirstName;
    data['CMTRANS_TotalAmount'] = cMTRANSTotalAmount;
    data['CM_Transactionnum'] = cMTransactionnum;
    data['CM_orderID'] = cMOrderID;
    data['CMTRANSI_name'] = cMTRANSIName;
    data['CMTRANS_Qty'] = cMTRANSQty;
    data['CMTRANSI_UnitRate'] = cMTRANSIUnitRate;
    data['RollNo'] = rollNo;
    data['ClassName'] = className;
    data['SectionName'] = sectionName;
    data['Logo'] = logo;
    data['CMMFI_Id'] = cMMFIId;
    data['CMMCA_Id'] = cMMCAId;
    data['CMMCA_CategoryName'] = cMMCACategoryName;
    data['CMTRANSI_VoidItemFlg'] = voidItemFlag;
    data['SGST'] = sGST;
    data['CGST'] = cGST;
    data['GSTIN'] = gSTIN;
    data['FSSAI'] = fSSAI;
    return data;
  }
}
