class TwoFactorVerifyScreen extends StatefulWidget {
  final String userId;
  final TwoFactorMethod method;

  const TwoFactorVerifyScreen({
    required this.userId,
    required this.method,
    Key? key,
  }) : super(key: key);

  @override
  _TwoFactorVerifyScreenState createState() => _TwoFactorVerifyScreenState();
}

class _TwoFactorVerifyScreenState extends State<TwoFactorVerifyScreen> {
  final _codeController = TextEditingController();
  bool isLoading = false;
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verificación de Dos Factores')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingresa el código de verificación',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            _buildVerificationInput(),
            SizedBox(height: 24),
            _buildVerifyButton(),
            TextButton(
              onPressed: _showBackupCodeDialog,
              child: Text('Usar código de respaldo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationInput() {
    switch (widget.method) {
      case TwoFactorMethod.authenticatorApp:
      case TwoFactorMethod.sms:
      case TwoFactorMethod.email:
        return PinCodeTextField(
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
          ),
          animationDuration: const Duration(milliseconds: 300),
          controller: _codeController,
          onCompleted: (v) {
            _verifyCode();
          },
          onChanged: (value) {
            // Manejar cambios
          },
          beforeTextPaste: (text) {
            return true;
          },
        );
      case TwoFactorMethod.biometric:
        return BiometricPrompt(
          onVerified: () {
            _verifyBiometric();
          },
        );
    }
  }

  Future<void> _verifyCode() async {
    setState(() => isLoading = true);
    try {
      final isValid = await TwoFactorAuthService().verifyCode(
        userId: widget.userId,
        code: _codeController.text,
        method: widget.method,
      );

      if (isValid) {
        setState(() => isVerified = true);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Código inválido')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }
} 