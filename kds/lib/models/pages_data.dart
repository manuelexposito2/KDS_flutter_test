import 'dart:convert';

import 'package:kds/models/last_orders_response.dart';

PagesData pagesDataFromJson(String str) => PagesData.fromJson(json.decode(str));

String pagesDataToJson(PagesData data) => json.encode(data.toJson());

class PagesData {
  int currentPage;
  List<LastOrdersResponse> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;

  PagesData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
  });

  factory PagesData.fromJson(Map<String, dynamic> json) => PagesData(
    currentPage: json["current_page"],
    data: List<LastOrdersResponse>.from(json["data"].map((x) => LastOrdersResponse.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
  };
}