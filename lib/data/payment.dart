class PaymentData {
  final bool purchaseSuccess;
  final int payablePrice;
  final String paymentStatus;

  PaymentData(this.purchaseSuccess, this.payablePrice, this.paymentStatus);

  PaymentData.formJson(Map<String, dynamic> json)
      : payablePrice = json['payable_price'],
        purchaseSuccess = json['purchase_success'],
        paymentStatus = json['payment_status'];
}
