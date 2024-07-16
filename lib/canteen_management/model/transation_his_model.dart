class TransationHistoryModel {
  String? type;
  List<TransationHistoryModelValues>? values;

  TransationHistoryModel({this.type, this.values});

  TransationHistoryModel.fromJson(Map<String, dynamic> json) {
    type = json['\$type'];
    if (json['\$values'] != null) {
      values = <TransationHistoryModelValues>[];
      json['\$values'].forEach((v) {
        values!.add(TransationHistoryModelValues.fromJson(v));
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

class   TransationHistoryModelValues {
  String? type;
  int? cMTRANSId;
  int? mIId;
  bool? cMTRANSMemberFlg;
  int? aCMSTId;
  int? hRMEId;
  double? cMTRANSAmount;
  double? cMTRANSTaxAmount;
  double? cMTRANSTotalAmount;
  String? cMTRANSRemarks;
  double? cMTRANSPaidAmount;
  double? cMTRANSPendingAmount;
  bool? cMTRANSKOTPrintedFlg;
  dynamic cMTRANSNoofKOTPrints;
  bool? cMTRANSVoidKotFlg;
  dynamic cMTRANSVoidReasons;
  bool? cMTRANSSelfCheckInFlg;
  int? cMTRANSSecurityCode;
  bool? cMTRANSActiveFlg;
  dynamic cMTRANSCreatedBy;
  int? cMTRANSUpdatedBy;
  dynamic cMTRANSCreatedDate;
  String? cMTRANSUpdateddate;
  String? cMTransactionnum;
  int? cMOrderID;

  TransationHistoryModelValues(
      {this.type,
      this.cMTRANSId,
      this.mIId,
      this.cMTRANSMemberFlg,
      this.aCMSTId,
      this.hRMEId,
      this.cMTRANSAmount,
      this.cMTRANSTaxAmount,
      this.cMTRANSTotalAmount,
      this.cMTRANSRemarks,
      this.cMTRANSPaidAmount,
      this.cMTRANSPendingAmount,
      this.cMTRANSKOTPrintedFlg,
      this.cMTRANSNoofKOTPrints,
      this.cMTRANSVoidKotFlg,
      this.cMTRANSVoidReasons,
      this.cMTRANSSelfCheckInFlg,
      this.cMTRANSSecurityCode,
      this.cMTRANSActiveFlg,
      this.cMTRANSCreatedBy,
      this.cMTRANSUpdatedBy,
      this.cMTRANSCreatedDate,
      this.cMTRANSUpdateddate,
      this.cMTransactionnum,
      this.cMOrderID});

  TransationHistoryModelValues.fromJson(Map<String, dynamic> json) {
    type = json['$type'];
    cMTRANSId = json['CMTRANS_Id'];
    mIId = json['MI_Id'];
    cMTRANSMemberFlg = json['CMTRANS_MemberFlg'];
    aCMSTId = json['ACMST_Id'];
    hRMEId = json['HRME_Id'];
    cMTRANSAmount = json['CMTRANS_Amount'];
    cMTRANSTaxAmount = json['CMTRANS_TaxAmount'];
    cMTRANSTotalAmount = json['CMTRANS_TotalAmount'];
    cMTRANSRemarks = json['CMTRANS_Remarks'];
    cMTRANSPaidAmount = json['CMTRANS_PaidAmount'];
    cMTRANSPendingAmount = json['CMTRANS_PendingAmount'];
    cMTRANSKOTPrintedFlg = json['CMTRANS_KOTPrintedFlg'];
    cMTRANSNoofKOTPrints = json['CMTRANS_NoofKOTPrints'];
    cMTRANSVoidKotFlg = json['CMTRANS_VoidKotFlg'];
    cMTRANSVoidReasons = json['CMTRANS_VoidReasons'];
    cMTRANSSelfCheckInFlg = json['CMTRANS_SelfCheckInFlg'];
    cMTRANSSecurityCode = json['CMTRANS_SecurityCode'];
    cMTRANSActiveFlg = json['CMTRANS_ActiveFlg'];
    cMTRANSCreatedBy = json['CMTRANS_CreatedBy'];
    cMTRANSUpdatedBy = json['CMTRANS_UpdatedBy'];
    cMTRANSCreatedDate = json['CMTRANS_CreatedDate'];
    cMTRANSUpdateddate = json['CMTRANS_Updateddate'];
    cMTransactionnum = json['CM_Transactionnum'];
    cMOrderID = json['CM_orderID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['$type'] = type;
    data['CMTRANS_Id'] = cMTRANSId;
    data['MI_Id'] = mIId;
    data['CMTRANS_MemberFlg'] = cMTRANSMemberFlg;
    data['ACMST_Id'] = aCMSTId;
    data['HRME_Id'] = hRMEId;
    data['CMTRANS_Amount'] = cMTRANSAmount;
    data['CMTRANS_TaxAmount'] = cMTRANSTaxAmount;
    data['CMTRANS_TotalAmount'] = cMTRANSTotalAmount;
    data['CMTRANS_Remarks'] = cMTRANSRemarks;
    data['CMTRANS_PaidAmount'] = cMTRANSPaidAmount;
    data['CMTRANS_PendingAmount'] = cMTRANSPendingAmount;
    data['CMTRANS_KOTPrintedFlg'] = cMTRANSKOTPrintedFlg;
    data['CMTRANS_NoofKOTPrints'] = cMTRANSNoofKOTPrints;
    data['CMTRANS_VoidKotFlg'] = cMTRANSVoidKotFlg;
    data['CMTRANS_VoidReasons'] = cMTRANSVoidReasons;
    data['CMTRANS_SelfCheckInFlg'] = cMTRANSSelfCheckInFlg;
    data['CMTRANS_SecurityCode'] = cMTRANSSecurityCode;
    data['CMTRANS_ActiveFlg'] = cMTRANSActiveFlg;
    data['CMTRANS_CreatedBy'] = cMTRANSCreatedBy;
    data['CMTRANS_UpdatedBy'] = cMTRANSUpdatedBy;
    data['CMTRANS_CreatedDate'] = cMTRANSCreatedDate;
    data['CMTRANS_Updateddate'] = cMTRANSUpdateddate;
    data['CM_Transactionnum'] = cMTransactionnum;
    data['CM_orderID'] = cMOrderID;
    return data;
  }
}
