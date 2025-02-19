import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/penjualan/indexpenjualan.dart';

class AddPenjualan extends StatefulWidget {
  const AddPenjualan({super.key});

  @override
  _AddPenjualan createState() => _AddPenjualan();
}

class _AddPenjualan extends State<AddPenjualan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalpenjualanController =
      TextEditingController();
  final TextEditingController _totalhargaController = TextEditingController();
  final TextEditingController _pelangganidController = TextEditingController();

  Future<void> _addPenjualan() async {
    if (_formKey.currentState!.validate()) {
      final tanggalpenjualan = _tanggalpenjualanController.text;
      final totalharga = double.tryParse(_totalhargaController.text);
      final pelangganid = _pelangganidController.text;

      // Cek apakah Total Harga valid
      if (totalharga == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Total Harga harus berupa angka valid!')),
        );
        return;
      }

      try {
        // Insert data ke Supabase
        final response = await Supabase.instance.client.from('penjualan').insert([
          {
            'tanggalpenjualan': tanggalpenjualan,
            'totalharga': totalharga,
            'pelangganid': pelangganid,
          }
        ]);

        // Cek apakah response error null atau tidak
        if (response.error == null) {
          // Data berhasil ditambahkan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penjualan berhasil ditambahkan!')),
          );
          // Clear controller setelah data berhasil disimpan
          _tanggalpenjualanController.clear();
          _totalhargaController.clear();
          _pelangganidController.clear();

          // Pindah ke halaman PenjualanTab setelah berhasil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PenjualanTab()),
          );
        } else {
          // Jika ada error dari Supabase
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.error!.message}')),
          );
        }
      } catch (e) {
        // Tangani exception
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    } else {
      print("Form tidak valid");
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
        title: const Text('Tambah Penjualan'),
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
                  labelText: 'Tanggal Penjualan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Penjualan tidak boleh kosong';
                  }
                  return null; // valid
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalhargaController,
                decoration: const InputDecoration(
                  labelText: 'Total Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total Harga tidak boleh kosong';
                  }
                  // Cek apakah input valid sebagai angka
                  if (double.tryParse(value) == null) {
                    return 'Total Harga harus berupa angka';
                  }
                  return null; // valid
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pelangganidController,
                decoration: const InputDecoration(
                  labelText: 'Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pelanggan tidak boleh kosong';
                  }
                  return null; // valid
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addPenjualan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[200],
                ),
                child: const Text('Simpan', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
