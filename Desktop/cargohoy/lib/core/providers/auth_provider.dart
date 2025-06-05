import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _is2FAEnabled = false;
  bool _isBiometricEnabled = false;
  String? _userId;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get is2FAEnabled => _is2FAEnabled;
  bool get isBiometricEnabled => _isBiometricEnabled;
  String? get userId => _userId;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Crear usuario en Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear documento de usuario en Firestore
      final userModel = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        role: role,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      _currentUser = userModel;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener datos del usuario desde Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      _currentUser = UserModel.fromFirestore(userDoc);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      if (!canAuthenticateWithBiometrics) return false;

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Por favor autentícate para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      _isAuthenticated = didAuthenticate;
      _userId = 'temp_user_id';
      notifyListeners();
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verify2FA(String code) async {
    // Implementar lógica de verificación 2FA
    // Por ahora, simulamos una verificación exitosa
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<void> enable2FA() async {
    _is2FAEnabled = true;
    notifyListeners();
  }

  Future<void> enableBiometrics() async {
    _isBiometricEnabled = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
} 