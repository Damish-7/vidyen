// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? username;
  final String? avatar;
  final String? designation;
  final String? institution;
 
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.avatar,
    this.designation,
    this.institution,
  });
 
   factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      avatar: json['avatar'],
      designation: json['designation'],
      institution: json['institution'],
    );
  }
  

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'avatar': avatar,
      'designation': designation,
      'institution': institution,
    };
  }


  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
 