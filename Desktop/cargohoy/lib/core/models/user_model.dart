import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { driver, company }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final bool is2FAEnabled;
  final bool isBiometricEnabled;
  final Map<String, dynamic>? location;
  final List<String>? documents;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.is2FAEnabled = false,
    this.isBiometricEnabled = false,
    this.location,
    this.documents,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role']}',
        orElse: () => UserRole.driver,
      ),
      is2FAEnabled: data['is2FAEnabled'] ?? false,
      isBiometricEnabled: data['isBiometricEnabled'] ?? false,
      location: data['location'],
      documents: List<String>.from(data['documents'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'is2FAEnabled': is2FAEnabled,
      'isBiometricEnabled': isBiometricEnabled,
      'location': location,
      'documents': documents,
    };
  }
} 