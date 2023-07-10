class AddEmployee {
  final String? image;
  final String? id;
  final String? name;
  final String? about;
  final String? jobTitle;
  final double? latitude;
  final double? longitude;

  const AddEmployee({
    this.image,
    this.id,
    this.name,
    this.about,
    this.jobTitle,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson(){
    return {
      "image":image,
      "id":id,
      "name":name,
      "about":about,
      "jobTitle":jobTitle,
      "latitude":latitude,
      "longitude":longitude,
    };
  }

  factory AddEmployee.fromJson(Map<String,dynamic> json){
    return AddEmployee(
      id: json["id"],
      image: json["image"],
      name: json["name"],
      about: json["about"],
      jobTitle: json["jobTitle"],
      latitude: json["latitude"],
      longitude: json["longitude"]

    );
  }


}
