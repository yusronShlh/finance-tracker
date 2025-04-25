import 'package:flutter/material.dart';
import 'package:lunari/pages/add_transaction_page.dart';
import 'package:lunari/utils/colors.dart';

class HomePage extends StatelessWidget {
  final String email;

  HomePage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background melengkung setengah teal
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 50.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sapaan dan icon notifikasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Halo, $email',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Total Balance Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp 12.500.000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5),

                // Kotak uang masuk dan keluar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.Green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pemasukan',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Rp 8.000.000',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pengeluaran',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Rp 3.500.000',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // History transaksi
                Text(
                  'Riwayat Transaksi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.arrow_downward,
                          color: Colors.green,
                        ),
                        title: Text('Gaji Bulanan'),
                        subtitle: Text('01 April 2025'),
                        trailing: Text('+Rp 6.000.000'),
                      ),
                      ListTile(
                        leading: Icon(Icons.arrow_upward, color: Colors.red),
                        title: Text('Belanja'),
                        subtitle: Text('03 April 2025'),
                        trailing: Text('-Rp 1.000.000'),
                      ),
                      // Tambah transaksi lainnya di sini
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
