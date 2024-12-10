class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final int phoneNumber;
  final DateTime dateBirth;
  final String email;
  final String gender;
  final String description;
  final String? profilePicture;
  final String? idFace;
  final String? idBack;
  final String userName;
  final String password;
  final List<String> interests;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dateBirth,
    required this.email,
    required this.gender,
    required this.description,
    this.profilePicture,
    this.idFace,
    this.idBack,
    required this.userName,
    required this.password,
    required this.interests,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? 'Unknown',
      phoneNumber: json['phoneNumber'] ?? 0,
      dateBirth: DateTime.parse(json['dateBirth'] ?? '2000-01-01'),
      gender: json['gender'] ?? 'Unspecified',
      description: json['description'] ?? '',
      profilePicture: json['profilePicture'],
      idFace: json['idFace'],
      idBack: json['idBack'],
      userName: json['account']['username'] ?? 'guest_user',
      email: json['account']['email'] ?? 'Unknown',
      password: json['account']['password'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  // Method to convert UserModel to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'dateBirth': dateBirth.toIso8601String(),
      'gender': gender,
      'description': description,
      'profilePicture': profilePicture,
      'idFace': idFace,
      'idBack': idBack,
      'account': {
        'username': userName,
        'email': email,
        'password': password,
      },
      'interests': interests,
    };
  }
}