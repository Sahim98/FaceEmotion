// To parse this JSON data, do
//
//     final imgbbResponseModel = imgbbResponseModelFromJson(jsonString);

import 'dart:convert';

ImgbbResponseModel imgbbResponseModelFromJson(String str) => ImgbbResponseModel.fromJson(json.decode(str));

String imgbbResponseModelToJson(ImgbbResponseModel data) => json.encode(data.toJson());

class ImgbbResponseModel {
  ImgbbResponseModel({
    required this.data,
    required this.success,
    required this.status,
  });

  Data data;
  bool success;
  int status;

  factory ImgbbResponseModel.fromJson(Map<String, dynamic> json) => ImgbbResponseModel(
    data: Data.fromJson(json["data"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "success": success,
    "status": status,
  };
}

class Data {
  Data({
    required this.displayUrl,
    required this.deleteUrl,
  });

  String displayUrl;
  String deleteUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    displayUrl: json["display_url"],
    deleteUrl: json["delete_url"],
  );

  Map<String, dynamic> toJson() => {
    "display_url": displayUrl,
    "delete_url": deleteUrl,
  };
}