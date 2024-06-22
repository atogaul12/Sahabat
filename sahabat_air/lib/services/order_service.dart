import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('orders');

  Future<void> createOrder(OrderModel order) async {
    return await orderCollection.doc(order.orderId).set(order.toMap());
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    QuerySnapshot querySnapshot =
        await orderCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
