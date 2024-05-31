import 'package:flutter/material.dart';
import '../repositories/user_repo.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final subscriptionNumberController = TextEditingController();
  final _userRepo = UserRepo();

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    subscriptionNumberController.dispose();
    super.dispose();
  }

  void _submitData() async {
    await _userRepo.saveUserProfile(
      fullNameController.text,
      addressController.text,
      subscriptionNumberController.text,
    );
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: subscriptionNumberController,
              decoration: InputDecoration(labelText: 'Nomor Langganan PDAM'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
