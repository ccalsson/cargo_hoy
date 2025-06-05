enum TwoFactorMethod {
  sms,
  email,
  authenticatorApp,
  biometric,
}

class TwoFactorAuthService {
  Future<bool> setupTwoFactor({
    required String userId,
    required TwoFactorMethod method,
  }) async {
    try {
      switch (method) {
        case TwoFactorMethod.authenticatorApp:
          return await _setupAuthenticatorApp(userId);
        case TwoFactorMethod.sms:
          return await _setupSmsVerification(userId);
        case TwoFactorMethod.email:
          return await _setupEmailVerification(userId);
        case TwoFactorMethod.biometric:
          return await _setupBiometric(userId);
      }
    } catch (e) {
      throw TwoFactorException('Error configurando 2FA: $e');
    }
  }

  Future<bool> _setupAuthenticatorApp(String userId) async {
    // Generar secreto único para el usuario
    final secret = await _generateSecretKey();
    
    // Generar QR code con la información
    final qrData = await _generateQRCode(
      secret: secret,
      userId: userId,
      issuer: 'CargoHoy',
    );

    // Guardar secreto encriptado
    await _saveEncryptedSecret(userId, secret);

    return true;
  }

  Future<bool> verifyCode({
    required String userId,
    required String code,
    required TwoFactorMethod method,
  }) async {
    try {
      switch (method) {
        case TwoFactorMethod.authenticatorApp:
          return await _verifyAuthenticatorCode(userId, code);
        case TwoFactorMethod.sms:
          return await _verifySmsCode(userId, code);
        case TwoFactorMethod.email:
          return await _verifyEmailCode(userId, code);
        case TwoFactorMethod.biometric:
          return await _verifyBiometric(userId);
      }
    } catch (e) {
      throw TwoFactorException('Error verificando código: $e');
    }
  }

  Future<Map<String, dynamic>> getBackupCodes(String userId) async {
    // Generar códigos de respaldo
    final codes = await _generateBackupCodes();
    
    // Guardar códigos hasheados
    await _saveBackupCodes(userId, codes);

    return {
      'codes': codes,
      'expirationDate': DateTime.now().add(const Duration(days: 90)),
    };
  }
} 