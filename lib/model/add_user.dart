class AddUserModel {
  String? name;
  String? email;
  String? password;
  String? phoneNumber;
  String? location;
  String? vehicle;
  String? color;
  String? doc;

  AddUserModel({
    this.email,
    this.name,
    this.password,
    this.phoneNumber,
    this.location,
    this.vehicle,
    this.color,
    this.doc,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "password": password,
      "phoneNumber": phoneNumber,
      "location": location,
      "vehicle": vehicle,
      "color": color,
      "doc": doc,

    };
  }
  factory AddUserModel.fromJson(Map<String, dynamic> json) {
    return AddUserModel(
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      password: json["password"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      location: json["location"] ?? "",
      vehicle: json["vehicle"] ?? "",
      color: json["color"] ?? "",
      doc: json["doc"] ?? "",

    );
  }
}