import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/produk/indexproduk.dart';
import 'package:ukkurl_2025/produk/insertproduk.dart';
import 'package:ukkurl_2025/produk/updateproduk.dart';
import 'package:ukkurl_2025/homepage.dart';

class AddProduk extends StatefulWidget {
  AddProduk({super.key});

  @override
  State<AddProduk> createState() => _AddProdukState();
}

class _AddProdukState extends State<AddProduk> {
  // final _produkid = TextEditingController();
  final _namaproduk = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> langgan() async {
    if (_formKey.currentState!.validate()) {
      // final String produkid = _produkid.text;
      final String namaproduk = _namaproduk.text;
      final double harga = double.parse(_harga.text); // Konversi ke double
      final int stok = int.parse(_stok.text); // Konversi ke int

      try {
        final response = await Supabase.instance.client.from('Produk').insert({
          // 'produkid': produkid,
          'namaproduk': namaproduk,
          'harga': harga,
          'stok': stok,
        });

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal menambahkan produk: ${response.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produk berhasil ditambahkan')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Tambah Produk'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaproduk,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Produk wajib diisi';
                  } 
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _harga,
                decoration: InputDecoration(
                  labelText: 'harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'harga wajib diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                decoration: InputDecoration(
                  labelText: 'stok',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'stok wajib diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: langgan,
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}