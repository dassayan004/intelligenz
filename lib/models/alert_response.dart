class AlertResponse {
  String? status;
  List<AlertData>? data;
  int? count;
  int? totalPages;

  AlertResponse({this.status, this.data, this.count, this.totalPages});

  AlertResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AlertData>[];
      json['data'].forEach((v) {
        data!.add(AlertData.fromJson(v));
      });
    }
    count = json['count'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['totalPages'] = totalPages;
    return data;
  }
}

class AlertData {
  String? zoneName;
  int? cameraId;
  String? cameraName;
  Null junctionName;
  String? sId;
  String? hashId;
  String? analyticType;
  int? analyticId;
  int? isVs;
  String? metaData;
  String? zoneId;
  String? timestamp;
  List<String>? thumbUrl;
  List<String>? imageUrl;
  String? confidence;
  String? ocr;
  int? iV;

  AlertData({
    this.zoneName,
    this.cameraId,
    this.cameraName,
    this.junctionName,
    this.sId,
    this.hashId,
    this.analyticType,
    this.analyticId,
    this.isVs,
    this.metaData,
    this.zoneId,
    this.timestamp,
    this.thumbUrl,
    this.imageUrl,
    this.confidence,
    this.ocr,
    this.iV,
  });

  AlertData.fromJson(Map<String, dynamic> json) {
    zoneName = json['zone_name'];
    cameraId = json['camera_id'];
    cameraName = json['camera_name'];
    junctionName = json['junction_name'];
    sId = json['_id'];
    hashId = json['hash_id'];
    analyticType = json['analytic_type'];
    analyticId = json['analytic_id'];
    isVs = json['is_vs'];
    metaData = json['metaData'];
    zoneId = json['zone_id'];
    timestamp = json['timestamp'];
    thumbUrl = json['thumb_url'].cast<String>();
    imageUrl = json['image_url'].cast<String>();
    confidence = json['confidence'];
    ocr = json['ocr'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone_name'] = zoneName;
    data['camera_id'] = cameraId;
    data['camera_name'] = cameraName;
    data['junction_name'] = junctionName;
    data['_id'] = sId;
    data['hash_id'] = hashId;
    data['analytic_type'] = analyticType;
    data['analytic_id'] = analyticId;
    data['is_vs'] = isVs;
    data['metaData'] = metaData;
    data['zone_id'] = zoneId;
    data['timestamp'] = timestamp;
    data['thumb_url'] = thumbUrl;
    data['image_url'] = imageUrl;
    data['confidence'] = confidence;
    data['ocr'] = ocr;
    data['__v'] = iV;
    return data;
  }
}
