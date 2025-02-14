import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/homepage.dart';

class Addpelanggan extends StatefulWidget {
  Addpelanggan({super.key});

  @override
  State<Addpelanggan> createState() => _AddpelangganState();
}

class _AddpelangganState extends State<Addpelanggan> {
  // final _pelangganid = TextEditingController();
  final _namapelanggan = TextEditingController();
  final _alamat = TextEditingController();
  final _nomortelepon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> langgan() async {
    if (_formKey.currentState!.validate()) {
      // final String pelangganid = _pelangganid.text;
      final String namapelanggan = _namapelanggan.text;
      final double alamat = double.parse(_alamat.text); // Konversi ke double
      final int nomortelepon = int.parse(_nomortelepon.text); // Konversi ke int

      try {
        final response = await Supabase.instance.client.from('pelanggan').insert({
          // 'pelangganid': pelangganid,
          'namapelanggan': namapelanggan,
          'alamat': alamat,
          'nomortelepon': nomortelepon,
        });

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal menambahkan pelanggan: ${response.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('pelanggan berhasil ditambahkan')),
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
        title: Text('Tambah pelanggan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namapelanggan,
                decoration: InputDecoration(
                  labelText: 'Nama pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'nama pelanggan wajib diisi';
                  } 
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _alamat,
                decoration: InputDecoration(
                  labelText: 'alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'alamat wajib diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nomortelepon,
                decoration: InputDecoration(
                  labelText: 'nomortelepon',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'nomortelepon wajib diisi';
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