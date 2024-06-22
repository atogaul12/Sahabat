import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final Function(String) onNameChanged;

  const ProfileScreen({Key? key, required this.onNameChanged})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _nameController.text =
              data?['name'] ?? user.displayName ?? "Pengguna";
          _emailController.text = user.email ?? "email@contoh.com";
          _phoneController.text = data?['phone'] ?? "No Telepon";
          _addressController.text = data?['address'] ?? "Alamat";
        });
      }
    }
  }

  Future<void> _updateUserData(String field, String value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await docRef.update({field: value});
      if (field == 'name') {
        widget.onNameChanged(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userPhotoUrl = user != null && user.photoURL != null
        ? NetworkImage(user.photoURL!)
        : const AssetImage('assets/default_profile.png');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Text('Profil Saya'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Color.fromARGB(255, 34, 97, 206),
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userPhotoUrl as ImageProvider,
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditableField(
                        context,
                        label: 'Nama Pengguna',
                        controller: _nameController,
                        icon: Icons.person,
                        field: 'name',
                      ),
                      Divider(thickness: 1),
                      _buildEditableField(
                        context,
                        label: 'Email',
                        controller: _emailController,
                        icon: Icons.email,
                        field: 'email',
                      ),
                      Divider(thickness: 1),
                      _buildEditableField(
                        context,
                        label: 'No Telepon',
                        controller: _phoneController,
                        icon: Icons.phone,
                        field: 'phone',
                      ),
                      Divider(thickness: 1),
                      _buildEditableField(
                        context,
                        label: 'Alamat',
                        controller: _addressController,
                        icon: Icons.location_on,
                        field: 'address',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(BuildContext context,
      {required String label,
      required TextEditingController controller,
      required IconData icon,
      required String field}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color.fromARGB(255, 34, 97, 206)),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 34, 97, 206),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey),
              onPressed: () =>
                  _showEditDialog(context, label, controller, field),
            ),
          ],
        ),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Masukkan $label baru",
          ),
        ),
      ],
    );
  }

  Future<void> _showEditDialog(BuildContext context, String label,
      TextEditingController controller, String field) async {
    final TextEditingController tempController =
        TextEditingController(text: controller.text);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: tempController,
            decoration: InputDecoration(hintText: "Masukkan $label baru"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  controller.text = tempController.text;
                });
                _updateUserData(field, tempController.text);
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
