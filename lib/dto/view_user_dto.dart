import 'dart:convert';

class ViewUserDTO {
  ViewUserDTO({
    required this.id,
    required this.login,
    required this.email,
  });

  int id;
  String login;
  String email;

  factory ViewUserDTO.fromJson(String str) =>
      ViewUserDTO.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewUserDTO.fromMap(Map<String, dynamic> json) => ViewUserDTO(
        id: json["id"],
        login: json["login"],
        email: json["email"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "login": login,
        "email": email,
      };
}
