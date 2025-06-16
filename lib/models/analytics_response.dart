class AnalyticsResponse {
  int? statusCode;
  String? status;
  String? message;
  Data? data;
  Null error;

  AnalyticsResponse({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.error,
  });

  AnalyticsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = error;
    return data;
  }
}

class Data {
  List<AnalyticsList>? analyticsList;

  Data({this.analyticsList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['analytics_list'] != null) {
      analyticsList = <AnalyticsList>[];
      json['analytics_list'].forEach((v) {
        analyticsList!.add(AnalyticsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (analyticsList != null) {
      data['analytics_list'] = analyticsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnalyticsList {
  String? hashId;
  String? analyticName;

  AnalyticsList({this.hashId, this.analyticName});

  AnalyticsList.fromJson(Map<String, dynamic> json) {
    hashId = json['hash_id'];
    analyticName = json['analytic_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hash_id'] = hashId;
    data['analytic_name'] = analyticName;
    return data;
  }
}
