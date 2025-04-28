import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lunari/utils/colors.dart';

class AddTransactionPage extends StatefulWidget {
  final String email; // <<< Tambahkan ini

  AddTransactionPage({required this.email}); // <<< Tambahkan ini

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _type = 'Pemasukan';

  void _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitTransaction() async {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      _showError("Semua field wajib diisi!");
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError("Jumlah harus berupa angka positif!");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('transactions').add({
        'email': widget.email, // <<< Gunakan widget.email
        'title': title,
        'amount': amount,
        'type': _type == 'Pemasukan' ? 'income' : 'expense',
        'date': Timestamp.fromDate(_selectedDate),
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil',
        desc: 'Transaksi berhasil disimpan!',
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    } catch (e) {
      print('Error saat menyimpan transaksi: $e');
      _showError("Terjadi kesalahan saat menyimpan data.");
    }
  }

  void _showError(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        title: Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Keterangan'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tanggal: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text('Pilih Tanggal'),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _type,
              items:
                  <String>[
                    'Pemasukan',
                    'Pengeluaran',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _type = newValue!;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
