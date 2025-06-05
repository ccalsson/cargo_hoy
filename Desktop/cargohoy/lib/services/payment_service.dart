import 'package:stripe_payment/stripe_payment.dart';

class PaymentService {
  Future<void> initializePayment() async {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "tu_stripe_key",
        merchantId: "tu_merchant_id",
        androidPayMode: 'test'
      )
    );
  }

  Future<PaymentMethod> addPaymentMethod() async {
    PaymentMethod paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest()
    );
    return paymentMethod;
  }

  Future<void> processPayment(String paymentMethodId, double amount) async {
    // Implementar proceso de pago
  }
} 