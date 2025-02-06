class PaymentModel {
  final String? paymentID;
  final String? orderID;
  final String? signature;

  const PaymentModel({this.orderID, this.paymentID, this.signature});

  factory PaymentModel.fromJson(Map<dynamic, dynamic> json) {
    return PaymentModel(
      paymentID: json['razorpay_payment_id'],
      signature: json['razorpay_signature'],
      orderID: json['razorpay_order_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "razorpay_payment_id": paymentID,
      "razorpay_signature": signature,
      "razorpay_order_id": orderID,
    };
  }
}
