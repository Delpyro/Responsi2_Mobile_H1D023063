import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AddEditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product; 

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _entryDateController = TextEditingController();
  final _expiredDateController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name'];
      _priceController.text = widget.product!['price'].toString();
      _quantityController.text = widget.product!['quantity'].toString();
      _entryDateController.text = widget.product!['entry_date'];
      _expiredDateController.text = widget.product!['expired_date'];
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final body = jsonEncode({
      'name': _nameController.text,
      'price': _priceController.text, 
      'quantity': _quantityController.text,
      'entry_date': _entryDateController.text,
      'expired_date': _expiredDateController.text,
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      http.Response response;
      
      if (widget.product == null) {
        response = await http.post(
          Uri.parse(ApiConstants.products),
          headers: headers,
          body: body,
        );
      } else {
        final id = widget.product!['id'];
        response = await http.put(
          Uri.parse('${ApiConstants.products}/$id'),
          headers: headers,
          body: body,
        );
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan!")),
        );
        Navigator.pop(context, true); 
      } else {
        throw Exception('Gagal menyimpan: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Barang Nabil" : "Tambah Inventaris Nabil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Barang"),
                validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
              ),
              
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Harga (Rp)"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Harga wajib diisi" : null,
              ),
              
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: "Jumlah Stok"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Jumlah wajib diisi" : null,
              ),
              
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _entryDateController,
                decoration: const InputDecoration(
                  labelText: "Tanggal Masuk",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(_entryDateController),
                validator: (val) => val!.isEmpty ? "Tanggal masuk wajib diisi" : null,
              ),

              TextFormField(
                controller: _expiredDateController,
                decoration: const InputDecoration(
                  labelText: "Tanggal Kedaluwarsa",
                  suffixIcon: Icon(Icons.event_busy, color: Colors.red),
                ),
                readOnly: true,
                onTap: () => _selectDate(_expiredDateController),
                validator: (val) => val!.isEmpty ? "Tanggal kedaluwarsa wajib diisi" : null,
              ),

              const SizedBox(height: 24),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        isEdit ? "UPDATE DATA" : "SIMPAN DATA",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}