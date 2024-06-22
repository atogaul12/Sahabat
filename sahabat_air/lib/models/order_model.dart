class OrderModel {
  final String orderId;
  final String userId;
  final int quantity;
  final double totalPrice;
  final String status;
  final DateTime orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  static OrderModel fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      userId: map['userId'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      status: map['status'],
      orderDate: DateTime.parse(map['orderDate']),
    );
  }
}
