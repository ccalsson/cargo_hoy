class TwoFactorSetupScreen extends StatefulWidget {
  final String userId;
  final TwoFactorMethod method;

  const TwoFactorSetupScreen({
    required this.userId,
    required this.method,
    Key? key,
  }) : super(key: key);

  @override
  _TwoFactorSetupScreenState createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  late final TwoFactorAuthService _twoFactorService;
  bool isLoading = false;
  String? qrData;
  List<String>? backupCodes;

  @override
  void initState() {
    super.initState();
    _twoFactorService = TwoFactorAuthService();
    _initSetup();
  }

  Future<void> _initSetup() async {
    setState(() => isLoading = true);
    try {
      await _twoFactorService.setupTwoFactor(
        userId: widget.userId,
        method: widget.method,
      );
      
      // Obtener códigos de respaldo
      final backupData = await _twoFactorService.getBackupCodes(widget.userId);
      setState(() {
        backupCodes = backupData['codes'];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar Autenticación de Dos Factores'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMethodSpecificInstructions(),
                  if (qrData != null) _buildQRCode(),
                  _buildVerificationForm(),
                  if (backupCodes != null) _buildBackupCodes(),
                ],
              ),
            ),
    );
  }

  Widget _buildMethodSpecificInstructions() {
    switch (widget.method) {
      case TwoFactorMethod.authenticatorApp:
        return _buildAuthenticatorInstructions();
      case TwoFactorMethod.sms:
        return _buildSMSInstructions();
      case TwoFactorMethod.email:
        return _buildEmailInstructions();
      case TwoFactorMethod.biometric:
        return _buildBiometricInstructions();
    }
  }

  Widget _buildBackupCodes() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Códigos de Respaldo',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Guarda estos códigos en un lugar seguro. Los necesitarás si pierdes acceso a tu método principal de autenticación.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: backupCodes!.map((code) {
                return Chip(
                  label: Text(code),
                  backgroundColor: Colors.grey[200],
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _downloadBackupCodes,
              icon: Icon(Icons.download),
              label: Text('Descargar Códigos'),
            ),
          ],
        ),
      ),
    );
  }
} 