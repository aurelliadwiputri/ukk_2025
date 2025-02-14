import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/produk/indexproduk.dart';
import 'package:ukkurl_2025/produk/insertproduk.dart';
import 'package:ukkurl_2025/produk/updateproduk.dart';
import 'package:ukkurl_2025/homepage.dart';

class EditProduk extends StatefulWidget {
  final int produkid;

  EditProduk({Key? key, required this.produkid}) : super(key: key);

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _namaproduk= TextEditingController();
  final _harga= TextEditingController();
  final _stok= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProdukData();
  }

  Future<void> _loadProdukData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await Supabase.instance.client
          .from('Produk')
          .select()
          .eq('produkid', widget.produkid)
          .single();

      if (data == null) {
        throw Exception('Data produk tidak ditemukan');
      }

      setState(() {
        _namaproduk.text = data['namaproduk'] ?? '';
         _harga.text = (data['harga'] ?? 0).toString();
        _stok.text = (data['stok'] ?? 0).toString();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data produk: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProduk() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await Supabase.instance.client.from('Produk').update({
          'namaproduk': _namaproduk.text,
           'harga': int.tryParse(_harga.text) ?? 0, // Konversi String ke int
          'stok': int.tryParse(_stok.text) ?? 0,
        }).eq('produkid', widget.produkid);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data produk berhasil diperbarui')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data produk: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Edit Produk'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _namaproduk,
                      decoration: InputDecoration(
                        labelText: 'nama produk',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'nama produk wajib diisi';
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
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'harga hanya boleh berisi angka';
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
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'stok hanya boleh berisi angka';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updateProduk,
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}