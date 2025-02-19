import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/penjualan/insertpenjualan.dart';

class PenjualanTab extends StatefulWidget {
  const PenjualanTab({super.key});

  @override
  State<PenjualanTab> createState() => _PenjualanTabState();
}

class _PenjualanTabState extends State<PenjualanTab> {
  List<Map<String, dynamic>> penjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchpenjualan();
  }

  Future<void> fetchpenjualan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('*,pelanggan(*)')
          .order('tanggalpenjualan', ascending: false);
      print(response);
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('error fetching penjualan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletepenjualan(int id) async {
    try {
      await Supabase.instance.client
          .from('penjualan')
          .delete()
          .eq('penjualanid', id);
      fetchpenjualan();
    } catch (e) {
      print('error fetching penjualan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('penjualan');
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => fetchpenjualan(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: penjualan.length,
                itemBuilder: (context, index) {
                  final item = penjualan[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                        title: Text(item['pelanggan']['namapelanggan']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('totalharga: ${item['totalharga']}'),
                            Text(
                                'tanggalpenjualan: ${item['tanggalpenjualan']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.blue),
                          onPressed: () =>
                              _showDeleteDialog(context, item, index),
                        )),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var sales = await Navigator.of(context).push(
           MaterialPageRoute(builder: (context) => AddPenjualan()),  // nanti kalo bikin class di file insert harus Addpenjualan
           );
           if (sales == true) fetchpenjualan();
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, Map<String, dynamic> item, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('hapus pelanggan'),
            content: const Text('apakah anda ingin menghapus produk ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('batal'),
              ),
              TextButton(
                onPressed: () {
                  deletepenjualan(item['penjualanid']);
                  Navigator.pop(context);
                  setState(() => penjualan.removeAt(index));
                },
                child: const Text(
                  'hapus',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          );
        });
  }
}
