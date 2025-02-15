import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/pelanggan/indexpelanggan.dart';
import 'package:ukkurl_2025/pelanggan/insertpelanggan.dart';
import 'package:ukkurl_2025/pelanggan/updatepelanggan.dart';
import 'package:ukkurl_2025/homepage.dart';

class EditPelanggan extends StatefulWidget {
  final int PelangganID;

  EditPelanggan({Key? key, required this.PelangganID}) : super(key: key);

  @override
  State<EditPelanggan> createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPelanggan> {
  final _namapelanggan = TextEditingController();
  final _alamat = TextEditingController();
  final _nomertelepon= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPelangganData();
  }

  Future<void> _loadPelangganData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await Supabase.instance.client
          .from('pelanggan')
          .select()
          .eq('pelangganID', widget.PelangganID)
          .single();

      if (data == null) {
        throw Exception('Data pelanggan tidak ditemukan');
      }

      setState(() {
        _namapelanggan.text = data['namapelanggan'] ?? '';
        _alamat.text = data['alamat'] ?? '';
        _nomertelepon.text = data['nomertelepon'] ?? '';
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

  Future<void> updatePelanggan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await Supabase.instance.client.from('pelanggan').update({
          'namapelanggan': _namapelanggan.text,
          'alamat': _alamat.text,
          'nomertelepon': _nomertelepon.text,
        }).eq('pelangganID', widget.PelangganID);

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
        title: Text('Edit Pelanggan'),
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
                        labelText: 'Nama Pelanggan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _alamat,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nomertelepon,
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor Telepon wajib diisi';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Nomor Telepon hanya boleh berisi angka';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updatePelanggan,
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}