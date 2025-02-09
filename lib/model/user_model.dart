class UserModel {

  String? id;
  String? name;
  String? email;
  int? createAt;

  UserModel({required this.id,required this.name,required this.email,required this.createAt});

  UserModel.fromJson(Map<String,dynamic> json) : this(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    createAt: json["createAt"],
  );

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "name": name,
      "email": email,
      "createAt": createAt,
    };
}

}