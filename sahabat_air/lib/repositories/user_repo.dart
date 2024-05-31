import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<bool> isProfileComplete() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.exists && doc.data()!.containsKey('fullName') && doc.data()!.containsKey('address') && doc.data()!.containsKey('subscriptionNumber');
    }
    return false;
  }

  Future<void> saveUserProfile(String fullName, String address, String subscriptionNumber) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'address': address,
        'subscriptionNumber': subscriptionNumber,
      });
    }
  }
}
