import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukkurl_2025/detailpenjualan/indexdetail.dart';

class detailTab extends StatefulWidget {
  const detailTab({super.key});

  @override
  State<detailTab> createState() => _detailTabState();
}

class _detailTabState extends State<detailTab> {
  List<Map<String, dynamic>> detailList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchdetail();
  }

  Future<void> deletedetail(int id) async {
    try {
      await Supabase.instance.client
          .from('detailpenjualan')
          .delete()
          .eq('detailid', id);

      fetchdetail();
    } catch (e) {
      debugPrint('error saat menghapus: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error saat menghapus data: $e')),
      );
    }
  }

  Future<void> fetchdetail() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*, pelanggan(*)), produk(*)');

      setState(() {
        detailList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('error saat mengambil data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                color: Colors.grey,
                size: 30,
              ))
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: detailList.length,
                itemBuilder: (context, index) {
                  final dtl = detailList[index];
                  final penjualan = dtl['penjualan'] ?? {};
                  final pelanggan = penjualan['pelanggan'] ?? {};
                  final produk = dtl['produk'] ?? {};

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: SizedBox(
                      height: 180,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'nama pelanggan : ${pelanggan['nama pelanggan'] ?? 'tidak tersedia'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'nama produk : ${produk['nama produk'] ?? 'tidak tersedia'}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'jumlah produk : ${dtl['jumlah produk'] ?? 'tidak tersedia'}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'sub total : ${dtl['sub total'] ?? 'tidak tersedia'}',
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}


