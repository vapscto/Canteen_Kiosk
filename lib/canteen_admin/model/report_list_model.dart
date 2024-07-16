class ReportListModel {
  String? type;
  List<ReportListModelValues>? values;

  ReportListModel({this.type, this.values});

  ReportListModel.fromJson(Map<String, dynamic> json) {
    type = json['\$type'];
    if (json['\$values'] != null) {
      values = <ReportListModelValues>[];
      json['\$values'].forEach((v) {
        values!.add(ReportListModelValues.fromJson(v));
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

class ReportListModelValues {
  String? type;
  String? cMMFIFoodItemName;
  double? cMTRANSQty;
  double? totalAmount;
  String? cMTRANSIUpdateddate;
  String? categoryName;

  ReportListModelValues(
      {this.type,
        this.cMMFIFoodItemName,
        this.cMTRANSQty,
        this.totalAmount,
        this.cMTRANSIUpdateddate,
        this.categoryName});

  ReportListModelValues.fromJson(Map<String, dynamic> json) {
    type = json['$type'];
    cMMFIFoodItemName = json['CMMFI_FoodItemName'];
    cMTRANSQty = json['Total_Quantity'];
    totalAmount = json['Total_Amount'];
    cMTRANSIUpdateddate = json['Ordered_Date'];
    categoryName = json['Category_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['$type'] = type;
    data['CMMFI_FoodItemName'] = cMMFIFoodItemName;
    data['Total_Quantity'] = cMTRANSQty;
    data['Total_Amount'] = totalAmount;
    data['Ordered_Date'] = cMTRANSIUpdateddate;
    data['Category_Name'] = categoryName;
    return data;
  }
}
