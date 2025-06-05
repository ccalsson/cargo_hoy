class TrustScoreService {
  Future<double> calculateTrustScore({
    required String userId,
    required String userType,
  }) async {
    final scores = await Future.wait([
      _getDocumentationScore(userId),
      _getPerformanceScore(userId),
      _getFinancialScore(userId),
      _getInsuranceScore(userId),
      _getCommunityScore(userId),
    ]);

    // Ponderación de factores
    final weights = [0.3, 0.25, 0.2, 0.15, 0.1];
    return _weightedAverage(scores, weights);
  }

  Future<Map<String, dynamic>> getTrustMetrics(String userId) async {
    return {
      'documentationStatus': await _verifyDocuments(userId),
      'performanceMetrics': await _getPerformanceMetrics(userId),
      'financialHealth': await _getFinancialHealth(userId),
      'insuranceCoverage': await _getInsuranceCoverage(userId),
      'communityRating': await _getCommunityRating(userId),
      'verificationBadges': await _getVerificationBadges(userId),
    };
  }
} 