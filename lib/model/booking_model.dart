class BookingModel {
  String? serviceType;
  String? name;
  String? phone;
  String? doc;
  String? location;
  String? dateShow;
  String? time;
  String? modelNumber;
  String? color;
  double? lat;
  double? long;
  List<String>? services;

  BookingModel({
    this.name,
    this.serviceType,
    this.phone,
    this.doc,
    this.location,
    this.dateShow,
    this.time,
    this.modelNumber,
    this.color,
    this.services,
    this.lat,
    this.long,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "serviceType": serviceType,
      "doc": doc,
      "location": location,
      "time": time,
      "dateShow": dateShow,
      "color": color,
      "modelNumber": modelNumber,
      "services": services,
      "lat": lat,
      "long": long,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      serviceType: json["serviceType"] ?? "",
      doc: json["doc"] ?? "",
      location: json["location"] ?? "",
      time: json["time"] ?? "",
      dateShow: json["dateShow"] ?? "",
      modelNumber: json["modelNumber"] ?? "",
      color: json["color"] ?? "",
      lat: json["lat"] ?? 0.0,
      long: json["long"] ?? 0.0,
      services: json["services"].cast<String>(),
    );
  }
}
