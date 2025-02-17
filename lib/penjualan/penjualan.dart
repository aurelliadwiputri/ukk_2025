import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class indexpenjualan extends StatefulWidget {
  const indexpenjualan({super.key});

  @override
  State<indexpenjualan> createState() => _indexpenjualanState();
}

class _indexpenjualanState extends State<indexpenjualan> {
  List<Map<String, dynamic>> penjualan = [];
  List<int> selectedpenjualan = [];

  @override
  void initState() {
    super.initState();
    fetchpenjualan();
  }

  Future<void> fetchpenjualan() async {
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('*,pelanggan(*)');
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: penjualan.isEmpty
            ? const Center(child: Text('data penjualan belum ditambahkan'))
            : Container(
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: penjualan.length,
                  itemBuilder: (context, index) {
                    final item = penjualan[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'nama pelanggan: ${item['pelanggan']['nama pelanggan'] ?? 'tidak tersedia'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'tanggal: ${item['tanggal penjualan'] ?? 'tidak tersedia'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'total harga: ${item['total harga'] ?? 'tidak tersedia'}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ));
  }
}
