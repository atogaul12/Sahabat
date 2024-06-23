import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<bool> isProfileComplete() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      return data != null &&
          data['name'] != null &&
          data['address'] != null &&
          data['phone'] != null;
    }
    return false;
  }

  Future<void> saveUserProfile(
      String name, String address, String phone) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'address': address,
        'phone': phone,
      });
    }
  }
}
