import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://iwpixeuosumshiesrlet.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3cGl4ZXVvc3Vtc2hpZXNybGV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY5OTMwNjQsImV4cCI6MjA1MjU2OTA2NH0.GkKqrZjS3cxKCZlYAaVTVMpXu510OgZQx8IkaiIXwzE',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PenjualanBookListPage(),
    );
  }
}

class PenjualanBookListPage extends StatefulWidget {
  const PenjualanBookListPage({Key? key}) : super(key: key);

  @override
  _PenjualanBookListPageState createState() => _PenjualanBookListPageState();
}

class _PenjualanBookListPageState extends State<PenjualanBookListPage> {
  List<Map<String, dynamic>> penjualan = [];

  @override
  void initState() {
    super.initState();
    fetchpenjualan();
  }

  Future<void> fetchpenjualan() async {
    try {
      final response =
          await Supabase.instance.client.from('Penjualan').select();
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching penjualan: $e');
    }
  }

  Future<void> deletePenjualan(int id) async {
    try {
      await Supabase.instance.client
          .from('penjualan')
          .delete()
          .eq('penjualanid', id);
      fetchpenjualan();
    } catch (e) {
      print('Error deleting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: penjualan.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: penjualan.length,
              itemBuilder: (context, index) {
                final item = penjualan[index];
                return ListTile(
                  title: Text(item['tanggalpejualan'] ??
                      'tanggalpenjualan tidak tersedia'),
                  subtitle: Text('totalharga: ${item['totalharga']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPenjualanPage(
                                  penjualanId: item['penjualanid']),
                            ),
                          ).then((value) {
                            if (value == true) fetchpenjualan();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deletePenjualan(item['penjualanid']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPenjualanPage()),
          );
          if (result == true) {
            fetchpenjualan();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddPenjualanPage extends StatefulWidget {
  final int? penjualanId;
  const AddPenjualanPage({Key? key, this.penjualanId}) : super(key: key);

  @override
  _AddPenjualanPageState createState() => _AddPenjualanPageState();
}

class _AddPenjualanPageState extends State<AddPenjualanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tanggalpenjualanController =
      TextEditingController();
  final TextEditingController totalhargaController = TextEditingController();
  final TextEditingController pelangganidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.penjualanId != null) {
      fetchPenjualanById(widget.penjualanId!);
    }
  }

  Future<void> fetchPenjualanById(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select()
          .eq('penjualanid', id)
          .single();
      setState(() {
        tanggalpenjualanController.text = response['tanggalpenjualan'];
        totalhargaController.text = response['totalharga'].toString();
        pelangganidController.text = response['pelangganid'].toString();
      });
    } catch (e) {
      print('Error fetching penjualan: $e');
    }
  }

  Future<void> savePenjualan() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'tanggalpenjualan': tanggalpenjualanController.text,
          'totalharga': double.tryParse(totalhargaController.text) ?? 0,
          'pelangganid': int.tryParse(pelangganidController.text) ?? 0,
        };

        if (widget.penjualanId != null) {
          await Supabase.instance.client.from('Penjualan').update(data).eq;
        } else {
          await Supabase.instance.client.from('Penjualan').insert([data]);
        }

        Navigator.pop(context, true);
      } catch (e) {
        print('Error saving penjualan: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.penjualanId != null
              ? 'Edit Penjualan'
              : 'Edit Penjualan')), //Bagian mau menambahkan penjualan
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tanggalpenjualanController,
                decoration:
                    const InputDecoration(labelText: 'Tanggal Penjualan'),
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: totalhargaController,
                decoration: const InputDecoration(labelText: 'Total Harga'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Total harga tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: pelangganidController,
                decoration: const InputDecoration(labelText: 'Pelanggan ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Pelanggan ID tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: savePenjualan,
                child: Text(widget.penjualanId != null
                    ? 'Update Penjualan'
                    : 'Update Penjualan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
