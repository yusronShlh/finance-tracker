import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunari/pages/add_transaction_page.dart';
import 'package:lunari/utils/colors.dart';

class HomePage extends StatelessWidget {
  final String email;

  HomePage({required this.email});

  @override
  Widget build(BuildContext context) {
    // Ambil transaksi user berdasarkan email
    final transactionsStream =
        FirebaseFirestore.instance
            .collection('transactions')
            .where('email', isEqualTo: email)
            .snapshots();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionPage(email: email),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: transactionsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.teal),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final transactions = snapshot.data?.docs ?? [];

          double totalIncome = 0;
          double totalExpense = 0;

          for (var doc in transactions) {
            final data = doc.data() as Map<String, dynamic>;
            final amount = (data['amount'] ?? 0).toDouble();
            final type = data['type'] ?? 'income';

            if (type == 'income') {
              totalIncome += amount;
            } else if (type == 'expense') {
              totalExpense += amount;
            }
          }

          double totalBalance = totalIncome - totalExpense;

          return Stack(
            children: [
              // Background melengkung
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
                    // Sapaan
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

                    // Total Balance
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[300],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Rp ${totalBalance.toStringAsFixed(0)}',
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

                    // Income & Expense
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
                                  'Rp ${totalIncome.toStringAsFixed(0)}',
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
                                  'Rp ${totalExpense.toStringAsFixed(0)}',
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

                    Text(
                      'Riwayat Transaksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),

                    Expanded(
                      child:
                          transactions.isEmpty
                              ? Center(child: Text('Belum ada transaksi.'))
                              : ListView.builder(
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      transactions[index].data()
                                          as Map<String, dynamic>;
                                  final title = data['title'] ?? '';
                                  final amount =
                                      (data['amount'] ?? 0).toDouble();
                                  final date =
                                      (data['date'] as Timestamp?)?.toDate();
                                  final type = data['type'] ?? 'income';

                                  return ListTile(
                                    leading: Icon(
                                      type == 'income'
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color:
                                          type == 'income'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    title: Text(title),
                                    subtitle: Text(
                                      date != null
                                          ? '${date.day}/${date.month}/${date.year}'
                                          : 'Tanggal tidak tersedia',
                                    ),
                                    trailing: Text(
                                      '${type == 'income' ? '+' : '-'}Rp ${amount.toStringAsFixed(0)}',
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
