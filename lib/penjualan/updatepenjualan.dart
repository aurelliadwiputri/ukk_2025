import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Updatepenjualan extends StatefulWidget {
  final int id; // ID pelanggan untuk diupdate
  final String tanggalpenjualan;
  final String totalharga;
  final String pelangganid;

  const Updatepenjualan({
    super.key,
    required this.id,
    required this.tanggalpenjualan,
    required this.totalharga,
    required this.pelangganid,
  });

  @override
  _UpdatepenjualanState createState() => _UpdatepenjualanState();
}

class _UpdatepenjualanState extends State<Updatepenjualan> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tanggalpenjualanController;
  late TextEditingController _totalhargaController;
  late TextEditingController _pelangganidController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal
    _tanggalpenjualanController =
        TextEditingController(text: widget.tanggalpenjualan);
    _totalhargaController = TextEditingController(text: widget.totalharga);
    _pelangganidController = TextEditingController(text: widget.pelangganid);
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      final tanggalpenjualan = _tanggalpenjualanController.text;
      final totalharga = _totalhargaController.text;
      final pelangganid = _pelangganidController.text;

      try {
        // Kirim data update ke Supabase
        final response =
            await Supabase.instance.client.from('Penjualan').update({
          'tanggalpenjualan': 'tanggalpenjualan',
          'totalharga': totalharga,
          'pelangganid': pelangganid,
        }).eq('id', widget.id);

        if (response != null && response.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penjualan berhasil diperbarui!')),
          );
          Navigator.pop(context, true); // Kembali ke halaman utama
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal memperbarui penjualan: ${response.error?.message}')),
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
  void dispose() {
    _tanggalpenjualanController.dispose();
    _totalhargaController.dispose();
    _pelangganidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbarui Penjualan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tanggalpenjualanController,
                decoration: const InputDecoration(
                  labelText: 'tanggalpenjualan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'tanggalpenjualan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalhargaController,
                decoration: const InputDecoration(
                  labelText: 'totalharga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'totalharga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pelangganidController,
                decoration: const InputDecoration(
                  labelText: 'pelangganid',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'pelangganid tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[200],
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
