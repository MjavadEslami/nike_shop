class CreateOrderResult {
  final int orderId;
  final String bankGateWayUrl;

  CreateOrderResult(this.orderId, this.bankGateWayUrl);
  CreateOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGateWayUrl = json['bank_gateway_url'];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String postalCode;
  final String phoneNumber;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams(
    this.firstName,
    this.lastName,
    this.postalCode,
    this.phoneNumber,
    this.address,
    this.paymentMethod,
  );
}

enum PaymentMethod { online, cashOnDelivery }
