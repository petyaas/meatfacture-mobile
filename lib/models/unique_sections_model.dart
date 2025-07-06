import 'dart:convert';

class UniqueReceipts {
  List<Datum> data;
  Meta meta;

  UniqueReceipts({
    this.data,
    this.meta,
  });

  factory UniqueReceipts.fromJson(String str) =>
      UniqueReceipts.fromMap(json.decode(str));

  factory UniqueReceipts.fromMap(Map<String, dynamic> json) =>
      UniqueReceipts(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
        meta: Meta.fromMap(json["meta"]),
      );
}

class Datum {
  String section;

  Datum({
    this.section,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  factory Datum.fromMap(Map<String, dynamic> json) =>
      Datum(
        section: json["section"],
      );
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  int perPage;
  int to;
  int total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));


  factory Meta.fromMap(Map<String, dynamic> json) =>
      Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );
}
