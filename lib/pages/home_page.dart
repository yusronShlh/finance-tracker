import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:lunari/pages/add_transaction_page.dart';
import 'package:lunari/utils/colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final String email;

  HomePage({required this.email});

  @override
  Widget build(BuildContext context) {
    final transactionsStream =
        FirebaseFirestore.instance
            .collection('transactions')
            .where('email', isEqualTo: email)
            .snapshots();

    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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

          List<Map<String, dynamic>> transactionList =
              transactions.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final date =
                    (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
                return {
                  'id': doc.id,
                  'title': data['title'] ?? '',
                  'amount': (data['amount'] ?? 0).toDouble(),
                  'type': data['type'] ?? 'income',
                  'date': date,
                };
              }).toList();

          double totalIncome = 0;
          double totalExpense = 0;

          for (var t in transactionList) {
            if (t['type'] == 'income') {
              totalIncome += t['amount'];
            } else {
              totalExpense += t['amount'];
            }
          }

          double totalBalance = totalIncome - totalExpense;

          return Stack(
            children: [
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
                    // Greeting
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
                        IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.bottomSlide,
                              title: 'Konfirmasi Logout',
                              desc:
                                  'Apakah kamu yakin ingin keluar dari akun ini?',
                              btnCancelText: "Batal",
                              btnCancelOnPress: () {},
                              btnOkText: "Logout",
                              btnOkOnPress: () async {
                                await FirebaseAuth.instance.signOut();
                              },
                            ).show();
                          },
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
                            'Total saldo',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[300],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            currencyFormat.format(totalBalance),
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
                                  currencyFormat.format(totalIncome),
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
                                  currencyFormat.format(totalExpense),
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

                    // Transaction History
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
                          transactionList.isEmpty
                              ? Center(child: Text('Belum ada transaksi.'))
                              : GroupedListView<Map<String, dynamic>, String>(
                                elements: transactionList,
                                groupBy:
                                    (element) => DateFormat(
                                      'MMMM yyyy',
                                      'id_ID',
                                    ).format(element['date']),
                                groupSeparatorBuilder:
                                    (String groupByValue) => Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      width: double.infinity,
                                      child: Text(
                                        groupByValue,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                itemBuilder: (context, element) {
                                  return ListTile(
                                    leading: Icon(
                                      element['type'] == 'income'
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color:
                                          element['type'] == 'income'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    title: Text(element['title']),
                                    subtitle: Text(
                                      DateFormat(
                                        'dd MMM yyyy',
                                        'id_ID',
                                      ).format(element['date']),
                                    ),
                                    trailing: Text(
                                      '${element['type'] == 'income' ? '+' : '-'}${currencyFormat.format(element['amount'])}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            element['type'] == 'income'
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  );
                                },
                                order: GroupedListOrder.DESC,
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
