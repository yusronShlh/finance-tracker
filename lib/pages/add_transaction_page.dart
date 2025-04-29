import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lunari/utils/colors.dart';

class AddTransactionPage extends StatefulWidget {
  final String email;

  AddTransactionPage({required this.email});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _type = 'Pemasukan';

  void _submitTransaction() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;

    double amount =
        double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;

    await FirebaseFirestore.instance.collection('transactions').add({
      'email': widget.email,
      'title': _titleController.text,
      'amount': amount,
      'date': _selectedDate,
      'type': _type == 'Pemasukan' ? 'income' : 'expense',
    });

    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.decimalPattern('id');

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
              onChanged: (value) {
                String newValue = value.replaceAll('.', '');
                if (newValue.isEmpty) {
                  _amountController.text = '';
                  return;
                }
                _amountController.value = TextEditingValue(
                  text: currencyFormatter.format(int.parse(newValue)),
                  selection: TextSelection.collapsed(
                    offset:
                        currencyFormatter.format(int.parse(newValue)).length,
                  ),
                );
              },
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
                  ['Pemasukan', 'Pengeluaran'].map((String value) {
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
