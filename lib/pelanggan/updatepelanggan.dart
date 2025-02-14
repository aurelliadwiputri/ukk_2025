import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/homepage.dart';

class Editpelanggan extends StatefulWidget {
  final int pelangganid;

  Editpelanggan({Key? key, required this.pelangganid}) : super(key: key);

  @override
  State<Editpelanggan> createState() => _EditpelangganState();
}

class _EditpelangganState extends State<Editpelanggan> {
  final _namapelanggan= TextEditingController();
  final _alamat= TextEditingController();
  final _nomortelepon= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadpelangganData();
  }

  Future<void> _loadpelangganData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await Supabase.instance.client
          .from('pelanggan')
          .select()
          .eq('pelangganid', widget.pelangganid)
          .single();

      if (data == null) {
        throw Exception('Data pelanggan tidak ditemukan');
      }

      setState(() {
        _namapelanggan.text = data['namapelanggan'] ?? '';
         _alamat.text = (data['alamat'] ?? 0).toString();
        _nomortelepon.text = (data['nomortelepon'] ?? 0).toString();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data pelanggan: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatepelanggan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await Supabase.instance.client.from('pelanggan').update({
          'namapelanggan': _namapelanggan.text,
           'alamat': int.tryParse(_alamat.text) ?? 0, // Konversi String ke int
          'nomortelepon': int.tryParse(_nomortelepon.text) ?? 0,
        }).eq('pelangganid', widget.pelangganid);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data pelanggan berhasil diperbarui')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data pelanggan: $e')),
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
        title: Text('Edit pelanggan'),
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
                      controller: _namapelanggan,
                      decoration: InputDecoration(
                        labelText: 'nama pelanggan',
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
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'alamat hanya boleh berisi angka';
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
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'nomortelepon hanya boleh berisi angka';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updatepelanggan,
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}