import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_air/ui/history_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('orders').doc(orderId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final orderDate = (orderData['orderDate'] as Timestamp).toDate();
          final quantity = orderData['quantity'];
          final totalPrice = orderData['totalPrice'];
          final status = orderData['status'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Detail Transaksi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 97, 206),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Text(
                      'Tanggal: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(DateFormat.yMMMMd().add_Hms().format(orderDate)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Order ID: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(orderId),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Jumlah: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$quantity galon'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Total Harga: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Rp $totalPrice'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(status),
                  ],
                ),
                SizedBox(height: 30),
                if (status == 'Belum Dibayar')
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/qrcode.png',
                            width: 200, height: 200),
                        SizedBox(height: 16),
                        Text(
                          'Silakan scan QR code untuk melakukan pembayaran.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                Spacer(),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 34, 97, 206),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
